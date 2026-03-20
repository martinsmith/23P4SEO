<?php

namespace App\Http\Controllers;

use App\Models\Mission;
use App\Models\Site;
use App\Services\SitemapGenerator;
use App\Services\TaskVerifier;
use Inertia\Inertia;

class MissionController extends Controller
{
    public function index(Site $site)
    {
        $latestScan = $site->scans()->latest()->first();

        $missions = $site->missions()
            ->with('tasks')
            ->orderByDesc('priority_score')
            ->get()
            ->map(function (Mission $mission) {
                $totalTasks = $mission->tasks->count();
                $completedTasks = $mission->tasks->where('status', 'completed')->count();

                return [
                    'id' => $mission->id,
                    'category' => $mission->category,
                    'status' => $mission->status,
                    'priority_score' => $mission->priority_score,
                    'impact_level' => $mission->impact_level,
                    'effort_level' => $mission->effort_level,
                    'outcome_statement' => $mission->outcome_statement,
                    'user_summary' => $mission->user_summary,
                    'source_finding_title' => $mission->source_finding_title,
                    'total_tasks' => $totalTasks,
                    'completed_tasks' => $completedTasks,
                    'created_at' => $mission->created_at->toDateTimeString(),
                ];
            });

        $businessProfile = $site->businessProfile;
        $businessServices = $site->businessServices()->orderBy('priority_order')->get();
        $competitors = $site->competitors()->where('active', true)->get();

        $trackedKeywords = $site->trackedKeywords()
            ->where('status', 'active')
            ->with('latestSnapshot')
            ->orderBy('priority_order')
            ->get()
            ->map(function ($kw) {
                $snapshot = $kw->latestSnapshot;
                $previous = $snapshot
                    ? $kw->snapshots()->where('id', '!=', $snapshot->id)->orderByDesc('checked_at')->first()
                    : null;

                return [
                    'id' => $kw->id,
                    'keyword' => $kw->keyword,
                    'intent_type' => $kw->intent_type,
                    'location_name' => $kw->location_name,
                    'target_url' => $kw->target_url,
                    'latest_snapshot' => $snapshot ? [
                        'checked_at' => $snapshot->checked_at->toDateTimeString(),
                        'position' => $snapshot->ranking_position,
                        'found' => $snapshot->found_in_results,
                        'result_url' => $snapshot->result_url,
                        'top_competitors' => $snapshot->top_competitor_domains_json ?? [],
                        'previous_position' => $previous?->ranking_position,
                    ] : null,
                ];
            });

        $serperConfigured = config('services.serper.api_key') !== null
            && config('services.serper.api_key') !== '';

        return Inertia::render('Missions/Index', [
            'site' => $site,
            'latestScan' => $latestScan,
            'missions' => $missions,
            'businessProfile' => $businessProfile,
            'businessServices' => $businessServices,
            'competitors' => $competitors,
            'trackedKeywords' => $trackedKeywords,
            'serperConfigured' => $serperConfigured,
        ]);
    }

    public function show(Site $site, Mission $mission)
    {
        $mission->load('tasks', 'sourceScan');

        return Inertia::render('Missions/Show', [
            'site' => $site,
            'mission' => [
                'id' => $mission->id,
                'category' => $mission->category,
                'status' => $mission->status,
                'priority_score' => $mission->priority_score,
                'impact_level' => $mission->impact_level,
                'effort_level' => $mission->effort_level,
                'outcome_statement' => $mission->outcome_statement,
                'user_summary' => $mission->user_summary,
                'rationale_summary' => $mission->rationale_summary,
                'created_by' => $mission->created_by,
                'created_at' => $mission->created_at->toDateTimeString(),
                'activated_at' => $mission->activated_at?->toDateTimeString(),
                'completed_at' => $mission->completed_at?->toDateTimeString(),
                'resources' => $mission->resources_json ?? [],
            ],
            'tasks' => $mission->tasks->map(function ($task) {
                return [
                    'id' => $task->id,
                    'sort_order' => $task->sort_order,
                    'task_text' => $task->task_text,
                    'task_type' => $task->task_type,
                    'validation_rule' => $task->validation_rule_json,
                    'status' => $task->status,
                    'completed_at' => $task->completed_at?->toDateTimeString(),
                ];
            }),
        ]);
    }

    public function activate(Site $site, Mission $mission)
    {
        $mission->update([
            'status' => 'active',
            'activated_at' => now(),
        ]);

        return redirect()->back();
    }

    public function completeTask(Site $site, Mission $mission, int $taskId)
    {
        $task = $mission->tasks()->findOrFail($taskId);

        $task->update([
            'status' => 'completed',
            'completed_at' => now(),
        ]);

        // Check if all tasks are done
        $allComplete = $mission->tasks()->where('status', '!=', 'completed')->doesntExist();

        if ($allComplete) {
            $mission->update([
                'status' => 'completed',
                'completed_at' => now(),
            ]);
        } elseif ($mission->status === 'suggested') {
            $mission->update([
                'status' => 'active',
                'activated_at' => now(),
            ]);
        }

        return redirect()->back();
    }

    public function testTask(Site $site, Mission $mission, int $taskId)
    {
        $task = $mission->tasks()->findOrFail($taskId);

        $validationRule = $task->validation_rule_json;
        if (!$validationRule || !isset($validationRule['check'])) {
            return response()->json([
                'passed' => false,
                'message' => 'This task does not have an automated check.',
            ]);
        }

        $verifier = new TaskVerifier();
        $result = $verifier->verify($site, $validationRule['check']);

        // Auto-complete the task if it passes
        if ($result['passed'] && $task->status !== 'completed') {
            $task->update([
                'status' => 'completed',
                'completed_at' => now(),
            ]);

            // Check if all tasks are now done
            $allComplete = $mission->tasks()->where('status', '!=', 'completed')->doesntExist();
            if ($allComplete) {
                $mission->update([
                    'status' => 'completed',
                    'completed_at' => now(),
                ]);
            } elseif ($mission->status === 'suggested') {
                $mission->update([
                    'status' => 'active',
                    'activated_at' => now(),
                ]);
            }
        }

        return response()->json($result);
    }

    public function generateSitemap(Site $site)
    {
        $generator = new SitemapGenerator(maxPages: 200, maxDepth: 3);
        $result = $generator->generate($site);

        return response()->json([
            'xml' => $result['xml'],
            'url_count' => $result['url_count'],
        ]);
    }
}

