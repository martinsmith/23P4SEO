<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProgressEvent extends Model
{
    protected $fillable = [
        'site_id',
        'event_type',
        'headline',
        'detail',
        'related_mission_id',
        'related_keyword_id',
        'event_date',
        'meta_json',
    ];

    protected function casts(): array
    {
        return [
            'event_date' => 'date',
            'meta_json' => 'array',
        ];
    }

    public function site(): BelongsTo
    {
        return $this->belongsTo(Site::class);
    }

    public function mission(): BelongsTo
    {
        return $this->belongsTo(Mission::class, 'related_mission_id');
    }

    public function trackedKeyword(): BelongsTo
    {
        return $this->belongsTo(TrackedKeyword::class, 'related_keyword_id');
    }
}

