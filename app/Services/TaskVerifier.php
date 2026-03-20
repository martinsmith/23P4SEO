<?php

namespace App\Services;

use App\Models\Site;
use Illuminate\Support\Facades\Http;

class TaskVerifier
{
    /**
     * Run a verification check against a site.
     *
     * @return array{passed: bool, message: string, evidence: array}
     */
    public function verify(Site $site, string $checkName): array
    {
        return match ($checkName) {
            'robots_not_blocking' => $this->checkRobotsNotBlocking($site),
            'robots_exists' => $this->checkRobotsExists($site),
            'robots_has_sitemap' => $this->checkRobotsHasSitemap($site),
            'sitemap_exists' => $this->checkSitemapExists($site),
            'sitemap_has_urls' => $this->checkSitemapHasUrls($site),
            'homepage_indexable' => $this->checkHomepageIndexable($site),
            'homepage_has_title' => $this->checkHomepageHasTitle($site),
            'homepage_title_length' => $this->checkHomepageTitleLength($site),
            'homepage_has_meta_desc' => $this->checkHomepageHasMetaDesc($site),
            'homepage_has_h1' => $this->checkHomepageHasH1($site),
            'homepage_uses_https' => $this->checkHomepageUsesHttps($site),
            'homepage_returns_200' => $this->checkHomepageReturns200($site),
            // Meta/OG checks
            'has_og_title' => $this->checkHasMetaProperty($site, 'og:title', 'og:title'),
            'has_og_description' => $this->checkHasMetaProperty($site, 'og:description', 'og:description'),
            'has_og_image' => $this->checkHasMetaProperty($site, 'og:image', 'og:image'),
            'has_twitter_card' => $this->checkHasMetaName($site, 'twitter:card', 'twitter:card'),
            // Technical checks
            'has_canonical' => $this->checkHasCanonical($site),
            'has_structured_data' => $this->checkHasStructuredData($site),
            'has_html_lang' => $this->checkHasHtmlLang($site),
            'has_viewport' => $this->checkHasMetaName($site, 'viewport', 'viewport'),
            'has_charset' => $this->checkHasCharset($site),
            // Security checks
            'has_x_content_type_options' => $this->checkHasXContentTypeOptions($site),
            default => ['passed' => false, 'message' => "Unknown check: {$checkName}", 'evidence' => []],
        };
    }

    protected function fetchRobots(Site $site): array
    {
        $url = rtrim($site->primary_url, '/') . '/robots.txt';
        $response = Http::timeout(10)->withHeaders(['User-Agent' => '23P4-Scanner/1.0'])->get($url);
        return ['url' => $url, 'status' => $response->status(), 'body' => $response->body()];
    }

    protected function fetchSitemap(Site $site): array
    {
        $url = rtrim($site->primary_url, '/') . '/sitemap.xml';
        $response = Http::timeout(10)->withHeaders(['User-Agent' => '23P4-Scanner/1.0'])->get($url);
        return ['url' => $url, 'status' => $response->status(), 'body' => $response->body()];
    }

    protected function fetchHomepage(Site $site): array
    {
        $url = rtrim($site->primary_url, '/') . '/';
        $response = Http::timeout(15)->withHeaders(['User-Agent' => '23P4-Scanner/1.0'])->get($url);
        return [
            'url' => $url,
            'status' => $response->status(),
            'body' => $response->body(),
            'headers' => $response->headers(),
        ];
    }

    // --- Robots checks ---

    protected function checkRobotsNotBlocking(Site $site): array
    {
        $r = $this->fetchRobots($site);
        if ($r['status'] !== 200) {
            return ['passed' => false, 'message' => "robots.txt returned HTTP {$r['status']}", 'evidence' => $r];
        }
        $blocking = preg_match('/Disallow:\s*\/\s*$/m', $r['body']);
        return $blocking
            ? ['passed' => false, 'message' => 'robots.txt still contains "Disallow: /" — crawlers are blocked', 'evidence' => []]
            : ['passed' => true, 'message' => 'robots.txt is not blocking crawlers', 'evidence' => []];
    }

    protected function checkRobotsExists(Site $site): array
    {
        $r = $this->fetchRobots($site);
        $valid = $r['status'] === 200 && (str_contains($r['body'], 'User-agent') || str_contains($r['body'], 'user-agent'));
        return $valid
            ? ['passed' => true, 'message' => 'robots.txt exists and contains valid directives', 'evidence' => []]
            : ['passed' => false, 'message' => 'robots.txt not found or invalid', 'evidence' => ['status' => $r['status']]];
    }

    protected function checkRobotsHasSitemap(Site $site): array
    {
        $r = $this->fetchRobots($site);
        if ($r['status'] !== 200) {
            return ['passed' => false, 'message' => 'robots.txt not found', 'evidence' => []];
        }
        $hasSitemap = preg_match('/Sitemap:\s*http/i', $r['body']);
        return $hasSitemap
            ? ['passed' => true, 'message' => 'robots.txt contains a Sitemap directive', 'evidence' => []]
            : ['passed' => false, 'message' => 'robots.txt does not contain a Sitemap directive', 'evidence' => []];
    }

    // --- Sitemap checks ---

    protected function checkSitemapExists(Site $site): array
    {
        $r = $this->fetchSitemap($site);
        $valid = $r['status'] === 200 && (str_contains($r['body'], '<urlset') || str_contains($r['body'], '<sitemapindex'));
        return $valid
            ? ['passed' => true, 'message' => 'XML sitemap found and valid', 'evidence' => []]
            : ['passed' => false, 'message' => 'No valid XML sitemap found at /sitemap.xml', 'evidence' => ['status' => $r['status']]];
    }

    protected function checkSitemapHasUrls(Site $site): array
    {
        $r = $this->fetchSitemap($site);
        if ($r['status'] !== 200) {
            return ['passed' => false, 'message' => 'Sitemap not found', 'evidence' => []];
        }
        $urlCount = substr_count($r['body'], '<url>');
        return $urlCount > 0
            ? ['passed' => true, 'message' => "Sitemap contains {$urlCount} URLs", 'evidence' => ['url_count' => $urlCount]]
            : ['passed' => false, 'message' => 'Sitemap exists but contains no <url> entries', 'evidence' => []];
    }

    // --- Homepage checks ---

    protected function checkHomepageIndexable(Site $site): array
    {
        $h = $this->fetchHomepage($site);
        if ($h['status'] !== 200) {
            return ['passed' => false, 'message' => "Homepage returned HTTP {$h['status']}", 'evidence' => []];
        }
        $hasNoindex = preg_match('/<meta[^>]+name=["\']robots["\'][^>]+content=["\'][^"\']*noindex/i', $h['body']);
        $headerNoindex = isset($h['headers']['X-Robots-Tag']) && str_contains(implode(',', (array) $h['headers']['X-Robots-Tag']), 'noindex');
        return ($hasNoindex || $headerNoindex)
            ? ['passed' => false, 'message' => 'Homepage still has a noindex directive', 'evidence' => []]
            : ['passed' => true, 'message' => 'Homepage is indexable — no noindex directive found', 'evidence' => []];
    }

    protected function checkHomepageHasTitle(Site $site): array
    {
        $h = $this->fetchHomepage($site);
        if ($h['status'] !== 200) {
            return ['passed' => false, 'message' => "Homepage returned HTTP {$h['status']}", 'evidence' => []];
        }
        preg_match('/<title[^>]*>(.*?)<\/title>/is', $h['body'], $m);
        $title = trim($m[1] ?? '');
        return $title !== ''
            ? ['passed' => true, 'message' => "Title tag found: \"{$title}\"", 'evidence' => ['title' => $title]]
            : ['passed' => false, 'message' => 'No <title> tag found on homepage', 'evidence' => []];
    }



    protected function checkHomepageTitleLength(Site $site): array
    {
        $h = $this->fetchHomepage($site);
        if ($h['status'] !== 200) {
            return ['passed' => false, 'message' => "Homepage returned HTTP {$h['status']}", 'evidence' => []];
        }
        preg_match('/<title[^>]*>(.*?)<\/title>/is', $h['body'], $m);
        $title = trim($m[1] ?? '');
        $len = strlen($title);
        if ($title === '') {
            return ['passed' => false, 'message' => 'No title tag found', 'evidence' => []];
        }
        return $len >= 30
            ? ['passed' => true, 'message' => "Title is {$len} characters: \"{$title}\"", 'evidence' => ['title' => $title, 'length' => $len]]
            : ['passed' => false, 'message' => "Title is only {$len} characters — aim for 50–60", 'evidence' => ['title' => $title, 'length' => $len]];
    }

    protected function checkHomepageHasMetaDesc(Site $site): array
    {
        $h = $this->fetchHomepage($site);
        if ($h['status'] !== 200) {
            return ['passed' => false, 'message' => "Homepage returned HTTP {$h['status']}", 'evidence' => []];
        }
        preg_match('/<meta[^>]+name=["\']description["\'][^>]+content=["\']([^"\']*)/i', $h['body'], $m);
        $desc = trim($m[1] ?? '');
        return $desc !== ''
            ? ['passed' => true, 'message' => 'Meta description found (' . strlen($desc) . ' chars)', 'evidence' => ['description' => $desc]]
            : ['passed' => false, 'message' => 'No meta description found on homepage', 'evidence' => []];
    }

    protected function checkHomepageHasH1(Site $site): array
    {
        $h = $this->fetchHomepage($site);
        if ($h['status'] !== 200) {
            return ['passed' => false, 'message' => "Homepage returned HTTP {$h['status']}", 'evidence' => []];
        }
        preg_match('/<h1[^>]*>(.*?)<\/h1>/is', $h['body'], $m);
        $h1 = trim(strip_tags($m[1] ?? ''));
        return $h1 !== ''
            ? ['passed' => true, 'message' => "H1 found: \"{$h1}\"", 'evidence' => ['h1' => $h1]]
            : ['passed' => false, 'message' => 'No <h1> tag found on homepage', 'evidence' => []];
    }

    protected function checkHomepageUsesHttps(Site $site): array
    {
        $url = $site->primary_url;
        $passed = str_starts_with($url, 'https://');
        return $passed
            ? ['passed' => true, 'message' => 'Site uses HTTPS', 'evidence' => []]
            : ['passed' => false, 'message' => 'Site URL does not use HTTPS', 'evidence' => ['url' => $url]];
    }

    protected function checkHomepageReturns200(Site $site): array
    {
        $h = $this->fetchHomepage($site);
        return $h['status'] === 200
            ? ['passed' => true, 'message' => 'Homepage returns HTTP 200', 'evidence' => []]
            : ['passed' => false, 'message' => "Homepage returned HTTP {$h['status']}", 'evidence' => ['status' => $h['status']]];
    }

    // --- Meta/OG checks ---

    protected function checkHasMetaProperty(Site $site, string $property, string $label): array
    {
        $h = $this->fetchHomepage($site);
        if ($h['status'] !== 200) {
            return ['passed' => false, 'message' => "Homepage returned HTTP {$h['status']}", 'evidence' => []];
        }
        $pattern = '/<meta\s+[^>]*property=["\']' . preg_quote($property, '/') . '["\'][^>]*content=["\']([^"\']*)["\'][^>]*>/i';
        if (preg_match($pattern, $h['body'], $m) && trim($m[1]) !== '') {
            return ['passed' => true, 'message' => "{$label} found: \"{$m[1]}\"", 'evidence' => ['value' => $m[1]]];
        }
        // Try reverse order
        $pattern = '/<meta\s+[^>]*content=["\']([^"\']*)["\'][^>]*property=["\']' . preg_quote($property, '/') . '["\'][^>]*>/i';
        if (preg_match($pattern, $h['body'], $m) && trim($m[1]) !== '') {
            return ['passed' => true, 'message' => "{$label} found: \"{$m[1]}\"", 'evidence' => ['value' => $m[1]]];
        }
        return ['passed' => false, 'message' => "No {$label} meta tag found", 'evidence' => []];
    }

    protected function checkHasMetaName(Site $site, string $name, string $label): array
    {
        $h = $this->fetchHomepage($site);
        if ($h['status'] !== 200) {
            return ['passed' => false, 'message' => "Homepage returned HTTP {$h['status']}", 'evidence' => []];
        }
        $pattern = '/<meta[^>]+name=["\']' . preg_quote($name, '/') . '["\'][^>]*>/i';
        if (preg_match($pattern, $h['body'])) {
            return ['passed' => true, 'message' => "{$label} meta tag found", 'evidence' => []];
        }
        return ['passed' => false, 'message' => "No {$label} meta tag found", 'evidence' => []];
    }

    // --- Technical checks ---

    protected function checkHasCanonical(Site $site): array
    {
        $h = $this->fetchHomepage($site);
        if ($h['status'] !== 200) {
            return ['passed' => false, 'message' => "Homepage returned HTTP {$h['status']}", 'evidence' => []];
        }
        if (preg_match('/<link[^>]+rel=["\']canonical["\'][^>]*href=["\']([^"\']+)["\'][^>]*>/i', $h['body'], $m)
            || preg_match('/<link[^>]+href=["\']([^"\']+)["\'][^>]*rel=["\']canonical["\'][^>]*>/i', $h['body'], $m)) {
            return ['passed' => true, 'message' => "Canonical URL: {$m[1]}", 'evidence' => ['canonical' => $m[1]]];
        }
        return ['passed' => false, 'message' => 'No canonical link tag found', 'evidence' => []];
    }

    protected function checkHasStructuredData(Site $site): array
    {
        $h = $this->fetchHomepage($site);
        if ($h['status'] !== 200) {
            return ['passed' => false, 'message' => "Homepage returned HTTP {$h['status']}", 'evidence' => []];
        }
        if (preg_match('/<script[^>]+type=["\']application\/ld\+json["\'][^>]*>/i', $h['body'])) {
            return ['passed' => true, 'message' => 'JSON-LD structured data found', 'evidence' => []];
        }
        return ['passed' => false, 'message' => 'No JSON-LD structured data found', 'evidence' => []];
    }

    protected function checkHasHtmlLang(Site $site): array
    {
        $h = $this->fetchHomepage($site);
        if ($h['status'] !== 200) {
            return ['passed' => false, 'message' => "Homepage returned HTTP {$h['status']}", 'evidence' => []];
        }
        if (preg_match('/<html[^>]+lang=["\']([^"\']+)["\'][^>]*>/i', $h['body'], $m)) {
            return ['passed' => true, 'message' => "HTML lang attribute: \"{$m[1]}\"", 'evidence' => ['lang' => $m[1]]];
        }
        return ['passed' => false, 'message' => 'No lang attribute on <html> tag', 'evidence' => []];
    }

    protected function checkHasCharset(Site $site): array
    {
        $h = $this->fetchHomepage($site);
        if ($h['status'] !== 200) {
            return ['passed' => false, 'message' => "Homepage returned HTTP {$h['status']}", 'evidence' => []];
        }
        if (preg_match('/<meta[^>]+charset=["\']?[^"\'>\s]+/i', $h['body'])
            || preg_match('/<meta[^>]+http-equiv=["\']Content-Type["\'][^>]*>/i', $h['body'])) {
            return ['passed' => true, 'message' => 'Character encoding declared', 'evidence' => []];
        }
        return ['passed' => false, 'message' => 'No charset declaration found', 'evidence' => []];
    }

    // --- Security checks ---

    protected function checkHasXContentTypeOptions(Site $site): array
    {
        $h = $this->fetchHomepage($site);
        $header = $h['headers']['X-Content-Type-Options'][0] ?? $h['headers']['x-content-type-options'][0] ?? null;
        if ($header && strtolower($header) === 'nosniff') {
            return ['passed' => true, 'message' => 'X-Content-Type-Options: nosniff header present', 'evidence' => []];
        }
        return ['passed' => false, 'message' => 'X-Content-Type-Options header missing or not set to nosniff', 'evidence' => []];
    }
}
