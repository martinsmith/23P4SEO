<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('missions', function (Blueprint $table) {
            $table->string('source_finding_code')->nullable()->after('source_finding_title');
            $table->index(['site_id', 'source_finding_code']);
        });
    }

    public function down(): void
    {
        Schema::table('missions', function (Blueprint $table) {
            $table->dropIndex(['site_id', 'source_finding_code']);
            $table->dropColumn('source_finding_code');
        });
    }
};

