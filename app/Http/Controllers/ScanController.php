<?php

namespace App\Http\Controllers;

use App\Models\Site;
use App\Services\MissionGenerator;
use App\Services\Scanner\SiteScanner;

class ScanController extends Controller
{
    public function store(Site $site, SiteScanner $scanner, MissionGenerator $missionGenerator)
    {
        $scan = $scanner->scan($site);
        $missionGenerator->reconcileMissions($site, $scan);

        return redirect()->route('missions.index', $site);
    }
}

