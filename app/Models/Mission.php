<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Mission extends Model
{
    protected $fillable = [
        'site_id',
        'source_scan_id',
        'source_type',
        'source_finding_title',
        'category',
        'status',
        'priority_score',
        'impact_level',
        'effort_level',
        'outcome_statement',
        'user_summary',
        'rationale_summary',
        'resources_json',
        'created_by',
    ];

    protected function casts(): array
    {
        return [
            'activated_at' => 'datetime',
            'completed_at' => 'datetime',
            'resources_json' => 'array',
        ];
    }

    public function site(): BelongsTo
    {
        return $this->belongsTo(Site::class);
    }

    public function sourceScan(): BelongsTo
    {
        return $this->belongsTo(SiteScan::class, 'source_scan_id');
    }

    public function tasks(): HasMany
    {
        return $this->hasMany(MissionTask::class)->orderBy('sort_order');
    }

    public function validationRuns(): HasMany
    {
        return $this->hasMany(ValidationRun::class);
    }

    public function progressEvents(): HasMany
    {
        return $this->hasMany(ProgressEvent::class, 'related_mission_id');
    }
}

