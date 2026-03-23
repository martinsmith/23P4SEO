<?php

namespace App\Services\Scanner\Checks;

use App\Models\Site;
use App\Services\Scanner\CheckResult;
use Illuminate\Http\Client\Response;
use Illuminate\Support\Facades\Http;

abstract class BaseCheck
{
    /**
     * Run the check against a site and return findings.
     *
     * @return CheckResult[]
     */
    abstract public function run(Site $site): array;

    /**
     * Human-readable name of this check.
     */
    abstract public function name(): string;

    /**
     * Fetch a URL with cache-busting headers so rescans always get fresh content.
     */
    protected function fetch(string $url, int $timeout = 15): Response
    {
        return Http::timeout($timeout)
            ->withHeaders([
                'User-Agent' => '23P4-Scanner/1.0',
                'Cache-Control' => 'no-cache, no-store, must-revalidate',
                'Pragma' => 'no-cache',
            ])
            ->get($url);
    }
}

