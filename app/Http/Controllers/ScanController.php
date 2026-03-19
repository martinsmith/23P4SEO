<?php

namespace App\Http\Controllers;

use App\Models\Site;
use App\Models\SiteScan;
use App\Services\MissionGenerator;
use App\Services\Scanner\SiteScanner;
use Inertia\Inertia;

class ScanController extends Controller
{
    public function store(Site $site, SiteScanner $scanner, MissionGenerator $missionGenerator)
    {
        // Run synchronously for now (no queue worker needed)
        $scan = $scanner->scan($site);

        // Auto-generate missions from findings
        $missionGenerator->generateFromScan($scan);

        return redirect()->route('scans.show', [$site, $scan]);
    }

    public function show(Site $site, SiteScan $scan)
    {
        $scan->load('findings');

        return Inertia::render('Sites/ScanResults', [
            'site' => $site,
            'scan' => $scan,
            'findings' => $scan->findings->map(function ($finding) {
                return [
                    'id' => $finding->id,
                    'category' => $finding->category,
                    'code' => $finding->code,
                    'severity' => $finding->severity,
                    'title' => $finding->title,
                    'summary' => $finding->summary,
                    'evidence' => $finding->evidence_json,
                    'is_blocker' => $finding->is_blocker,
                    'status' => $finding->status,
                ];
            }),
            'summary' => $scan->summary_json,
        ]);
    }
}

