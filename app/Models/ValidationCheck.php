<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ValidationCheck extends Model
{
    protected $fillable = [
        'validation_run_id',
        'mission_task_id',
        'check_type',
        'result',
        'message',
        'evidence_json',
    ];

    protected function casts(): array
    {
        return [
            'evidence_json' => 'array',
        ];
    }

    public function validationRun(): BelongsTo
    {
        return $this->belongsTo(ValidationRun::class);
    }

    public function missionTask(): BelongsTo
    {
        return $this->belongsTo(MissionTask::class);
    }
}

