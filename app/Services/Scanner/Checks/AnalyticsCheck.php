<?php

namespace App\Services\Scanner\Checks;

use App\Models\Site;
use App\Services\Scanner\CheckResult;

class AnalyticsCheck extends BaseCheck
{
    public function name(): string
    {
        return 'Analytics';
    }

    public function run(Site $site): array
    {
        $findings = [];
        $url = rtrim($site->primary_url, '/') . '/';

        try {
            $response = $this->fetch($url);

            if ($response->status() !== 200) {
                return $findings; // Homepage check handles this
            }

            $body = $response->body();

            $detected = $this->detectAnalytics($body);

            if (empty($detected)) {
                $findings[] = new CheckResult(
                    category: 'analytics',
                    code: 'no_analytics_detected',
                    severity: 'high',
                    title: 'No analytics tracking detected',
                    summary: 'Your homepage does not appear to have any analytics tracking installed. Without analytics, you cannot measure traffic, understand visitor behaviour, or track the impact of SEO improvements.',
                    evidence: ['url' => $url],
                );
            } else {
                // Analytics found — record as info
                $findings[] = new CheckResult(
                    category: 'analytics',
                    code: 'analytics_found',
                    severity: 'info',
                    title: 'Analytics tracking detected',
                    summary: 'Your homepage has analytics tracking installed: ' . implode(', ', $detected) . '.',
                    evidence: ['url' => $url, 'providers' => $detected],
                );
            }

        } catch (\Exception $e) {
            // Homepage check handles unreachable errors
        }

        return $findings;
    }

    /**
     * Detect common analytics providers from the HTML body.
     *
     * @return string[] List of detected provider names
     */
    protected function detectAnalytics(string $body): array
    {
        $detected = [];

        // Google Analytics 4 (GA4) — gtag.js with G- measurement ID
        if (preg_match('/gtag\s*\(\s*[\'"]config[\'"]\s*,\s*[\'"]G-[A-Z0-9]+[\'"]/i', $body)
            || preg_match('/googletagmanager\.com\/gtag\/js\?id=G-[A-Z0-9]+/i', $body)) {
            $detected[] = 'Google Analytics 4 (GA4)';
        }

        // Google Tag Manager (GTM)
        if (preg_match('/googletagmanager\.com\/gtm\.js\?id=GTM-[A-Z0-9]+/i', $body)
            || preg_match('/googletagmanager\.com\/ns\.html\?id=GTM-[A-Z0-9]+/i', $body)) {
            $detected[] = 'Google Tag Manager';
        }

        // Universal Analytics (legacy — UA- prefix)
        if (preg_match('/google-analytics\.com\/analytics\.js/i', $body)
            || preg_match('/gtag\s*\(\s*[\'"]config[\'"]\s*,\s*[\'"]UA-[0-9]+-[0-9]+[\'"]/i', $body)) {
            $detected[] = 'Google Universal Analytics (legacy)';
        }

        // Matomo / Piwik
        if (preg_match('/matomo\.js/i', $body)
            || preg_match('/piwik\.js/i', $body)
            || preg_match('/_paq\.push/i', $body)) {
            $detected[] = 'Matomo';
        }

        // Plausible
        if (preg_match('/plausible\.io\/js\/script/i', $body)) {
            $detected[] = 'Plausible';
        }

        // Fathom
        if (preg_match('/cdn\.usefathom\.com\/script\.js/i', $body)
            || preg_match('/usefathom\.com\/script\.js/i', $body)) {
            $detected[] = 'Fathom';
        }

        // Microsoft Clarity
        if (preg_match('/clarity\.ms\/tag\//i', $body)) {
            $detected[] = 'Microsoft Clarity';
        }

        // Hotjar
        if (preg_match('/static\.hotjar\.com/i', $body)
            || preg_match('/hotjar\.com.*hj\s*\(/i', $body)) {
            $detected[] = 'Hotjar';
        }

        return $detected;
    }
}

