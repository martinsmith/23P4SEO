<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SitePage extends Model
{
    protected $fillable = [
        'site_id',
        'site_scan_id',
        'url',
        'title',
        'status_code',
        'canonical_url',
        'is_indexable',
        'is_noindex',
    ];

    protected function casts(): array
    {
        return [
            'is_indexable' => 'boolean',
            'is_noindex' => 'boolean',
            'last_seen_at' => 'datetime',
        ];
    }

    public function site(): BelongsTo
    {
        return $this->belongsTo(Site::class);
    }

    public function scan(): BelongsTo
    {
        return $this->belongsTo(SiteScan::class, 'site_scan_id');
    }
}

