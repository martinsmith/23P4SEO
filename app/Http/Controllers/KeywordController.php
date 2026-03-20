<?php

namespace App\Http\Controllers;

use App\Models\Site;
use App\Models\TrackedKeyword;
use App\Services\SerperSearchService;
use App\Services\KeywordSuggestionService;
use Illuminate\Http\Request;

class KeywordController extends Controller
{
    public function store(Request $request, Site $site)
    {
        $validated = $request->validate([
            'keyword' => ['required', 'string', 'max:255'],
            'intent_type' => ['nullable', 'string', 'max:50'],
            'target_url' => ['nullable', 'url', 'max:2048'],
        ]);

        $profile = $site->businessProfile;
        $location = $profile?->primary_location ?? $site->primary_location;

        $site->trackedKeywords()->create([
            'keyword' => trim($validated['keyword']),
            'intent_type' => $validated['intent_type'] ?? 'service',
            'target_url' => $validated['target_url'] ?? null,
            'location_name' => $location,
            'status' => 'active',
        ]);

        return redirect()->back();
    }

    public function bulkStore(Request $request, Site $site)
    {
        $validated = $request->validate([
            'keywords' => ['required', 'array', 'max:20'],
            'keywords.*.keyword' => ['required', 'string', 'max:255'],
            'keywords.*.intent_type' => ['nullable', 'string', 'max:50'],
        ]);

        $profile = $site->businessProfile;
        $location = $profile?->primary_location ?? $site->primary_location;
        $existing = $site->trackedKeywords()->pluck('keyword')->map(fn($k) => strtolower($k))->toArray();

        foreach ($validated['keywords'] as $kw) {
            $keyword = trim($kw['keyword']);
            if ($keyword === '' || in_array(strtolower($keyword), $existing)) {
                continue;
            }
            $existing[] = strtolower($keyword);

            $site->trackedKeywords()->create([
                'keyword' => $keyword,
                'intent_type' => $kw['intent_type'] ?? 'service',
                'location_name' => $location,
                'status' => 'active',
            ]);
        }

        return redirect()->back();
    }

    public function destroy(Site $site, TrackedKeyword $keyword)
    {
        abort_unless($keyword->site_id === $site->id, 404);
        $keyword->delete();

        return redirect()->back();
    }

    public function suggestions(Site $site)
    {
        $service = new KeywordSuggestionService();
        $suggestions = $service->suggest($site);

        return response()->json(['suggestions' => $suggestions]);
    }

    public function checkRanking(Site $site, TrackedKeyword $keyword)
    {
        abort_unless($keyword->site_id === $site->id, 404);

        $searchService = new SerperSearchService();

        if (!$searchService->isConfigured()) {
            return response()->json([
                'error' => 'Serper API is not configured. Add SERPER_API_KEY to your .env file.',
            ], 422);
        }

        $snapshot = $searchService->checkRanking($keyword);

        // Build ETHOS-style response
        $response = $this->formatRankingResponse($keyword, $snapshot);

        return response()->json($response);
    }

    public function checkAllRankings(Site $site)
    {
        $searchService = new SerperSearchService();

        if (!$searchService->isConfigured()) {
            return response()->json([
                'error' => 'Serper API is not configured.',
            ], 422);
        }

        $keywords = $site->trackedKeywords()->where('status', 'active')->get();
        $results = [];

        foreach ($keywords as $keyword) {
            $snapshot = $searchService->checkRanking($keyword);
            $results[] = $this->formatRankingResponse($keyword, $snapshot);
            // Brief pause to respect rate limits
            usleep(200_000);
        }

        return redirect()->back();
    }

    protected function formatRankingResponse(TrackedKeyword $keyword, $snapshot): array
    {
        $previous = $keyword->snapshots()
            ->where('id', '!=', $snapshot->id)
            ->orderByDesc('checked_at')
            ->first();

        // Status
        if (!$snapshot->found_in_results) {
            $status = 'Not found in the top 50 results';
        } else {
            $status = "Ranking #{$snapshot->ranking_position}";
            if ($previous && $previous->found_in_results && $previous->ranking_position) {
                $diff = $previous->ranking_position - $snapshot->ranking_position;
                if ($diff > 0) {
                    $status .= " (up {$diff} from #{$previous->ranking_position})";
                } elseif ($diff < 0) {
                    $status .= " (down " . abs($diff) . " from #{$previous->ranking_position})";
                }
            }
        }

        // Meaning
        if (!$snapshot->found_in_results) {
            $meaning = 'You have very low visibility for this search term. Your site does not appear in the first 50 results.';
        } elseif ($snapshot->ranking_position <= 3) {
            $meaning = 'Excellent visibility — you are in the top 3 results. Maintain your content and authority.';
        } elseif ($snapshot->ranking_position <= 10) {
            $meaning = 'You are on page 1 — strong visibility. Small improvements could push you higher.';
        } elseif ($snapshot->ranking_position <= 20) {
            $meaning = 'You are close to page 1. This is a strong opportunity to improve with targeted effort.';
        } else {
            $meaning = 'You have limited visibility for this term. Dedicated content and link building could help.';
        }

        return [
            'keyword_id' => $keyword->id,
            'keyword' => $keyword->keyword,
            'snapshot_id' => $snapshot->id,
            'checked_at' => $snapshot->checked_at->toDateTimeString(),
            'status' => $status,
            'meaning' => $meaning,
            'position' => $snapshot->ranking_position,
            'found' => $snapshot->found_in_results,
            'result_url' => $snapshot->result_url,
            'top_competitors' => $snapshot->top_competitor_domains_json ?? [],
        ];
    }
}

