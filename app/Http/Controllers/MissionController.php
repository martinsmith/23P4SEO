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
                    'total_tasks' => $totalTasks,
                    'completed_tasks' => $completedTasks,
                    'created_at' => $mission->created_at->toDateTimeString(),
                ];
            });

        return Inertia::render('Missions/Index', [
            'site' => $site,
            'missions' => $missions,
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

