<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ScanFinding extends Model
{
    protected $fillable = [
        'site_id',
        'site_scan_id',
        'category',
        'code',
        'severity',
        'title',
        'summary',
        'evidence_json',
        'is_blocker',
        'status',
        'first_detected_at',
        'last_detected_at',
    ];

    protected function casts(): array
    {
        return [
            'evidence_json' => 'array',
            'is_blocker' => 'boolean',
            'first_detected_at' => 'datetime',
            'last_detected_at' => 'datetime',
            'resolved_at' => 'datetime',
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

