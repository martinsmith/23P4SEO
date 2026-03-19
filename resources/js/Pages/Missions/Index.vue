<script setup lang="ts">
import { Link } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';

interface Mission {
    id: number;
    category: string;
    status: string;
    priority_score: number;
    impact_level: string;
    effort_level: string;
    outcome_statement: string;
    user_summary: string;
    total_tasks: number;
    completed_tasks: number;
    created_at: string;
}

const props = defineProps<{
    site: { id: number; display_name: string; normalized_domain: string };
    missions: Mission[];
}>();

function priorityLabel(score: number): string {
    if (score >= 80) return 'Critical';
    if (score >= 60) return 'High';
    if (score >= 40) return 'Medium';
    return 'Low';
}

function priorityClass(score: number): string {
    if (score >= 80) return 'tag--danger';
    if (score >= 60) return 'tag--warning';
    if (score >= 40) return 'tag--info';
    return 'tag--neutral';
}

function statusLabel(status: string): string {
    return status.charAt(0).toUpperCase() + status.slice(1).replace('_', ' ');
}

function statusClass(status: string): string {
    if (status === 'completed') return 'tag--success';
    if (status === 'active' || status === 'in_progress') return 'tag--info';
    return 'tag--neutral';
}
</script>

<template>
    <AppLayout>
        <div class="missions-index">
            <Link :href="`/sites/${site.id}`" class="missions-index__back">← Back to {{ site.normalized_domain }}</Link>

            <span class="section-tag">Missions</span>
            <h1 class="page-title">Your Missions</h1>
            <p class="page-subtitle">
                Actionable tasks generated from your latest scan. Complete these to improve your site's SEO.
            </p>

            <div v-if="missions.length === 0" class="card missions-index__empty">
                <p>No missions yet. Run a scan to generate your first set of missions.</p>
                <Link :href="`/sites/${site.id}`" class="btn btn--primary">
                    Go to Site <span class="arrow">→</span>
                </Link>
            </div>

            <div v-else class="missions-grid">
                <Link
                    v-for="mission in missions"
                    :key="mission.id"
                    :href="`/sites/${site.id}/missions/${mission.id}`"
                    class="card card--interactive mission-card"
                >
                    <div class="mission-card__header">
                        <span :class="['tag', priorityClass(mission.priority_score)]">
                            {{ priorityLabel(mission.priority_score) }}
                        </span>
                        <span :class="['tag', statusClass(mission.status)]">
                            {{ statusLabel(mission.status) }}
                        </span>
                    </div>

                    <h3 class="mission-card__outcome">{{ mission.outcome_statement }}</h3>
                    <p class="mission-card__summary">{{ mission.user_summary }}</p>

                    <div class="mission-card__footer">
                        <div class="mission-card__progress">
                            <div class="mission-card__progress-bar">
                                <div
                                    class="mission-card__progress-fill"
                                    :style="{ width: mission.total_tasks > 0 ? (mission.completed_tasks / mission.total_tasks * 100) + '%' : '0%' }"
                                ></div>
                            </div>
                            <span class="mission-card__progress-text">
                                {{ mission.completed_tasks }}/{{ mission.total_tasks }} tasks
                            </span>
                        </div>
                        <span class="mission-card__category">{{ mission.category }}</span>
                    </div>
                </Link>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
.missions-index__back {
    display: inline-block;
    font-size: 14px;
    color: var(--color-text-muted);
    margin-bottom: var(--space-lg);
    transition: color 0.3s ease;
}
.missions-index__back:hover {
    color: var(--color-accent);
}

.missions-index__empty {
    text-align: center;
    padding: var(--space-3xl);
}
.missions-index__empty p {
    color: var(--color-text-muted);
    margin-bottom: var(--space-lg);
}

.missions-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
    gap: var(--space-lg);
    margin-top: var(--space-xl);
}

.mission-card {
    display: flex;
    flex-direction: column;
    text-decoration: none;
    color: inherit;
}

.mission-card__header {
    display: flex;
    gap: 8px;
    margin-bottom: var(--space-md);
}

.mission-card__outcome {
    font-size: 1.0625rem;
    font-weight: 700;
    color: var(--color-cobalt);
    margin-bottom: 6px;
    line-height: 1.3;
}

.mission-card__summary {
    font-size: 14px;
    color: var(--color-text-muted);
    line-height: 1.7;
    flex: 1;
    margin-bottom: var(--space-md);
}

.mission-card__footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding-top: var(--space-md);
    border-top: 1px solid var(--color-border);
}

.mission-card__progress {
    display: flex;
    align-items: center;
    gap: 10px;
}

.mission-card__progress-bar {
    width: 80px;
    height: 6px;
    background: var(--color-border);
    border-radius: 3px;
    overflow: hidden;
}

.mission-card__progress-fill {
    height: 100%;
    background: var(--color-accent);
    border-radius: 3px;
    transition: width 0.3s ease;
}

.mission-card__progress-text {
    font-size: 12px;
    color: var(--color-text-faint);
    font-weight: 600;
}

.mission-card__category {
    font-size: 12px;
    font-weight: 600;
    color: var(--color-text-faint);
    text-transform: uppercase;
    letter-spacing: 0.03em;
}
</style>

