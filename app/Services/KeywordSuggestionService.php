<?php

namespace App\Services;

use App\Models\Site;

class KeywordSuggestionService
{
    /**
     * Generate keyword suggestions based on the site's business context.
     * Combines services, location, and competitor analysis.
     *
     * @return array<array{keyword: string, intent_type: string, source: string}>
     */
    public function suggest(Site $site): array
    {
        $suggestions = [];
        $existing = $site->trackedKeywords()->pluck('keyword')->map(fn($k) => strtolower($k))->toArray();

        $profile = $site->businessProfile;
        $services = $site->businessServices()->where('active', true)->orderBy('priority_order')->get();
        $competitors = $site->competitors()->where('active', true)->get();

        $location = $profile?->primary_location ?? $site->primary_location;
        $businessName = $profile?->business_name;
        $businessType = $profile?->business_type;

        // 1. Service + location combinations (highest value)
        foreach ($services as $service) {
            $name = $service->service_name;

            // "[service]" alone
            $this->addSuggestion($suggestions, $existing, $name, 'service', 'services');

            // "[service] [location]"
            if ($location) {
                $this->addSuggestion($suggestions, $existing, "{$name} {$location}", 'service_local', 'services+location');
            }

            // "[service] near me" — common local intent pattern
            if ($location) {
                $this->addSuggestion($suggestions, $existing, "{$name} near me", 'service_local', 'services');
            }
        }

        // 2. Business type + location
        if ($businessType && $location) {
            $this->addSuggestion($suggestions, $existing, "{$businessType} {$location}", 'brand_local', 'business_type+location');
            $this->addSuggestion($suggestions, $existing, "{$businessType} near me", 'brand_local', 'business_type');
        }

        // 3. Brand name searches
        if ($businessName) {
            $this->addSuggestion($suggestions, $existing, $businessName, 'brand', 'brand');
            if ($location) {
                $this->addSuggestion($suggestions, $existing, "{$businessName} {$location}", 'brand_local', 'brand+location');
            }
        }

        // 4. Competitor-inspired: use competitor domains as signals
        // For now, suggest checking common service terms competitors might rank for
        foreach ($competitors as $competitor) {
            if ($competitor->label) {
                // If competitor has a label like "ABC Lifts", suggest that as a competitive keyword
                $this->addSuggestion($suggestions, $existing, $competitor->label, 'competitor', 'competitor_brand');
            }
        }

        return $suggestions;
    }

    protected function addSuggestion(array &$suggestions, array &$existing, string $keyword, string $intentType, string $source): void
    {
        $normalised = strtolower(trim($keyword));
        if ($normalised === '' || in_array($normalised, $existing)) {
            return;
        }
        $existing[] = $normalised;
        $suggestions[] = [
            'keyword' => trim($keyword),
            'intent_type' => $intentType,
            'source' => $source,
        ];
    }
}

