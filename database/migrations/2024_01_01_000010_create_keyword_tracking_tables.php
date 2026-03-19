<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tracked_keywords', function (Blueprint $table) {
            $table->id();
            $table->foreignId('site_id')->constrained()->cascadeOnDelete();
            $table->string('keyword');
            $table->string('location_name')->nullable();
            $table->string('location_code')->nullable();
            $table->string('intent_type')->default('service');
            $table->unsignedSmallInteger('priority_order')->default(0);
            $table->string('target_url', 2048)->nullable();
            $table->string('status')->default('active');
            $table->timestamps();

            $table->index(['site_id', 'status']);
        });

        Schema::create('keyword_snapshots', function (Blueprint $table) {
            $table->id();
            $table->foreignId('tracked_keyword_id')->constrained()->cascadeOnDelete();
            $table->timestamp('checked_at');
            $table->unsignedSmallInteger('ranking_position')->nullable();
            $table->boolean('found_in_results')->default(false);
            $table->string('result_url', 2048)->nullable();
            $table->json('top_competitor_domains_json')->nullable();
            $table->string('provider')->nullable();
            $table->json('raw_result_meta_json')->nullable();
            $table->timestamps();

            $table->index(['tracked_keyword_id', 'checked_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('keyword_snapshots');
        Schema::dropIfExists('tracked_keywords');
    }
};

