<?php

namespace App\Services\Scanner\Checks;

use App\Models\Site;
use App\Services\Scanner\CheckResult;

class LocalSEOCheck extends BaseCheck
{
    public function name(): string
    {
        return 'Local SEO';
    }

    public function run(Site $site): array
    {
        $profile = $site->businessProfile;

        // Only run if the user has set up a business profile with local relevance
        if (!$profile || !$profile->primary_location) {
            return [];
        }

        // Only relevant for local or hybrid service models
        if ($profile->service_model && !in_array($profile->service_model, ['local', 'hybrid'])) {
            return [];
        }

        $findings = [];
        $url = rtrim($site->primary_url, '/') . '/';

        try {
            $response = $this->fetch($url);

            if ($response->status() !== 200) {
                return $findings;
            }

            $body = $response->body();
            $location = $profile->primary_location;

            // 1. Location mention on homepage
            if (!$this->mentionsLocation($body, $location)) {
                $findings[] = new CheckResult(
                    category: 'local_seo',
                    code: 'homepage_no_location',
                    severity: 'high',
                    title: "Homepage doesn't mention your location",
                    summary: "Your homepage does not appear to mention \"{$location}\". For local businesses, having your location visible on the homepage helps search engines connect your site to local searches.",
                    evidence: ['url' => $url, 'location' => $location],
                );
            }

            // 2. Title tag includes location
            $title = $this->extractTitle($body);
            if ($title && !$this->mentionsLocation($title, $location)) {
                $findings[] = new CheckResult(
                    category: 'local_seo',
                    code: 'title_no_location',
                    severity: 'medium',
                    title: "Page title doesn't include your location",
                    summary: "Your homepage title tag (\"{$title}\") doesn't mention \"{$location}\". Including your location in the title tag is one of the strongest local SEO signals.",
                    evidence: ['url' => $url, 'title' => $title, 'location' => $location],
                );
            }

            // 3. LocalBusiness structured data
            if (!$this->hasLocalBusinessSchema($body)) {
                $findings[] = new CheckResult(
                    category: 'local_seo',
                    code: 'no_local_schema',
                    severity: 'medium',
                    title: 'No LocalBusiness structured data',
                    summary: 'Your homepage does not contain LocalBusiness (or a subtype) structured data. This schema markup helps Google understand your business name, address, opening hours, and service area — improving your chances of appearing in local search results and the map pack.',
                    evidence: ['url' => $url],
                );
            }

            // 4. Google Business Profile link
            if (!$this->hasGBPLink($body)) {
                $findings[] = new CheckResult(
                    category: 'local_seo',
                    code: 'no_gbp_link',
                    severity: 'medium',
                    title: 'No Google Business Profile link found',
                    summary: 'Your homepage does not appear to link to a Google Business Profile (Google Maps or business.google.com). Linking to your GBP listing reinforces your local presence and helps customers find directions, reviews, and contact details.',
                    evidence: ['url' => $url],
                );
            }

            // 5. NAP (Name, Address, Phone) presence
            $businessName = $profile->business_name;
            if ($businessName && !$this->mentionsText($body, $businessName)) {
                $findings[] = new CheckResult(
                    category: 'local_seo',
                    code: 'homepage_no_business_name',
                    severity: 'medium',
                    title: "Homepage doesn't display your business name",
                    summary: "Your homepage doesn't appear to contain your business name (\"{$businessName}\") in visible text. Displaying your business name consistently helps search engines verify your identity.",
                    evidence: ['url' => $url, 'business_name' => $businessName],
                );
            }

        } catch (\Exception $e) {
            // Homepage check handles unreachable errors
        }

        return $findings;
    }

    protected function mentionsLocation(string $text, string $location): bool
    {
        // Check the full location string, and also individual significant words (3+ chars)
        if (stripos($text, $location) !== false) {
            return true;
        }
        $words = preg_split('/[\s,]+/', $location);
        $significantWords = array_filter($words, fn($w) => strlen($w) >= 3);
        foreach ($significantWords as $word) {
            if (stripos($text, $word) !== false) {
                return true;
            }
        }
        return false;
    }

    protected function mentionsText(string $html, string $text): bool
    {
        return stripos(strip_tags($html), $text) !== false;
    }

    protected function extractTitle(string $html): string
    {
        if (preg_match('/<title[^>]*>(.*?)<\/title>/is', $html, $m)) {
            return trim(html_entity_decode($m[1]));
        }
        return '';
    }

    protected function hasLocalBusinessSchema(string $html): bool
    {
        // JSON-LD
        if (preg_match('/"@type"\s*:\s*"(LocalBusiness|[A-Za-z]*LocalBusiness[A-Za-z]*|Store|Restaurant|MedicalBusiness|LegalService|FinancialService|RealEstateAgent|HomeAndConstructionBusiness|ProfessionalService|AutomotiveBusiness|EntertainmentBusiness|HealthAndBeautyBusiness|SportsActivityLocation|LodgingBusiness|FoodEstablishment|Plumber|Electrician|HVACBusiness|Locksmith|MovingCompany|RoofingContractor|GeneralContractor)"/i', $html)) {
            return true;
        }
        // Microdata
        if (preg_match('/itemtype=["\']https?:\/\/schema\.org\/LocalBusiness/i', $html)) {
            return true;
        }
        return false;
    }

    protected function hasGBPLink(string $html): bool
    {
        // Google Maps links, Google Business Profile links
        return (bool) preg_match('/href=["\'][^"\']*(?:google\.com\/maps|maps\.google|goo\.gl\/maps|business\.google\.com|g\.page)/i', $html);
    }
}

