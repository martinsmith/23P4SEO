<?php

namespace App\Services\Scanner\Checks;

use App\Models\Site;
use App\Services\Scanner\CheckResult;

class SecurityCheck extends BaseCheck
{
    public function name(): string
    {
        return 'Security';
    }

    public function run(Site $site): array
    {
        $findings = [];
        $url = rtrim($site->primary_url, '/') . '/';

        try {
            $response = $this->fetch($url);

            $headers = $response->headers();

            // Content-Security-Policy
            if (!isset($headers['Content-Security-Policy']) && !isset($headers['content-security-policy'])) {
                $findings[] = new CheckResult(
                    category: 'security',
                    code: 'missing_csp_header',
                    severity: 'low',
                    title: 'Missing Content-Security-Policy header',
                    summary: 'Your site does not send a Content-Security-Policy (CSP) header. CSP helps prevent cross-site scripting (XSS) and data injection attacks.',
                    evidence: ['url' => $url],
                );
            }

            // X-Content-Type-Options
            $xcto = $headers['X-Content-Type-Options'][0] ?? $headers['x-content-type-options'][0] ?? null;
            if (!$xcto || strtolower($xcto) !== 'nosniff') {
                $findings[] = new CheckResult(
                    category: 'security',
                    code: 'missing_x_content_type_options',
                    severity: 'low',
                    title: 'Missing X-Content-Type-Options header',
                    summary: 'Your site does not send the X-Content-Type-Options: nosniff header. This header prevents browsers from MIME-type sniffing.',
                    evidence: ['url' => $url],
                );
            }

            // Mixed content hint — check if an HTTPS page contains HTTP resources
            if (str_starts_with($url, 'https://') && $response->status() === 200) {
                $body = $response->body();
                $mixedCount = 0;
                // Check for http:// in src and href attributes (excluding known safe like http://www.w3.org, sitemaps.org, etc.)
                preg_match_all('/(src|href)=["\']http:\/\/(?!www\.w3\.org|www\.sitemaps\.org|schema\.org)([^"\']+)/i', $body, $matches);
                $mixedCount = count($matches[0]);

                if ($mixedCount > 0) {
                    $findings[] = new CheckResult(
                        category: 'security',
                        code: 'mixed_content_detected',
                        severity: 'medium',
                        title: 'Possible mixed content detected',
                        summary: "Your HTTPS page references {$mixedCount} resource(s) over plain HTTP. Mixed content can trigger browser warnings and may block resources from loading.",
                        evidence: ['url' => $url, 'count' => $mixedCount, 'examples' => array_slice($matches[0], 0, 5)],
                    );
                }
            }

        } catch (\Exception $e) {
            // Homepage check handles unreachable
        }

        return $findings;
    }
}

