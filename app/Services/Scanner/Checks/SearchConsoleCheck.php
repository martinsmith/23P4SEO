<?php

namespace App\Services\Scanner\Checks;

use App\Models\Site;
use App\Services\Scanner\CheckResult;
use Illuminate\Support\Facades\Http;

class SearchConsoleCheck extends BaseCheck
{
    public function name(): string
    {
        return 'Search Console';
    }

    public function run(Site $site): array
    {
        $findings = [];
        $baseUrl = rtrim($site->primary_url, '/');
        $url = $baseUrl . '/';

        try {
            $response = Http::timeout(15)
                ->withHeaders(['User-Agent' => '23P4-Scanner/1.0'])
                ->get($url);

            if ($response->status() !== 200) {
                return $findings;
            }

            $body = $response->body();
            $verified = $this->detectVerification($body, $baseUrl);

            if (empty($verified)) {
                $findings[] = new CheckResult(
                    category: 'visibility',
                    code: 'no_search_console',
                    severity: 'high',
                    title: 'Google Search Console not detected',
                    summary: 'Your site does not appear to have Google Search Console verification set up. Search Console is essential for monitoring how Google sees your site, submitting sitemaps, requesting indexing, and diagnosing crawl issues.',
                    evidence: ['url' => $url],
                );
            } else {
                $findings[] = new CheckResult(
                    category: 'visibility',
                    code: 'search_console_verified',
                    severity: 'info',
                    title: 'Google Search Console verification detected',
                    summary: 'Your site has Google Search Console verification: ' . implode(', ', $verified) . '.',
                    evidence: ['url' => $url, 'methods' => $verified],
                );
            }

        } catch (\Exception $e) {
            // Homepage check handles unreachable errors
        }

        return $findings;
    }

    /**
     * Detect Google Search Console verification methods.
     *
     * @return string[] List of detected verification methods
     */
    protected function detectVerification(string $body, string $baseUrl): array
    {
        $detected = [];

        // Meta tag verification: <meta name="google-site-verification" content="..." />
        // This is the only reliable proof that Search Console is actually set up.
        if (preg_match('/<meta[^>]+name=["\']google-site-verification["\'][^>]*content=["\']([^"\']+)["\'][^>]*>/i', $body)
            || preg_match('/<meta[^>]+content=["\']([^"\']+)["\'][^>]*name=["\']google-site-verification["\'][^>]*>/i', $body)) {
            $detected[] = 'meta tag verification';
        }

        return $detected;
    }
}

