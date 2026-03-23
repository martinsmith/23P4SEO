<?php

namespace App\Services\Scanner\Checks;

use App\Models\Site;
use App\Services\Scanner\CheckResult;

class TechnicalCheck extends BaseCheck
{
    public function name(): string
    {
        return 'Technical SEO';
    }

    public function run(Site $site): array
    {
        $findings = [];
        $url = rtrim($site->primary_url, '/') . '/';

        try {
            $response = $this->fetch($url);

            if ($response->status() !== 200) {
                return $findings;
            }

            $body = $response->body();

            // Canonical URL
            if (!preg_match('/<link[^>]+rel=["\']canonical["\'][^>]*href=["\']([^"\']+)["\'][^>]*>/i', $body)
                && !preg_match('/<link[^>]+href=["\']([^"\']+)["\'][^>]*rel=["\']canonical["\'][^>]*>/i', $body)) {
                $findings[] = new CheckResult(
                    category: 'technical',
                    code: 'missing_canonical',
                    severity: 'medium',
                    title: 'Missing canonical URL tag',
                    summary: 'Your homepage does not specify a canonical URL. This can lead to duplicate content issues if your page is accessible at multiple URLs.',
                    evidence: ['url' => $url],
                );
            }

            // JSON-LD Structured Data
            if (!preg_match('/<script[^>]+type=["\']application\/ld\+json["\'][^>]*>/i', $body)) {
                $findings[] = new CheckResult(
                    category: 'technical',
                    code: 'missing_structured_data',
                    severity: 'medium',
                    title: 'No JSON-LD structured data found',
                    summary: 'Your homepage has no JSON-LD structured data. Adding schema markup helps search engines understand your business and can enable rich results (star ratings, FAQs, breadcrumbs).',
                    evidence: ['url' => $url],
                );
            }

            // lang attribute on <html>
            if (!preg_match('/<html[^>]+lang=["\']([^"\']+)["\'][^>]*>/i', $body)) {
                $findings[] = new CheckResult(
                    category: 'technical',
                    code: 'missing_html_lang',
                    severity: 'medium',
                    title: 'Missing lang attribute on <html> tag',
                    summary: 'Your homepage\'s <html> tag does not specify a language. This helps search engines and screen readers understand the page language.',
                    evidence: ['url' => $url],
                );
            }

            // Viewport meta tag
            if (!preg_match('/<meta[^>]+name=["\']viewport["\'][^>]*>/i', $body)) {
                $findings[] = new CheckResult(
                    category: 'technical',
                    code: 'missing_viewport',
                    severity: 'high',
                    title: 'Missing viewport meta tag',
                    summary: 'Your homepage does not have a viewport meta tag. Without it, your site will not display properly on mobile devices, which is a key Google ranking factor.',
                    evidence: ['url' => $url],
                );
            }

            // Charset
            $hasCharset = preg_match('/<meta[^>]+charset=["\']?[^"\'>\s]+/i', $body)
                || preg_match('/<meta[^>]+http-equiv=["\']Content-Type["\'][^>]*>/i', $body);
            if (!$hasCharset) {
                $findings[] = new CheckResult(
                    category: 'technical',
                    code: 'missing_charset',
                    severity: 'low',
                    title: 'Missing character encoding declaration',
                    summary: 'Your homepage does not declare a character encoding (charset). This could cause text rendering issues in some browsers.',
                    evidence: ['url' => $url],
                );
            }

        } catch (\Exception $e) {
            // Homepage check handles unreachable
        }

        return $findings;
    }
}

