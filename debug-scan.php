<?php
require __DIR__ . '/vendor/autoload.php';
$app = require_once __DIR__ . '/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

$site = App\Models\Site::find(6);
echo "Site: {$site->primary_url}\n";
echo "Last scanned: {$site->last_scanned_at}\n\n";

// Latest scan
$scan = $site->scans()->latest()->first();
if (!$scan) {
    echo "No scans found!\n";
    exit;
}

echo "Scan #{$scan->id} — status: {$scan->status}, created: {$scan->created_at}\n";
echo "Summary: " . json_encode($scan->summary_json, JSON_PRETTY_PRINT) . "\n\n";

// Findings from this scan
$findings = $scan->findings()->get();
echo "Findings ({$findings->count()}):\n";
foreach ($findings as $f) {
    echo "  [{$f->severity}] {$f->code} — {$f->title}\n";
}

echo "\n--- Missions for this site ---\n";
$missions = App\Models\Mission::where('site_id', $site->id)->get();
echo "Total missions: {$missions->count()}\n";
foreach ($missions as $m) {
    echo "  [{$m->status}] {$m->source_finding_code} — {$m->outcome_statement}\n";
}

