<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('validation_runs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('site_id')->constrained()->cascadeOnDelete();
            $table->foreignId('mission_id')->nullable()->constrained()->nullOnDelete();
            $table->string('triggered_by')->default('user');
            $table->string('status')->default('queued');
            $table->text('summary')->nullable();
            $table->timestamp('started_at')->nullable();
            $table->timestamp('completed_at')->nullable();
            $table->timestamps();

            $table->index(['site_id', 'status']);
        });

        Schema::create('validation_checks', function (Blueprint $table) {
            $table->id();
            $table->foreignId('validation_run_id')->constrained()->cascadeOnDelete();
            $table->foreignId('mission_task_id')->nullable()->constrained()->nullOnDelete();
            $table->string('check_type');
            $table->string('result');
            $table->text('message')->nullable();
            $table->json('evidence_json')->nullable();
            $table->timestamps();

            $table->index('validation_run_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('validation_checks');
        Schema::dropIfExists('validation_runs');
    }
};

