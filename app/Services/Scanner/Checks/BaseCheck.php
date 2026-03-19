<?php

namespace App\Services\Scanner\Checks;

use App\Models\Site;
use App\Services\Scanner\CheckResult;

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
}

