<?php

namespace App\Services;

use App\Models\Site;
use Illuminate\Support\Facades\Http;

class SitemapGenerator
{
    protected int $maxPages;
    protected int $maxDepth;
    protected int $timeout;
    protected array $visited = [];
    protected array $urls = [];
    protected string $baseDomain;
    protected string $baseUrl;

    public function __construct(int $maxPages = 100, int $maxDepth = 3, int $timeout = 10)
    {
        $this->maxPages = $maxPages;
        $this->maxDepth = $maxDepth;
        $this->timeout = $timeout;
    }

    /**
     * Crawl the site and return XML sitemap string.
     *
     * @return array{xml: string, url_count: int, errors: array}
     */
    public function generate(Site $site): array
    {
        $this->baseUrl = rtrim($site->primary_url, '/');
        $parsed = parse_url($this->baseUrl);
        $this->baseDomain = ($parsed['scheme'] ?? 'https') . '://' . ($parsed['host'] ?? '');

        $this->visited = [];
        $this->urls = [];

        // Start crawl from homepage at depth 0
        $this->crawl($this->baseUrl . '/', 0);

        // Sort URLs alphabetically
        sort($this->urls);

        $xml = $this->buildXml();

        return [
            'xml' => $xml,
            'url_count' => count($this->urls),
            'errors' => [],
        ];
    }

    protected function crawl(string $url, int $depth): void
    {
        // Normalize URL
        $url = strtok($url, '#'); // remove fragment
        $url = rtrim($url, '/');
        if ($url === '') return;

        // Skip if already visited, limit reached, or too deep
        if (isset($this->visited[$url]) || count($this->urls) >= $this->maxPages || $depth > $this->maxDepth) {
            return;
        }

        $this->visited[$url] = true;

        // Skip non-HTML resources
        if (preg_match('/\.(jpg|jpeg|png|gif|svg|webp|pdf|css|js|ico|woff|woff2|ttf|eot|mp4|mp3|zip|gz)$/i', $url)) {
            return;
        }

        // Must be same domain
        if (!str_starts_with($url, $this->baseDomain)) {
            return;
        }

        try {
            $response = Http::timeout($this->timeout)
                ->withHeaders(['User-Agent' => '23P4-SitemapGenerator/1.0'])
                ->get($url);

            if ($response->status() !== 200) {
                return;
            }

            $contentType = $response->header('Content-Type') ?? '';
            if (!str_contains($contentType, 'text/html')) {
                return;
            }

            $body = $response->body();

            // Check for noindex - skip these pages
            if (preg_match('/<meta[^>]+name=["\']robots["\'][^>]+content=["\'][^"\']*noindex/i', $body)) {
                return;
            }

            // Add to sitemap
            $this->urls[] = $url;

            // Extract internal links
            preg_match_all('/href=["\']([^"\']+)["\']/i', $body, $matches);

            foreach ($matches[1] as $href) {
                $resolved = $this->resolveUrl($href);
                if ($resolved && str_starts_with($resolved, $this->baseDomain)) {
                    $this->crawl($resolved, $depth + 1);
                }
            }
        } catch (\Exception $e) {
            // Silently skip unreachable pages
        }
    }

    protected function resolveUrl(string $href): ?string
    {
        // Skip anchors, javascript, mailto, tel
        if (str_starts_with($href, '#') || str_starts_with($href, 'javascript:') ||
            str_starts_with($href, 'mailto:') || str_starts_with($href, 'tel:')) {
            return null;
        }

        // Absolute URL
        if (str_starts_with($href, 'http://') || str_starts_with($href, 'https://')) {
            return rtrim(strtok($href, '#'), '/');
        }

        // Protocol-relative
        if (str_starts_with($href, '//')) {
            $scheme = parse_url($this->baseDomain, PHP_URL_SCHEME) ?? 'https';
            return rtrim(strtok($scheme . ':' . $href, '#'), '/');
        }

        // Relative URL
        return rtrim(strtok($this->baseDomain . '/' . ltrim($href, '/'), '#'), '/');
    }

    protected function buildXml(): string
    {
        $lines = ['<?xml version="1.0" encoding="UTF-8"?>'];
        $lines[] = '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">';

        foreach ($this->urls as $url) {
            $escaped = htmlspecialchars($url, ENT_XML1, 'UTF-8');
            $lines[] = '  <url>';
            $lines[] = '    <loc>' . $escaped . '</loc>';
            $lines[] = '    <lastmod>' . date('Y-m-d') . '</lastmod>';
            $lines[] = '  </url>';
        }

        $lines[] = '</urlset>';

        return implode("\n", $lines);
    }
}

