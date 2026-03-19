<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class SiteScan extends Model
{
    protected $fillable = [
        'site_id',
        'scan_type',
        'status',
        'scan_version',
        'summary_json',
        'started_at',
        'completed_at',
    ];

    protected function casts(): array
    {
        return [
            'started_at' => 'datetime',
            'completed_at' => 'datetime',
            'summary_json' => 'array',
        ];
    }

    public function site(): BelongsTo
    {
        return $this->belongsTo(Site::class);
    }

    public function pages(): HasMany
    {
        return $this->hasMany(SitePage::class);
    }

    public function findings(): HasMany
    {
        return $this->hasMany(ScanFinding::class);
    }

    public function missions(): HasMany
    {
        return $this->hasMany(Mission::class, 'source_scan_id');
    }
}

