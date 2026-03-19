<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('site_scans', function (Blueprint $table) {
            $table->id();
            $table->foreignId('site_id')->constrained()->cascadeOnDelete();
            $table->string('scan_type');
            $table->string('status')->default('queued');
            $table->unsignedInteger('scan_version')->default(1);
            $table->timestamp('started_at')->nullable();
            $table->timestamp('completed_at')->nullable();
            $table->json('summary_json')->nullable();
            $table->timestamps();

            $table->index(['site_id', 'status']);
        });

        Schema::create('site_pages', function (Blueprint $table) {
            $table->id();
            $table->foreignId('site_id')->constrained()->cascadeOnDelete();
            $table->foreignId('site_scan_id')->constrained()->cascadeOnDelete();
            $table->string('url', 2048);
            $table->string('title', 512)->nullable();
            $table->unsignedSmallInteger('status_code')->nullable();
            $table->string('canonical_url', 2048)->nullable();
            $table->boolean('is_indexable')->default(true);
            $table->boolean('is_noindex')->default(false);
            $table->timestamp('last_seen_at')->nullable();
            $table->timestamps();

            $table->index('site_id');
            $table->index('site_scan_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('site_pages');
        Schema::dropIfExists('site_scans');
    }
};

