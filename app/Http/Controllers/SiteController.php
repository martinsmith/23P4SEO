<?php

namespace App\Http\Controllers;

use App\Models\Account;
use App\Models\Site;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Inertia\Inertia;

class SiteController extends Controller
{
    public function index()
    {
        $account = Account::first();
        $sites = $account->sites()->latest()->get();

        return Inertia::render('Sites/Index', [
            'sites' => $sites,
        ]);
    }

    public function create()
    {
        return Inertia::render('Sites/Create');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'url' => ['required', 'url', 'max:2048'],
        ]);

        $url = rtrim($validated['url'], '/');
        $parsed = parse_url($url);
        $domain = Str::lower($parsed['host'] ?? '');

        // Strip www. for normalized domain
        $normalizedDomain = preg_replace('/^www\./', '', $domain);

        // Use the domain as display name if nothing better
        $displayName = $normalizedDomain;

        $account = Account::first();

        $site = $account->sites()->create([
            'display_name' => $displayName,
            'primary_url' => $url,
            'normalized_domain' => $normalizedDomain,
            'onboarding_status' => 'pending_scan',
            'lifecycle_status' => 'setup',
        ]);

        return redirect()->route('sites.show', $site);
    }

    public function show(Site $site)
    {
        $latestScan = $site->scans()->latest()->first();

        return Inertia::render('Sites/Show', [
            'site' => $site,
            'latestScan' => $latestScan,
        ]);
    }
}

