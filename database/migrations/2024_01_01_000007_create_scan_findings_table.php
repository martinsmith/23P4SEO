<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('scan_findings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('site_id')->constrained()->cascadeOnDelete();
            $table->foreignId('site_scan_id')->constrained()->cascadeOnDelete();
            $table->string('category');
            $table->string('code');
            $table->string('severity');
            $table->string('title');
            $table->text('summary')->nullable();
            $table->json('evidence_json')->nullable();
            $table->boolean('is_blocker')->default(false);
            $table->string('status')->default('open');
            $table->timestamp('first_detected_at')->nullable();
            $table->timestamp('last_detected_at')->nullable();
            $table->timestamp('resolved_at')->nullable();
            $table->timestamps();

            $table->index(['site_id', 'status']);
            $table->index(['site_id', 'category']);
            $table->index('site_scan_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('scan_findings');
    }
};

