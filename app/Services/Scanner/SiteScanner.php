<?php

namespace App\Services\Scanner;

use App\Models\ScanFinding;
use App\Models\Site;
use App\Models\SiteScan;
use App\Services\Scanner\Checks\AnalyticsCheck;
use App\Services\Scanner\Checks\BaseCheck;
use App\Services\Scanner\Checks\HomepageCheck;
use App\Services\Scanner\Checks\LocalSEOCheck;
use App\Services\Scanner\Checks\MetaTagCheck;
use App\Services\Scanner\Checks\RobotsTxtCheck;
use App\Services\Scanner\Checks\SearchConsoleCheck;
use App\Services\Scanner\Checks\SecurityCheck;
use App\Services\Scanner\Checks\ServiceCoverageCheck;
use App\Services\Scanner\Checks\SitemapCheck;
use App\Services\Scanner\Checks\TechnicalCheck;
use Illuminate\Support\Carbon;

class SiteScanner
{
    /**
     * The ordered list of checks to run.
     *
     * @return BaseCheck[]
     */
    protected function checks(): array
    {
        return [
            new RobotsTxtCheck(),
            new SitemapCheck(),
            new HomepageCheck(),
            new MetaTagCheck(),
            new TechnicalCheck(),
            new SecurityCheck(),
            new AnalyticsCheck(),
            new SearchConsoleCheck(),
            new LocalSEOCheck(),
            new ServiceCoverageCheck(),
        ];
    }

    /**
     * Run a full scan against a site.
     */
    public function scan(Site $site): SiteScan
    {
        $scan = $site->scans()->create([
            'scan_type' => 'full',
            'status' => 'running',
            'scan_version' => 1,
            'started_at' => Carbon::now(),
        ]);

        $allFindings = [];
        $checksSummary = [];

        foreach ($this->checks() as $check) {
            $checkName = $check->name();
            $startTime = microtime(true);

            try {
                $results = $check->run($site);
                $elapsed = round(microtime(true) - $startTime, 2);

                $checksSummary[$checkName] = [
                    'status' => 'completed',
                    'findings_count' => count($results),
                    'elapsed_seconds' => $elapsed,
                ];

                foreach ($results as $result) {
                    $allFindings[] = $result;
                }
            } catch (\Exception $e) {
                $checksSummary[$checkName] = [
                    'status' => 'error',
                    'error' => $e->getMessage(),
                ];
            }
        }

        // === Site-level findings reconciliation ===
        $now = Carbon::now();
        $currentCodes = [];

        foreach ($allFindings as $finding) {
            $currentCodes[] = $finding->code;

            // Upsert: create or update keyed on site_id + code
            $existing = ScanFinding::where('site_id', $site->id)
                ->where('code', $finding->code)
                ->first();

            if ($existing) {
                $existing->update([
                    'site_scan_id' => $scan->id,
                    'category' => $finding->category,
                    'severity' => $finding->severity,
                    'title' => $finding->title,
                    'summary' => $finding->summary,
                    'evidence_json' => $finding->evidence,
                    'is_blocker' => $finding->isBlocker,
                    'status' => 'open',
                    'last_detected_at' => $now,
                    'resolved_at' => null,
                ]);
            } else {
                ScanFinding::create([
                    'site_id' => $site->id,
                    'site_scan_id' => $scan->id,
                    'category' => $finding->category,
                    'code' => $finding->code,
                    'severity' => $finding->severity,
                    'title' => $finding->title,
                    'summary' => $finding->summary,
                    'evidence_json' => $finding->evidence,
                    'is_blocker' => $finding->isBlocker,
                    'status' => 'open',
                    'first_detected_at' => $now,
                    'last_detected_at' => $now,
                ]);
            }
        }

        // Resolve findings that are no longer detected
        $resolveQuery = ScanFinding::where('site_id', $site->id)
            ->where('status', 'open');

        if (!empty($currentCodes)) {
            $resolveQuery->whereNotIn('code', $currentCodes);
        }

        $resolveQuery->update([
            'status' => 'resolved',
            'resolved_at' => $now,
        ]);

        // Count by severity
        $severityCounts = [];
        foreach ($allFindings as $f) {
            $severityCounts[$f->severity] = ($severityCounts[$f->severity] ?? 0) + 1;
        }

        $scan->update([
            'status' => 'completed',
            'completed_at' => Carbon::now(),
            'summary_json' => [
                'total_findings' => count($allFindings),
                'blockers' => count(array_filter($allFindings, fn ($f) => $f->isBlocker)),
                'severity_counts' => $severityCounts,
                'checks' => $checksSummary,
            ],
        ]);

        // Update site
        $site->update([
            'last_scanned_at' => Carbon::now(),
            'onboarding_status' => 'scanned',
        ]);

        return $scan->fresh(['findings']);
    }
}

