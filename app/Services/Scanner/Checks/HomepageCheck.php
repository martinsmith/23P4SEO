<?php

namespace App\Services\Scanner\Checks;

use App\Models\Site;
use App\Services\Scanner\CheckResult;

class HomepageCheck extends BaseCheck
{
    public function name(): string
    {
        return 'Homepage';
    }

    public function run(Site $site): array
    {
        $findings = [];
        $url = rtrim($site->primary_url, '/') . '/';

        try {
            $response = $this->fetch($url);

            $statusCode = $response->status();
            $body = $response->body();
            $headers = $response->headers();

            // Status code check
            if ($statusCode !== 200) {
                $findings[] = new CheckResult(
                    category: 'technical',
                    code: 'homepage_not_200',
                    severity: $statusCode >= 500 ? 'critical' : 'high',
                    title: "Homepage returns HTTP {$statusCode}",
                    summary: "Your homepage returned a {$statusCode} status code instead of 200. Search engines may not index it properly.",
                    evidence: ['url' => $url, 'status_code' => $statusCode],
                    isBlocker: $statusCode >= 500,
                );

                return $findings; // No point parsing HTML of a broken page
            }

            // Title tag
            $title = $this->extractTag($body, 'title');
            if (empty($title)) {
                $findings[] = new CheckResult(
                    category: 'content',
                    code: 'homepage_no_title',
                    severity: 'critical',
                    title: 'Homepage has no title tag',
                    summary: 'Your homepage is missing a <title> tag. This is one of the most important SEO elements.',
                    evidence: ['url' => $url],
                    isBlocker: true,
                );
            } elseif (strlen($title) < 10) {
                $findings[] = new CheckResult(
                    category: 'content',
                    code: 'homepage_title_too_short',
                    severity: 'high',
                    title: 'Homepage title is very short',
                    summary: "Your title tag is only " . strlen($title) . " characters. Aim for 50–60 characters for best results.",
                    evidence: ['url' => $url, 'title' => $title, 'length' => strlen($title)],
                );
            } elseif (strlen($title) > 70) {
                $findings[] = new CheckResult(
                    category: 'content',
                    code: 'homepage_title_too_long',
                    severity: 'low',
                    title: 'Homepage title may be truncated in search results',
                    summary: "Your title tag is " . strlen($title) . " characters. Titles over ~60 characters may be cut off in Google.",
                    evidence: ['url' => $url, 'title' => $title, 'length' => strlen($title)],
                );
            }

            // Meta description
            $metaDesc = $this->extractMetaContent($body, 'description');
            if (empty($metaDesc)) {
                $findings[] = new CheckResult(
                    category: 'content',
                    code: 'homepage_no_meta_description',
                    severity: 'high',
                    title: 'Homepage has no meta description',
                    summary: 'Your homepage is missing a meta description. This text often appears in search results.',
                    evidence: ['url' => $url],
                );
            } elseif (strlen($metaDesc) > 160) {
                $findings[] = new CheckResult(
                    category: 'content',
                    code: 'homepage_meta_description_long',
                    severity: 'low',
                    title: 'Meta description may be truncated',
                    summary: "Your meta description is " . strlen($metaDesc) . " characters. Aim for 150–160 characters.",
                    evidence: ['url' => $url, 'length' => strlen($metaDesc)],
                );
            }

            // Noindex check
            $robotsMeta = $this->extractMetaContent($body, 'robots');
            $xRobotsHeader = $headers['X-Robots-Tag'][0] ?? '';

            if (str_contains(strtolower($robotsMeta . ' ' . $xRobotsHeader), 'noindex')) {
                $findings[] = new CheckResult(
                    category: 'technical',
                    code: 'homepage_noindex',
                    severity: 'critical',
                    title: 'Homepage is set to noindex',
                    summary: 'Your homepage has a noindex directive, which tells search engines not to include it in results.',
                    evidence: [
                        'url' => $url,
                        'meta_robots' => $robotsMeta,
                        'x_robots_tag' => $xRobotsHeader,
                    ],
                    isBlocker: true,
                );
            }

            // H1 check
            if (!preg_match('/<h1[^>]*>(.*?)<\/h1>/is', $body, $h1Match)) {
                $findings[] = new CheckResult(
                    category: 'content',
                    code: 'homepage_no_h1',
                    severity: 'medium',
                    title: 'Homepage has no H1 heading',
                    summary: 'Your homepage does not have an H1 tag. The H1 should describe what the page is about.',
                    evidence: ['url' => $url],
                );
            }

            // HTTPS check
            if (!str_starts_with($url, 'https://')) {
                $findings[] = new CheckResult(
                    category: 'technical',
                    code: 'homepage_not_https',
                    severity: 'high',
                    title: 'Site is not using HTTPS',
                    summary: 'Your site is not served over HTTPS. Google uses HTTPS as a ranking signal.',
                    evidence: ['url' => $url],
                );
            }
        } catch (\Exception $e) {
            $findings[] = new CheckResult(
                category: 'technical',
                code: 'homepage_unreachable',
                severity: 'critical',
                title: 'Homepage is unreachable',
                summary: 'We could not load your homepage. This is a serious issue — if we cannot reach it, search engines probably cannot either.',
                evidence: ['url' => $url, 'error' => $e->getMessage()],
                isBlocker: true,
            );
        }

        return $findings;
    }

    private function extractTag(string $html, string $tag): string
    {
        if (preg_match("/<{$tag}[^>]*>(.*?)<\/{$tag}>/is", $html, $matches)) {
            return trim(strip_tags($matches[1]));
        }

        return '';
    }

    private function extractMetaContent(string $html, string $name): string
    {
        $pattern = '/<meta\s+[^>]*name=["\']' . preg_quote($name, '/') . '["\'][^>]*content=["\']([^"\']*)["\'][^>]*>/i';
        if (preg_match($pattern, $html, $matches)) {
            return trim($matches[1]);
        }

        // Try reverse order (content before name)
        $pattern = '/<meta\s+[^>]*content=["\']([^"\']*)["\'][^>]*name=["\']' . preg_quote($name, '/') . '["\'][^>]*>/i';
        if (preg_match($pattern, $html, $matches)) {
            return trim($matches[1]);
        }

        return '';
    }
}

