<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('business_profiles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('site_id')->constrained()->cascadeOnDelete();
            $table->string('business_name')->nullable();
            $table->string('business_type')->nullable();
            $table->string('service_model')->nullable();
            $table->text('description')->nullable();
            $table->string('primary_location')->nullable();
            $table->text('service_area_summary')->nullable();
            $table->text('target_customer_summary')->nullable();
            $table->text('notes')->nullable();
            $table->timestamps();

            $table->unique('site_id');
        });

        Schema::create('business_services', function (Blueprint $table) {
            $table->id();
            $table->foreignId('site_id')->constrained()->cascadeOnDelete();
            $table->string('service_name');
            $table->unsignedSmallInteger('priority_order')->default(0);
            $table->boolean('active')->default(true);
            $table->timestamps();

            $table->index('site_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('business_services');
        Schema::dropIfExists('business_profiles');
    }
};

