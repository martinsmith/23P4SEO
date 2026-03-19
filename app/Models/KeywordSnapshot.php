<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class KeywordSnapshot extends Model
{
    protected $fillable = [
        'tracked_keyword_id',
        'checked_at',
        'ranking_position',
        'found_in_results',
        'result_url',
        'top_competitor_domains_json',
        'provider',
        'raw_result_meta_json',
    ];

    protected function casts(): array
    {
        return [
            'checked_at' => 'datetime',
            'found_in_results' => 'boolean',
            'top_competitor_domains_json' => 'array',
            'raw_result_meta_json' => 'array',
        ];
    }

    public function trackedKeyword(): BelongsTo
    {
        return $this->belongsTo(TrackedKeyword::class);
    }
}

