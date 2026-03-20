<?php

namespace App\Http\Controllers;

use App\Models\Site;
use Illuminate\Http\Request;

class BusinessProfileController extends Controller
{
    public function update(Request $request, Site $site)
    {
        $validated = $request->validate([
            'business_name' => ['nullable', 'string', 'max:255'],
            'business_type' => ['nullable', 'string', 'max:255'],
            'service_model' => ['nullable', 'string', 'max:255'],
            'description' => ['nullable', 'string', 'max:2000'],
            'primary_location' => ['nullable', 'string', 'max:255'],
            'service_area_summary' => ['nullable', 'string', 'max:1000'],
            'target_customer_summary' => ['nullable', 'string', 'max:1000'],
        ]);

        $site->businessProfile()->updateOrCreate(
            ['site_id' => $site->id],
            $validated
        );

        return redirect()->back()->with('success', 'Business profile saved.');
    }

    public function updateServices(Request $request, Site $site)
    {
        $validated = $request->validate([
            'services' => ['present', 'array', 'max:20'],
            'services.*.service_name' => ['required', 'string', 'max:255'],
        ]);

        // Replace all services
        $site->businessServices()->delete();

        foreach ($validated['services'] as $i => $service) {
            if (trim($service['service_name']) === '') {
                continue;
            }
            $site->businessServices()->create([
                'service_name' => trim($service['service_name']),
                'priority_order' => $i,
            ]);
        }

        return redirect()->back()->with('success', 'Services saved.');
    }

    public function updateCompetitors(Request $request, Site $site)
    {
        $validated = $request->validate([
            'competitors' => ['present', 'array', 'max:10'],
            'competitors.*.domain' => ['required', 'string', 'max:255'],
            'competitors.*.label' => ['nullable', 'string', 'max:255'],
        ]);

        // Replace all competitors
        $site->competitors()->delete();

        foreach ($validated['competitors'] as $competitor) {
            $domain = trim($competitor['domain']);
            if ($domain === '') {
                continue;
            }
            // Normalize: strip protocol and trailing slash
            $domain = preg_replace('#^https?://#', '', $domain);
            $domain = rtrim($domain, '/');

            $site->competitors()->create([
                'domain' => $domain,
                'label' => trim($competitor['label'] ?? '') ?: null,
            ]);
        }

        return redirect()->back()->with('success', 'Competitors saved.');
    }
}

