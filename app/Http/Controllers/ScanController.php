<?php

namespace App\Http\Controllers;

use App\Models\Site;
use App\Services\MissionGenerator;
use App\Services\Scanner\SiteScanner;

class ScanController extends Controller
{
    public function store(Site $site, SiteScanner $scanner, MissionGenerator $missionGenerator)
    {
        // Run synchronously for now (no queue worker needed)
        $scan = $scanner->scan($site);

        // Auto-generate missions from findings
        $missionGenerator->generateFromScan($scan);

        // Auto-complete missions whose issues are now resolved
        $missionGenerator->healFromScan($scan);

        // Create pre-completed missions for checks that passed
        $missionGenerator->generatePassMissions($scan);

        return redirect()->route('missions.index', $site);
    }
}

