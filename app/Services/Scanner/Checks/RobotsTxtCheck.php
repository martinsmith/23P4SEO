<?php

namespace App\Services\Scanner\Checks;

use App\Models\Site;
use App\Services\Scanner\CheckResult;
use Illuminate\Support\Facades\Http;

class RobotsTxtCheck extends BaseCheck
{
    public function name(): string
    {
        return 'Robots.txt';
    }

    public function run(Site $site): array
    {
        $findings = [];
        $url = rtrim($site->primary_url, '/') . '/robots.txt';

        try {
            $response = Http::timeout(10)->get($url);

            if ($response->status() === 200) {
                $body = $response->body();

                // Check if it's actually a robots.txt (not a soft 404)
                if (str_contains($body, 'User-agent') || str_contains($body, 'user-agent')) {
                    $findings[] = new CheckResult(
                        category: 'technical',
                        code: 'robots_txt_found',
                        severity: 'info',
                        title: 'robots.txt exists',
                        summary: 'Your site has a robots.txt file.',
                        evidence: ['url' => $url, 'size_bytes' => strlen($body)],
                    );

                    // Check for blanket disallow
                    if (preg_match('/Disallow:\s*\/\s*$/m', $body)) {
                        $findings[] = new CheckResult(
                            category: 'technical',
                            code: 'robots_txt_blocks_all',
                            severity: 'critical',
                            title: 'robots.txt blocks all crawling',
                            summary: 'Your robots.txt contains "Disallow: /" which prevents search engines from crawling your entire site.',
                            evidence: ['url' => $url, 'directive' => 'Disallow: /'],
                            isBlocker: true,
                        );
                    }

                    // Check for sitemap reference
                    if (!preg_match('/Sitemap:\s*http/i', $body)) {
                        $findings[] = new CheckResult(
                            category: 'technical',
                            code: 'robots_txt_no_sitemap',
                            severity: 'medium',
                            title: 'robots.txt does not reference a sitemap',
                            summary: 'Adding a Sitemap directive to your robots.txt helps search engines discover your sitemap faster.',
                            evidence: ['url' => $url],
                        );
                    }
                } else {
                    $findings[] = new CheckResult(
                        category: 'technical',
                        code: 'robots_txt_invalid',
                        severity: 'medium',
                        title: 'robots.txt exists but appears invalid',
                        summary: 'The file at /robots.txt was found but does not contain valid robots.txt directives.',
                        evidence: ['url' => $url, 'status_code' => 200],
                    );
                }
            } elseif ($response->status() === 404) {
                $findings[] = new CheckResult(
                    category: 'technical',
                    code: 'robots_txt_missing',
                    severity: 'medium',
                    title: 'No robots.txt found',
                    summary: 'Your site does not have a robots.txt file. While not required, it helps communicate crawling preferences to search engines.',
                    evidence: ['url' => $url, 'status_code' => 404],
                );
            } else {
                $findings[] = new CheckResult(
                    category: 'technical',
                    code: 'robots_txt_error',
                    severity: 'low',
                    title: 'robots.txt returned unexpected status',
                    summary: "The robots.txt URL returned HTTP {$response->status()}.",
                    evidence: ['url' => $url, 'status_code' => $response->status()],
                );
            }
        } catch (\Exception $e) {
            $findings[] = new CheckResult(
                category: 'technical',
                code: 'robots_txt_unreachable',
                severity: 'high',
                title: 'Could not reach robots.txt',
                summary: 'We were unable to fetch the robots.txt file. This may indicate a connectivity issue.',
                evidence: ['url' => $url, 'error' => $e->getMessage()],
            );
        }

        return $findings;
    }
}

