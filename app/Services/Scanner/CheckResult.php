<?php

namespace App\Services\Scanner;

class CheckResult
{
    public function __construct(
        public readonly string $category,
        public readonly string $code,
        public readonly string $severity,  // critical, high, medium, low, info
        public readonly string $title,
        public readonly string $summary,
        public readonly array $evidence = [],
        public readonly bool $isBlocker = false,
    ) {}
}

