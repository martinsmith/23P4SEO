<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Site extends Model
{
    protected $fillable = [
        'account_id',
        'display_name',
        'primary_url',
        'normalized_domain',
        'primary_location',
        'onboarding_status',
        'lifecycle_status',
    ];

    protected function casts(): array
    {
        return [
            'last_scanned_at' => 'datetime',
        ];
    }

    public function account(): BelongsTo
    {
        return $this->belongsTo(Account::class);
    }

    public function businessProfile(): HasOne
    {
        return $this->hasOne(BusinessProfile::class);
    }

    public function businessServices(): HasMany
    {
        return $this->hasMany(BusinessService::class);
    }

    public function competitors(): HasMany
    {
        return $this->hasMany(Competitor::class);
    }

    public function integrations(): HasMany
    {
        return $this->hasMany(SiteIntegration::class);
    }

    public function scans(): HasMany
    {
        return $this->hasMany(SiteScan::class);
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
        return $this->hasMany(Mission::class);
    }

    public function trackedKeywords(): HasMany
    {
        return $this->hasMany(TrackedKeyword::class);
    }

    public function progressEvents(): HasMany
    {
        return $this->hasMany(ProgressEvent::class);
    }

    public function validationRuns(): HasMany
    {
        return $this->hasMany(ValidationRun::class);
    }
}

