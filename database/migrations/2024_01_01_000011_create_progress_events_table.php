<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('progress_events', function (Blueprint $table) {
            $table->id();
            $table->foreignId('site_id')->constrained()->cascadeOnDelete();
            $table->string('event_type');
            $table->string('headline');
            $table->text('detail')->nullable();
            $table->foreignId('related_mission_id')->nullable()->constrained('missions')->nullOnDelete();
            $table->foreignId('related_keyword_id')->nullable()->constrained('tracked_keywords')->nullOnDelete();
            $table->date('event_date');
            $table->json('meta_json')->nullable();
            $table->timestamps();

            $table->index(['site_id', 'event_date']);
            $table->index('event_type');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('progress_events');
    }
};

