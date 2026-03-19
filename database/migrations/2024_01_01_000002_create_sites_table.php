<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('sites', function (Blueprint $table) {
            $table->id();
            $table->foreignId('account_id')->constrained()->cascadeOnDelete();
            $table->string('display_name');
            $table->string('primary_url');
            $table->string('normalized_domain');
            $table->string('primary_location')->nullable();
            $table->string('onboarding_status')->default('pending_scan');
            $table->string('lifecycle_status')->default('setup');
            $table->timestamp('last_scanned_at')->nullable();
            $table->timestamps();

            $table->index('account_id');
            $table->index('normalized_domain');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('sites');
    }
};

