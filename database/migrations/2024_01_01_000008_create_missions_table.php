<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('missions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('site_id')->constrained()->cascadeOnDelete();
            $table->foreignId('source_scan_id')->nullable()->constrained('site_scans')->nullOnDelete();
            $table->string('source_type');
            $table->string('category');
            $table->string('status')->default('suggested');
            $table->unsignedSmallInteger('priority_score')->default(50);
            $table->string('impact_level')->default('medium');
            $table->string('effort_level')->default('medium');
            $table->string('outcome_statement');
            $table->text('user_summary');
            $table->text('rationale_summary')->nullable();
            $table->string('created_by')->default('system');
            $table->timestamp('activated_at')->nullable();
            $table->timestamp('completed_at')->nullable();
            $table->timestamps();

            $table->index(['site_id', 'status']);
            $table->index(['site_id', 'priority_score']);
        });

        Schema::create('mission_tasks', function (Blueprint $table) {
            $table->id();
            $table->foreignId('mission_id')->constrained()->cascadeOnDelete();
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->text('task_text');
            $table->string('task_type');
            $table->string('target_url', 2048)->nullable();
            $table->json('validation_rule_json')->nullable();
            $table->string('status')->default('pending');
            $table->timestamp('completed_at')->nullable();
            $table->timestamps();

            $table->index('mission_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('mission_tasks');
        Schema::dropIfExists('missions');
    }
};

