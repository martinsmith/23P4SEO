<?php

namespace App\Services\Scanner\Checks;

use App\Models\Site;
use App\Services\Scanner\CheckResult;
use Illuminate\Support\Facades\Http;

class ServiceCoverageCheck extends BaseCheck
{
    public function name(): string
    {
        return 'Service Coverage';
    }

    public function run(Site $site): array
    {
        $services = $site->businessServices()->orderBy('priority_order')->get();

        if ($services->isEmpty()) {
            return [];
        }

        $findings = [];

        // Gather page URLs from the sitemap (or fallback to homepage links)
        $pages = $this->gatherPageUrls($site);

        // Also fetch homepage body to check for service mentions there
        $homepageBody = $this->fetchHomepageBody($site);

        $missingServices = [];

        foreach ($services as $service) {
            $serviceName = strtolower($service->service_name);

            // Check 1: Is there a page URL that references this service?
            $hasPage = $this->serviceHasPage($serviceName, $pages);

            // Check 2: Is the service at least mentioned on the homepage?
            $mentionedOnHomepage = $homepageBody && stripos(strip_tags($homepageBody), $serviceName) !== false;

            if (!$hasPage && !$mentionedOnHomepage) {
                $missingServices[] = $service->service_name;
            } elseif (!$hasPage && $mentionedOnHomepage) {
                // Mentioned but no dedicated page — medium priority suggestion
                $findings[] = new CheckResult(
                    category: 'content',
                    code: 'service_no_dedicated_page',
                    severity: 'medium',
                    title: "No dedicated page for \"{$service->service_name}\"",
                    summary: "Your homepage mentions \"{$service->service_name}\", but there doesn't appear to be a dedicated page for it. Creating a focused page for each core service helps you rank for service-specific searches.",
                    evidence: [
                        'service' => $service->service_name,
                        'mentioned_on_homepage' => true,
                    ],
                );
            }
        }

        // Services not found anywhere
        foreach ($missingServices as $serviceName) {
            $findings[] = new CheckResult(
                category: 'content',
                code: 'service_not_found',
                severity: 'high',
                title: "No content found for \"{$serviceName}\"",
                summary: "We couldn't find \"{$serviceName}\" mentioned on your site. This is one of the services you offer — creating dedicated content helps search engines understand what you do and connects you with people searching for this service.",
                evidence: [
                    'service' => $serviceName,
                    'mentioned_on_homepage' => false,
                ],
            );
        }

        return $findings;
    }

    /**
     * Gather page URLs from the sitemap. Falls back to an empty array
     * if no sitemap is available (homepage-only check will still work).
     */
    protected function gatherPageUrls(Site $site): array
    {
        $baseUrl = rtrim($site->primary_url, '/');
        $sitemapUrl = $baseUrl . '/sitemap.xml';

        try {
            $response = Http::timeout(10)
                ->withHeaders(['User-Agent' => '23P4-Scanner/1.0'])
                ->get($sitemapUrl);

            if ($response->status() !== 200) {
                return [];
            }

            $body = $response->body();

            // Extract <loc> URLs from the sitemap
            preg_match_all('/<loc>(.*?)<\/loc>/i', $body, $matches);

            return $matches[1] ?? [];
        } catch (\Exception $e) {
            return [];
        }
    }

    protected function fetchHomepageBody(Site $site): ?string
    {
        $url = rtrim($site->primary_url, '/') . '/';

        try {
            $response = Http::timeout(15)
                ->withHeaders(['User-Agent' => '23P4-Scanner/1.0'])
                ->get($url);

            return $response->status() === 200 ? $response->body() : null;
        } catch (\Exception $e) {
            return null;
        }
    }

    /**
     * Check if any page URL suggests coverage for this service.
     * Matches slugified service names against URL paths.
     */
    protected function serviceHasPage(string $serviceName, array $urls): bool
    {
        // Generate slug variants: "Lift Maintenance" → "lift-maintenance", "liftmaintenance", "lift_maintenance"
        $slug = preg_replace('/\s+/', '-', $serviceName);
        $slugNoSep = preg_replace('/[\s\-_]+/', '', $serviceName);
        $slugUnderscore = preg_replace('/\s+/', '_', $serviceName);

        foreach ($urls as $url) {
            $path = strtolower(parse_url($url, PHP_URL_PATH) ?? '');
            if (str_contains($path, $slug) || str_contains($path, $slugNoSep) || str_contains($path, $slugUnderscore)) {
                return true;
            }
        }

        return false;
    }
}

