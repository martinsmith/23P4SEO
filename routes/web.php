<?php

use App\Http\Controllers\BusinessProfileController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\KeywordController;
use App\Http\Controllers\MissionController;
use App\Http\Controllers\ScanController;
use App\Http\Controllers\SiteController;
use Illuminate\Support\Facades\Route;

Route::get('/', DashboardController::class)->name('dashboard');

Route::redirect('/sites', '/')->name('sites.index');
Route::get('/sites/create', [SiteController::class, 'create'])->name('sites.create');
Route::post('/sites', [SiteController::class, 'store'])->name('sites.store');
Route::delete('/sites/{site}', [SiteController::class, 'destroy'])->name('sites.destroy');

Route::post('/sites/{site}/scan', [ScanController::class, 'store'])->name('scans.store');

Route::get('/sites/{site}/missions', [MissionController::class, 'index'])->name('missions.index');
Route::get('/sites/{site}/missions/{mission}', [MissionController::class, 'show'])->name('missions.show');
Route::post('/sites/{site}/missions/{mission}/activate', [MissionController::class, 'activate'])->name('missions.activate');
Route::post('/sites/{site}/missions/{mission}/tasks/{taskId}/complete', [MissionController::class, 'completeTask'])->name('missions.tasks.complete');
Route::post('/sites/{site}/missions/{mission}/tasks/{taskId}/test', [MissionController::class, 'testTask'])->name('missions.tasks.test');
Route::post('/sites/{site}/generate-sitemap', [MissionController::class, 'generateSitemap'])->name('sites.generate-sitemap');

Route::put('/sites/{site}/business-profile', [BusinessProfileController::class, 'update'])->name('business-profile.update');
Route::put('/sites/{site}/business-services', [BusinessProfileController::class, 'updateServices'])->name('business-services.update');
Route::put('/sites/{site}/business-competitors', [BusinessProfileController::class, 'updateCompetitors'])->name('business-competitors.update');

Route::post('/sites/{site}/keywords', [KeywordController::class, 'store'])->name('keywords.store');
Route::post('/sites/{site}/keywords/bulk', [KeywordController::class, 'bulkStore'])->name('keywords.bulk-store');
Route::delete('/sites/{site}/keywords/{keyword}', [KeywordController::class, 'destroy'])->name('keywords.destroy');
Route::get('/sites/{site}/keywords/suggestions', [KeywordController::class, 'suggestions'])->name('keywords.suggestions');
Route::post('/sites/{site}/keywords/{keyword}/check', [KeywordController::class, 'checkRanking'])->name('keywords.check');
Route::post('/sites/{site}/keywords/check-all', [KeywordController::class, 'checkAllRankings'])->name('keywords.check-all');
Route::get('/sites/{site}/serp-presence', [KeywordController::class, 'searchPresence'])->name('serp-presence.search');
