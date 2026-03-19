<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class BusinessProfile extends Model
{
    protected $fillable = [
        'site_id',
        'business_name',
        'business_type',
        'service_model',
        'description',
        'primary_location',
        'service_area_summary',
        'target_customer_summary',
        'notes',
    ];

    public function site(): BelongsTo
    {
        return $this->belongsTo(Site::class);
    }
}

