<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class MissionTask extends Model
{
    protected $fillable = [
        'mission_id',
        'sort_order',
        'task_text',
        'task_type',
        'target_url',
        'validation_rule_json',
        'status',
    ];

    protected function casts(): array
    {
        return [
            'validation_rule_json' => 'array',
            'completed_at' => 'datetime',
        ];
    }

    public function mission(): BelongsTo
    {
        return $this->belongsTo(Mission::class);
    }

    public function validationChecks(): HasMany
    {
        return $this->hasMany(ValidationCheck::class);
    }
}

