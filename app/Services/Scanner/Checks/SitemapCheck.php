<?php

namespace App\Services\Scanner\Checks;

use App\Models\Site;
use App\Services\Scanner\CheckResult;
use Illuminate\Support\Facades\Http;

class SitemapCheck extends BaseCheck
{
    public function name(): string
    {
        return 'Sitemap';
    }

    public function run(Site $site): array
    {
        $findings = [];
        $baseUrl = rtrim($site->primary_url, '/');
        $sitemapUrl = $baseUrl . '/sitemap.xml';

        try {
            $response = Http::timeout(10)->get($sitemapUrl);

            if ($response->status() === 200) {
                $body = $response->body();

                // Check if it's valid XML with sitemap structure
                if (str_contains($body, '<urlset') || str_contains($body, '<sitemapindex')) {
                    $urlCount = substr_count($body, '<url>');
                    $isSitemapIndex = str_contains($body, '<sitemapindex');

                    $findings[] = new CheckResult(
                        category: 'technical',
                        code: 'sitemap_found',
                        severity: 'info',
                        title: 'XML sitemap found',
                        summary: $isSitemapIndex
                            ? 'Your site has a sitemap index file, which links to other sitemaps.'
                            : "Your site has an XML sitemap with approximately {$urlCount} URLs.",
                        evidence: [
                            'url' => $sitemapUrl,
                            'type' => $isSitemapIndex ? 'index' : 'urlset',
                            'url_count' => $urlCount,
                        ],
                    );

                    if (!$isSitemapIndex && $urlCount === 0) {
                        $findings[] = new CheckResult(
                            category: 'technical',
                            code: 'sitemap_empty',
                            severity: 'high',
                            title: 'Sitemap exists but contains no URLs',
                            summary: 'Your sitemap.xml was found but it does not list any pages. Search engines cannot discover your content through it.',
                            evidence: ['url' => $sitemapUrl],
                        );
                    }
                } else {
                    $findings[] = new CheckResult(
                        category: 'technical',
                        code: 'sitemap_invalid',
                        severity: 'high',
                        title: 'sitemap.xml exists but is not valid XML',
                        summary: 'The file at /sitemap.xml was found but does not contain valid sitemap XML.',
                        evidence: ['url' => $sitemapUrl, 'status_code' => 200],
                    );
                }
            } elseif ($response->status() === 404) {
                $findings[] = new CheckResult(
                    category: 'technical',
                    code: 'sitemap_missing',
                    severity: 'high',
                    title: 'No XML sitemap found',
                    summary: 'Your site does not have a sitemap.xml file. An XML sitemap helps search engines discover and index your pages.',
                    evidence: ['url' => $sitemapUrl, 'status_code' => 404],
                );
            } else {
                $findings[] = new CheckResult(
                    category: 'technical',
                    code: 'sitemap_error',
                    severity: 'medium',
                    title: 'Sitemap returned unexpected status',
                    summary: "The sitemap URL returned HTTP {$response->status()}.",
                    evidence: ['url' => $sitemapUrl, 'status_code' => $response->status()],
                );
            }
        } catch (\Exception $e) {
            $findings[] = new CheckResult(
                category: 'technical',
                code: 'sitemap_unreachable',
                severity: 'high',
                title: 'Could not reach sitemap.xml',
                summary: 'We were unable to fetch the sitemap. This may indicate a connectivity issue.',
                evidence: ['url' => $sitemapUrl, 'error' => $e->getMessage()],
            );
        }

        return $findings;
    }
}

