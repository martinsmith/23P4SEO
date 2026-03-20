<?php

namespace App\Services;

use App\Models\KeywordSnapshot;
use App\Models\TrackedKeyword;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class SerperSearchService
{
    protected string $apiKey;

    public function __construct()
    {
        $this->apiKey = config('services.serper.api_key', '');
    }

    public function isConfigured(): bool
    {
        return $this->apiKey !== '';
    }

    /**
     * Check ranking for a single keyword.
     * Uses Serper.dev to fetch up to 100 organic results in a single request.
     */
    public function checkRanking(TrackedKeyword $keyword): KeywordSnapshot
    {
        $site = $keyword->site;
        $domain = $site->normalized_domain;
        $query = $keyword->keyword;

        // Add location context if available
        if ($keyword->location_name) {
            if (stripos($query, $keyword->location_name) === false) {
                $query .= ' ' . $keyword->location_name;
            }
        }

        $position = null;
        $foundInResults = false;
        $resultUrl = null;
        $topCompetitors = [];
        $resultsChecked = 0;

        try {
            $response = Http::timeout(15)
                ->withHeaders([
                    'X-API-KEY' => $this->apiKey,
                    'Content-Type' => 'application/json',
                ])
                ->post('https://google.serper.dev/search', [
                    'q' => $query,
                    'gl' => 'gb',
                    'hl' => 'en',
                    'num' => 100,
                ]);

            if (!$response->ok()) {
                Log::warning('Serper API error', [
                    'status' => $response->status(),
                    'keyword' => $keyword->keyword,
                    'body' => $response->body(),
                ]);
            } else {
                $data = $response->json();
                $organic = $data['organic'] ?? [];
                $resultsChecked = count($organic);

                foreach ($organic as $index => $item) {
                    $itemUrl = $item['link'] ?? '';
                    $itemDomain = $this->extractDomain($itemUrl);
                    $absolutePosition = $index + 1;

                    // Check if this is our site
                    if (!$foundInResults && $this->domainMatches($itemDomain, $domain)) {
                        $position = $absolutePosition;
                        $foundInResults = true;
                        $resultUrl = $itemUrl;
                    }

                    // Track competitor domains (first 10 unique non-self domains)
                    if (!$this->domainMatches($itemDomain, $domain) && count($topCompetitors) < 10) {
                        if (!in_array($itemDomain, $topCompetitors)) {
                            $topCompetitors[] = $itemDomain;
                        }
                    }
                }
            }
        } catch (\Exception $e) {
            Log::error('Serper request failed', [
                'keyword' => $keyword->keyword,
                'error' => $e->getMessage(),
            ]);
        }

        return KeywordSnapshot::create([
            'tracked_keyword_id' => $keyword->id,
            'checked_at' => now(),
            'ranking_position' => $position,
            'found_in_results' => $foundInResults,
            'result_url' => $resultUrl,
            'top_competitor_domains_json' => $topCompetitors,
            'provider' => 'serper',
            'raw_result_meta_json' => [
                'query_used' => $query,
                'results_checked' => $resultsChecked,
            ],
        ]);
    }

    /**
     * Search for any appearance of a domain in organic results.
     * Searches for the domain name as a query, then separates results
     * into "your pages" (from the domain) and "mentions" (other sites referencing you).
     */
    public function searchDomainPresence(string $domain, string $location = ''): array
    {
        $query = $domain;

        try {
            $params = [
                'q' => $query,
                'gl' => 'gb',
                'hl' => 'en',
                'num' => 100,
            ];

            $response = Http::timeout(15)
                ->withHeaders([
                    'X-API-KEY' => $this->apiKey,
                    'Content-Type' => 'application/json',
                ])
                ->post('https://google.serper.dev/search', $params);

            if (!$response->ok()) {
                Log::warning('Serper domain presence search failed', [
                    'status' => $response->status(),
                    'domain' => $domain,
                    'body' => $response->body(),
                ]);
                return ['error' => 'Search API returned an error. Please try again.', 'results' => [], 'mentions' => []];
            }

            $data = $response->json();
            $organic = $data['organic'] ?? [];

            $ownPages = [];
            $mentions = [];

            foreach ($organic as $index => $item) {
                $itemUrl = $item['link'] ?? '';
                $itemDomain = $this->extractDomain($itemUrl);
                $entry = [
                    'title' => $item['title'] ?? '',
                    'link' => $itemUrl,
                    'snippet' => $item['snippet'] ?? '',
                    'position' => $index + 1,
                ];

                if ($this->domainMatches($itemDomain, $domain)) {
                    $ownPages[] = $entry;
                } else {
                    $mentions[] = $entry;
                }
            }

            return [
                'error' => null,
                'query' => $query,
                'results' => $ownPages,
                'mentions' => $mentions,
            ];
        } catch (\Exception $e) {
            Log::error('Serper domain presence search exception', [
                'domain' => $domain,
                'error' => $e->getMessage(),
            ]);
            return ['error' => 'Search request failed. Please try again.', 'results' => [], 'mentions' => []];
        }
    }

    protected function extractDomain(string $url): string
    {
        $host = parse_url($url, PHP_URL_HOST) ?? '';
        return preg_replace('/^www\./', '', strtolower($host));
    }

    protected function domainMatches(string $itemDomain, string $siteDomain): bool
    {
        $siteDomain = preg_replace('/^www\./', '', strtolower($siteDomain));
        return $itemDomain === $siteDomain || str_ends_with($itemDomain, '.' . $siteDomain);
    }
}

