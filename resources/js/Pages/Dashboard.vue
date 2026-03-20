<script setup lang="ts">
import AppLayout from '@/Layouts/AppLayout.vue';
import { Link } from '@inertiajs/vue3';

interface SiteScan {
    id: number;
    status: string;
    total_findings: number;
    blockers: number;
    severity_counts: Record<string, number>;
}

interface MissionStats {
    total: number;
    completed: number;
    active: number;
    suggested: number;
}

interface SiteCard {
    id: number;
    display_name: string;
    primary_url: string;
    normalized_domain: string;
    onboarding_status: string;
    last_scanned_at: string | null;
    last_scanned_at_raw: string | null;
    health_score: number;
    scan: SiteScan | null;
    missions: MissionStats;
}

const props = defineProps<{
    sites: SiteCard[];
}>();

function healthColor(score: number): string {
    if (score >= 80) return 'var(--color-success)';
    if (score >= 50) return 'var(--color-warning)';
    return 'var(--color-danger)';
}

function healthLabel(score: number): string {
    if (score >= 80) return 'Good';
    if (score >= 50) return 'Needs Work';
    return 'Critical';
}

function missionProgress(m: MissionStats): number {
    if (m.total === 0) return 0;
    return Math.round((m.completed / m.total) * 100);
}
</script>

<template>
    <AppLayout>
        <div class="dashboard">
            <span class="section-tag">Dashboard</span>
            <h1 class="page-title">Your Sites</h1>
            <p class="page-subtitle" style="margin-bottom: var(--space-xl);">
                Monitor site health, track mission progress, and take action.
            </p>

            <!-- Empty state -->
            <div v-if="sites.length === 0" class="card dash-empty">
                <div class="dash-empty__icon">🚀</div>
                <h2 class="dash-empty__title">Get Started</h2>
                <p class="dash-empty__text">
                    Add your website to begin your first scan and receive
                    your first set of missions.
                </p>
                <Link href="/sites/create" class="btn btn--primary">
                    Add Your Website <span class="arrow">→</span>
                </Link>
            </div>

            <!-- Site cards -->
            <div v-else class="dash-grid">
                <div v-for="site in sites" :key="site.id" class="card card--interactive dash-site">
                    <div class="dash-site__header">
                        <div>
                            <h2 class="dash-site__name">{{ site.display_name }}</h2>
                            <a :href="site.primary_url" target="_blank" rel="noopener" class="dash-site__url">
                                {{ site.normalized_domain }} ↗
                            </a>
                        </div>
                        <div v-if="site.scan" class="dash-health" :style="{ '--health-color': healthColor(site.health_score) }">
                            <span class="dash-health__score">{{ site.health_score }}</span>
                            <span class="dash-health__label">{{ healthLabel(site.health_score) }}</span>
                        </div>
                    </div>

                    <!-- Not yet scanned -->
                    <div v-if="!site.scan" class="dash-site__pending">
                        <span class="tag tag--warning">Pending Scan</span>
                        <p class="dash-site__hint">Run your first scan to discover issues and generate missions.</p>
                        <Link :href="`/sites/${site.id}/missions`" class="btn btn--primary btn--sm">
                            Go to Site <span class="arrow">→</span>
                        </Link>
                    </div>

                    <!-- Scanned — show stats -->
                    <div v-else class="dash-site__stats">
                        <div class="dash-stat-row">
                            <div class="dash-stat">
                                <span class="dash-stat__value">{{ site.scan.total_findings }}</span>
                                <span class="dash-stat__label">Findings</span>
                            </div>
                            <div class="dash-stat dash-stat--danger">
                                <span class="dash-stat__value">{{ site.scan.blockers }}</span>
                                <span class="dash-stat__label">Blockers</span>
                            </div>
                            <div class="dash-stat">
                                <span class="dash-stat__value">{{ site.missions.active }}</span>
                                <span class="dash-stat__label">Active</span>
                            </div>
                            <div class="dash-stat dash-stat--success">
                                <span class="dash-stat__value">{{ site.missions.completed }}</span>
                                <span class="dash-stat__label">Done</span>
                            </div>
                        </div>

                        <!-- Mission progress bar -->
                        <div v-if="site.missions.total > 0" class="dash-progress">
                            <div class="dash-progress__header">
                                <span class="dash-progress__text">Mission Progress</span>
                                <span class="dash-progress__pct">{{ missionProgress(site.missions) }}%</span>
                            </div>
                            <div class="dash-progress__bar">
                                <div
                                    class="dash-progress__fill"
                                    :style="{ width: missionProgress(site.missions) + '%' }"
                                ></div>
                            </div>
                        </div>

                        <div class="dash-site__meta">
                            <span v-if="site.last_scanned_at" class="dash-site__scanned">
                                Scanned {{ site.last_scanned_at }}
                            </span>
                        </div>

                        <div class="dash-site__actions">
                            <Link :href="`/sites/${site.id}/missions`" class="btn btn--primary btn--sm">
                                Missions <span class="arrow">→</span>
                            </Link>
                        </div>
                    </div>
                </div>

                <!-- Add another site card -->
                <Link href="/sites/create" class="card card--interactive dash-add">
                    <span class="dash-add__icon">+</span>
                    <span class="dash-add__text">Add Another Site</span>
                </Link>
            </div>
        </div>
    </AppLayout>
</template>


<style scoped>
/* Empty state */
.dash-empty { max-width: 540px; }
.dash-empty__icon { font-size: 2rem; margin-bottom: var(--space-md); }
.dash-empty__title { font-size: 1.25rem; font-weight: 700; color: var(--color-cobalt); margin: 0 0 0.5rem; }
.dash-empty__text { font-size: 15px; color: var(--color-text-muted); margin: 0 0 var(--space-lg); line-height: 1.7; }

/* Grid */
.dash-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
    gap: var(--space-lg);
}

/* Site card */
.dash-site { display: flex; flex-direction: column; gap: var(--space-lg); }
.dash-site__header { display: flex; justify-content: space-between; align-items: flex-start; gap: var(--space-md); }
.dash-site__name { font-size: 1.15rem; font-weight: 700; color: var(--color-cobalt); margin: 0; }
.dash-site__url { font-size: 13px; color: var(--color-text-muted); }
.dash-site__url:hover { color: var(--color-accent); }

/* Health badge */
.dash-health {
    display: flex; flex-direction: column; align-items: center;
    min-width: 56px; padding: 8px 12px;
    border-radius: var(--radius-sm);
    background: oklch(from var(--health-color) l c h / 0.1);
    border: 1px solid oklch(from var(--health-color) l c h / 0.2);
}
.dash-health__score { font-size: 1.5rem; font-weight: 800; line-height: 1; color: var(--health-color); }
.dash-health__label { font-size: 11px; font-weight: 600; color: var(--health-color); text-transform: uppercase; letter-spacing: 0.03em; }

/* Pending state */
.dash-site__pending { display: flex; flex-direction: column; gap: var(--space-sm); align-items: flex-start; }
.dash-site__hint { font-size: 14px; color: var(--color-text-muted); line-height: 1.6; }

/* Stats row */
.dash-stat-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: var(--space-sm); }
.dash-stat { display: flex; flex-direction: column; align-items: center; padding: var(--space-sm); border-radius: var(--radius-sm); background: var(--color-bg); }
.dash-stat__value { font-size: 1.25rem; font-weight: 700; color: var(--color-text); line-height: 1; }
.dash-stat--danger .dash-stat__value { color: var(--color-danger); }
.dash-stat--success .dash-stat__value { color: var(--color-success); }
.dash-stat__label { font-size: 11px; color: var(--color-text-muted); margin-top: 2px; text-transform: uppercase; letter-spacing: 0.03em; }

/* Progress bar */
.dash-progress { display: flex; flex-direction: column; gap: 6px; }
.dash-progress__header { display: flex; justify-content: space-between; }
.dash-progress__text { font-size: 13px; font-weight: 600; color: var(--color-text-muted); }
.dash-progress__pct { font-size: 13px; font-weight: 700; color: var(--color-cobalt); }
.dash-progress__bar { height: 8px; border-radius: var(--radius-full); background: var(--color-border); overflow: hidden; }
.dash-progress__fill { height: 100%; border-radius: var(--radius-full); background: linear-gradient(90deg, var(--color-accent), var(--color-success)); transition: width 0.6s var(--ease-out-expo); }

/* Meta */
.dash-site__meta { font-size: 12px; color: var(--color-text-faint); }

/* Actions */
.dash-site__actions { display: flex; gap: var(--space-sm); }

/* Add card */
.dash-add {
    display: flex; flex-direction: column; align-items: center; justify-content: center;
    gap: var(--space-sm); min-height: 200px; border-style: dashed;
    color: var(--color-text-muted); text-decoration: none;
}
.dash-add:hover { color: var(--color-accent); border-color: var(--color-accent); }
.dash-add__icon { font-size: 2rem; font-weight: 300; line-height: 1; }
.dash-add__text { font-size: 14px; font-weight: 600; }

@media (max-width: 480px) {
    .dash-grid { grid-template-columns: 1fr; }
    .dash-stat-row { grid-template-columns: repeat(2, 1fr); }
}
</style>
