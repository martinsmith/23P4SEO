<?php

namespace App\Jobs;

use App\Models\Site;
use App\Services\Scanner\SiteScanner;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class RunSiteScan implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public int $tries = 1;
    public int $timeout = 120;

    public function __construct(
        public readonly Site $site,
    ) {}

    public function handle(SiteScanner $scanner): void
    {
        $scanner->scan($this->site);
    }
}

