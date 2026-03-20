<?php

namespace App\Services\Scanner\Checks;

use App\Models\Site;
use App\Services\Scanner\CheckResult;
use Illuminate\Support\Facades\Http;

class MetaTagCheck extends BaseCheck
{
    public function name(): string
    {
        return 'Meta Tags & Social';
    }

    public function run(Site $site): array
    {
        $findings = [];
        $url = rtrim($site->primary_url, '/') . '/';

        try {
            $response = Http::timeout(15)
                ->withHeaders(['User-Agent' => '23P4-Scanner/1.0'])
                ->get($url);

            if ($response->status() !== 200) {
                return $findings; // Homepage checks handle this
            }

            $body = $response->body();

            // Open Graph: og:title
            $ogTitle = $this->extractMetaProperty($body, 'og:title');
            if (empty($ogTitle)) {
                $findings[] = new CheckResult(
                    category: 'social',
                    code: 'missing_og_title',
                    severity: 'medium',
                    title: 'Missing Open Graph title (og:title)',
                    summary: 'Your homepage does not have an og:title meta tag. When shared on Facebook, LinkedIn, or other platforms, the preview may look incomplete or use auto-generated text.',
                    evidence: ['url' => $url],
                );
            }

            // Open Graph: og:description
            $ogDesc = $this->extractMetaProperty($body, 'og:description');
            if (empty($ogDesc)) {
                $findings[] = new CheckResult(
                    category: 'social',
                    code: 'missing_og_description',
                    severity: 'medium',
                    title: 'Missing Open Graph description (og:description)',
                    summary: 'Your homepage is missing an og:description tag. Social shares will lack a compelling description preview.',
                    evidence: ['url' => $url],
                );
            }

            // Open Graph: og:image
            $ogImage = $this->extractMetaProperty($body, 'og:image');
            if (empty($ogImage)) {
                $findings[] = new CheckResult(
                    category: 'social',
                    code: 'missing_og_image',
                    severity: 'medium',
                    title: 'Missing Open Graph image (og:image)',
                    summary: 'Your homepage has no og:image tag. Social shares will have no image preview, which significantly reduces engagement and click-through rates.',
                    evidence: ['url' => $url],
                );
            }

            // Twitter Card
            $twitterCard = $this->extractMetaName($body, 'twitter:card');
            if (empty($twitterCard)) {
                $findings[] = new CheckResult(
                    category: 'social',
                    code: 'missing_twitter_card',
                    severity: 'low',
                    title: 'Missing Twitter Card meta tag',
                    summary: 'Your homepage does not have a twitter:card meta tag. X/Twitter shares won\'t display rich previews.',
                    evidence: ['url' => $url],
                );
            }

        } catch (\Exception $e) {
            // Homepage check handles unreachable errors
        }

        return $findings;
    }

    private function extractMetaProperty(string $html, string $property): string
    {
        $pattern = '/<meta\s+[^>]*property=["\']' . preg_quote($property, '/') . '["\'][^>]*content=["\']([^"\']*)["\'][^>]*>/i';
        if (preg_match($pattern, $html, $matches)) {
            return trim($matches[1]);
        }
        // Try reverse order
        $pattern = '/<meta\s+[^>]*content=["\']([^"\']*)["\'][^>]*property=["\']' . preg_quote($property, '/') . '["\'][^>]*>/i';
        if (preg_match($pattern, $html, $matches)) {
            return trim($matches[1]);
        }
        return '';
    }

    private function extractMetaName(string $html, string $name): string
    {
        $pattern = '/<meta\s+[^>]*name=["\']' . preg_quote($name, '/') . '["\'][^>]*content=["\']([^"\']*)["\'][^>]*>/i';
        if (preg_match($pattern, $html, $matches)) {
            return trim($matches[1]);
        }
        $pattern = '/<meta\s+[^>]*content=["\']([^"\']*)["\'][^>]*name=["\']' . preg_quote($name, '/') . '["\'][^>]*>/i';
        if (preg_match($pattern, $html, $matches)) {
            return trim($matches[1]);
        }
        return '';
    }
}

