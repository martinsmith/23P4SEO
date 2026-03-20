<?php

namespace App\Http\Controllers;

use App\Models\Account;
use Inertia\Inertia;

class DashboardController extends Controller
{
    public function __invoke()
    {
        $account = Account::first();

        if (!$account) {
            return Inertia::render('Dashboard', [
                'sites' => [],
            ]);
        }

        $sites = $account->sites()
            ->latest()
            ->get()
            ->map(function ($site) {
                $latestScan = $site->scans()->latest()->first();
                $missions = $site->missions()->get();

                $totalMissions = $missions->count();
                $completedMissions = $missions->where('status', 'completed')->count();
                $activeMissions = $missions->where('status', 'active')->count();
                $suggestedMissions = $missions->where('status', 'suggested')->count();

                // Count blockers from latest scan
                $blockers = 0;
                $totalFindings = 0;
                $severityCounts = [];
                if ($latestScan && $latestScan->summary_json) {
                    $blockers = $latestScan->summary_json['blockers'] ?? 0;
                    $totalFindings = $latestScan->summary_json['total_findings'] ?? 0;
                    $severityCounts = $latestScan->summary_json['severity_counts'] ?? [];
                }

                // Calculate a simple health score (0-100)
                // Start at 100, deduct for issues
                $healthScore = 100;
                $healthScore -= $blockers * 20;
                $healthScore -= ($totalFindings - $blockers) * 5;
                $healthScore = max(0, min(100, $healthScore));

                return [
                    'id' => $site->id,
                    'display_name' => $site->display_name,
                    'primary_url' => $site->primary_url,
                    'normalized_domain' => $site->normalized_domain,
                    'onboarding_status' => $site->onboarding_status,
                    'last_scanned_at' => $site->last_scanned_at?->diffForHumans(),
                    'last_scanned_at_raw' => $site->last_scanned_at?->toISOString(),
                    'health_score' => $healthScore,
                    'scan' => $latestScan ? [
                        'id' => $latestScan->id,
                        'status' => $latestScan->status,
                        'total_findings' => $totalFindings,
                        'blockers' => $blockers,
                        'severity_counts' => $severityCounts,
                    ] : null,
                    'missions' => [
                        'total' => $totalMissions,
                        'completed' => $completedMissions,
                        'active' => $activeMissions,
                        'suggested' => $suggestedMissions,
                    ],
                ];
            });

        return Inertia::render('Dashboard', [
            'sites' => $sites,
        ]);
    }
}

