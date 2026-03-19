<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class TrackedKeyword extends Model
{
    protected $fillable = [
        'site_id',
        'keyword',
        'location_name',
        'location_code',
        'intent_type',
        'priority_order',
        'target_url',
        'status',
    ];

    public function site(): BelongsTo
    {
        return $this->belongsTo(Site::class);
    }

    public function snapshots(): HasMany
    {
        return $this->hasMany(KeywordSnapshot::class)->orderByDesc('checked_at');
    }

    public function latestSnapshot(): \Illuminate\Database\Eloquent\Relations\HasOne
    {
        return $this->hasOne(KeywordSnapshot::class)->latestOfMany('checked_at');
    }

    public function progressEvents(): HasMany
    {
        return $this->hasMany(ProgressEvent::class, 'related_keyword_id');
    }
}

