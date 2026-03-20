<script setup lang="ts">
import { ref } from 'vue';
import { Link, router } from '@inertiajs/vue3';
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
    source_finding_title: string | null;
    total_tasks: number;
    completed_tasks: number;
    created_at: string;
}

interface Scan {
    id: number;
    status: string;
    completed_at: string | null;
}

const props = defineProps<{
    site: { id: number; display_name: string; primary_url: string; normalized_domain: string };
    latestScan: Scan | null;
    missions: Mission[];
}>();

const scanning = ref(false);
const showDeleteModal = ref(false);
const deleting = ref(false);

const activeMissions = props.missions.filter(m => m.status !== 'completed');
const completedMissions = props.missions.filter(m => m.status === 'completed');

function runScan() {
    scanning.value = true;
    router.post(`/sites/${props.site.id}/scan`, {}, {
        onFinish: () => { scanning.value = false; },
    });
}

function confirmDelete() { showDeleteModal.value = true; }
function cancelDelete() { showDeleteModal.value = false; }

function deleteSite() {
    deleting.value = true;
    router.delete(`/sites/${props.site.id}`, {
        onFinish: () => {
            deleting.value = false;
            showDeleteModal.value = false;
        },
    });
}

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
            <Link href="/" class="missions-index__back">← Dashboard</Link>

            <div class="missions-index__header">
                <div>
                    <h1 class="page-title">{{ site.display_name }}</h1>
                    <a :href="site.primary_url" target="_blank" rel="noopener" class="missions-index__url">
                        {{ site.primary_url }} ↗
                    </a>
                </div>
                <div class="missions-index__header-actions">
                    <button
                        class="btn btn--secondary"
                        :disabled="scanning"
                        @click="runScan"
                    >
                        {{ scanning ? 'Scanning…' : latestScan ? 'Re-scan' : 'Run First Scan' }}
                    </button>
                </div>
            </div>

            <!-- No scan yet -->
            <div v-if="!latestScan" class="card missions-index__empty">
                <h2 class="missions-index__empty-title">Ready to scan</h2>
                <p class="missions-index__empty-text">
                    Your site has been added. Run your first scan to discover
                    what's working and generate your missions.
                </p>
                <button class="btn btn--primary" :disabled="scanning" @click="runScan">
                    {{ scanning ? 'Scanning…' : 'Run First Scan' }}
                </button>
            </div>

            <!-- Scanned but no missions at all -->
            <div v-else-if="missions.length === 0" class="card missions-index__empty">
                <p class="missions-index__empty-text">✅ No issues found — your site looks good!</p>
            </div>

            <template v-else>
                <!-- Active missions -->
                <div v-if="activeMissions.length > 0" class="missions-section">
                    <h2 class="missions-section__title">To Do <span class="missions-section__count">{{ activeMissions.length }}</span></h2>
                    <div class="missions-grid">
                        <Link
                            v-for="mission in activeMissions"
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

                            <h3 class="mission-card__finding">{{ mission.source_finding_title || mission.outcome_statement }}</h3>
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

                <!-- No active missions but completed exist -->
                <div v-else class="card missions-index__empty">
                    <p class="missions-index__empty-text">✅ All missions completed — your site is in great shape!</p>
                </div>

                <!-- Divider -->
                <hr v-if="activeMissions.length > 0 && completedMissions.length > 0" class="missions-divider" />

                <!-- Completed missions -->
                <div v-if="completedMissions.length > 0" class="missions-section">
                    <h2 class="missions-section__title">Completed <span class="missions-section__count">{{ completedMissions.length }}</span></h2>
                    <div class="missions-grid">
                        <Link
                            v-for="mission in completedMissions"
                            :key="mission.id"
                            :href="`/sites/${site.id}/missions/${mission.id}`"
                            class="card card--interactive mission-card mission-card--completed"
                        >
                            <div class="mission-card__header">
                                <span class="tag tag--passed">✓ Passed</span>
                                <span class="mission-card__category">{{ mission.category }}</span>
                            </div>
                            <h3 class="mission-card__finding">{{ mission.source_finding_title || mission.outcome_statement }}</h3>
                            <p class="mission-card__summary">{{ mission.user_summary }}</p>
                        </Link>
                    </div>
                </div>
            </template>

            <!-- Danger zone -->
            <div class="card danger-zone">
                <h2 class="danger-zone__title">Danger Zone</h2>
                <div class="danger-zone__row">
                    <div>
                        <strong>Delete this site</strong>
                        <p class="danger-zone__desc">Remove this site and all its scans, findings, and missions.</p>
                    </div>
                    <button class="btn btn--danger" @click="confirmDelete">Delete Site</button>
                </div>
            </div>
        </div>

        <!-- Delete confirmation modal -->
        <Teleport to="body">
            <div v-if="showDeleteModal" class="modal-overlay" @click.self="cancelDelete">
                <div class="modal">
                    <div class="modal__icon">⚠️</div>
                    <h2 class="modal__title">Delete {{ site.display_name }}?</h2>
                    <p class="modal__text">
                        This will permanently delete <strong>{{ site.display_name }}</strong> and all associated data
                        including scans, findings, and missions.
                    </p>
                    <p class="modal__warning">This action cannot be undone.</p>
                    <div class="modal__actions">
                        <button class="btn btn--secondary" @click="cancelDelete" :disabled="deleting">Cancel</button>
                        <button class="btn btn--danger" @click="deleteSite" :disabled="deleting">
                            {{ deleting ? 'Deleting…' : 'Yes, Delete Permanently' }}
                        </button>
                    </div>
                </div>
            </div>
        </Teleport>
    </AppLayout>
</template>

<style scoped>
/* Back link */
.missions-index__back {
    display: inline-block;
    font-size: 14px;
    color: var(--color-text-muted);
    margin-bottom: var(--space-lg);
    transition: color 0.3s ease;
}
.missions-index__back:hover { color: var(--color-accent); }

/* Header */
.missions-index__header {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: var(--space-lg);
    margin-bottom: var(--space-xl);
}
.missions-index__header-actions { display: flex; gap: var(--space-md); flex-shrink: 0; }
.missions-index__url { font-size: 14px; color: var(--color-text-muted); }
.missions-index__url:hover { color: var(--color-accent); }

/* Empty state */
.missions-index__empty { text-align: center; padding: var(--space-2xl); }
.missions-index__empty-title {
    font-size: 1.25rem; font-weight: 700; color: var(--color-cobalt);
    margin: 0 0 0.5rem;
}
.missions-index__empty-text {
    font-size: 15px; color: var(--color-text-muted);
    margin: 0 0 var(--space-lg); line-height: 1.7;
}

/* Sections */
.missions-section { margin-bottom: var(--space-xl); }
.missions-section__title {
    font-size: 1.125rem; font-weight: 700; color: var(--color-text);
    margin: 0 0 var(--space-lg); display: inline-flex; align-items: center; gap: 8px;
}
.missions-section__count {
    font-size: 13px; font-weight: 600; color: var(--color-text-muted);
    background: var(--color-border); border-radius: 10px; padding: 2px 8px;
}

/* Divider between sections */
.missions-divider {
    border: none;
    border-top: 2px solid var(--color-border);
    margin: var(--space-xl) 0;
}

/* Grid */
.missions-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
    gap: var(--space-lg);
}

/* Card */
.mission-card {
    display: flex; flex-direction: column; text-decoration: none; color: inherit;
    background: oklch(98% 0.006 27); border-color: oklch(93% 0.015 27);
}
.mission-card__header { display: flex; gap: 8px; margin-bottom: var(--space-md); }
.mission-card__finding { font-size: 0.9375rem; font-weight: 700; color: var(--color-text); margin: 0 0 6px; line-height: 1.4; }
.mission-card__summary { font-size: 14px; color: var(--color-text-muted); line-height: 1.7; flex: 1; margin-bottom: var(--space-md); }
.mission-card__footer { display: flex; align-items: center; justify-content: space-between; padding-top: var(--space-md); border-top: 1px solid oklch(93% 0.015 27); }
.mission-card__progress { display: flex; align-items: center; gap: 10px; }
.mission-card__progress-bar { width: 80px; height: 6px; background: oklch(92% 0.01 27); border-radius: 3px; overflow: hidden; }
.mission-card__progress-fill { height: 100%; background: var(--color-accent); border-radius: 3px; transition: width 0.3s ease; }
.mission-card__progress-text { font-size: 12px; color: var(--color-text-faint); font-weight: 600; }
.mission-card__category { font-size: 12px; font-weight: 600; color: var(--color-text-faint); text-transform: uppercase; letter-spacing: 0.03em; }

/* Severity-specific tag colours for active cards */
.mission-card .tag--neutral  { background: oklch(90% 0.06 70);  color: oklch(42% 0.10 70); }  /* low — pale orange */
.mission-card .tag--info     { background: oklch(90% 0.06 70);  color: oklch(42% 0.10 70); }  /* medium-low — pale orange */
.mission-card .tag--warning  { background: oklch(88% 0.06 27);  color: oklch(42% 0.16 27); }  /* high — pale red */
.mission-card .tag--danger   { background: oklch(60% 0.20 27);  color: #fff; }                /* critical — solid red */

/* Completed card variant — green background */
.mission-card--completed {
    background: oklch(98% 0.008 145); border-color: oklch(93% 0.02 145);
}
.mission-card--completed .mission-card__finding { font-size: 0.875rem; }
.mission-card--completed .mission-card__summary { font-size: 13px; }

/* Passed tag — darker green */
.tag--passed {
    background: oklch(82% 0.10 145); color: oklch(30% 0.12 145);
    display: inline-flex; align-items: center; gap: 6px;
    padding: 4px 12px; font-size: 12px; font-weight: 600;
    border-radius: var(--radius-sm); letter-spacing: 0.02em; text-transform: uppercase;
}

/* Danger zone */
.danger-zone {
    margin-top: var(--space-2xl);
    border: 1px solid oklch(55% 0.15 25 / 0.3);
    background: oklch(55% 0.15 25 / 0.04);
}
.danger-zone__title { font-size: 1rem; font-weight: 700; color: oklch(55% 0.15 25); margin: 0 0 var(--space-md); }
.danger-zone__row { display: flex; align-items: center; justify-content: space-between; gap: var(--space-lg); }
.danger-zone__desc { font-size: 13px; color: var(--color-text-muted); margin: 4px 0 0; }

/* Modal */
.modal-overlay {
    position: fixed; inset: 0;
    background: oklch(0% 0 0 / 0.5);
    display: flex; align-items: center; justify-content: center;
    z-index: 1000; backdrop-filter: blur(4px);
}
.modal {
    background: var(--color-surface, #fff); border-radius: 12px;
    padding: var(--space-xl) var(--space-2xl); max-width: 440px; width: 90%;
    text-align: center; box-shadow: 0 20px 60px oklch(0% 0 0 / 0.3);
}
.modal__icon { font-size: 2.5rem; margin-bottom: var(--space-md); }
.modal__title { font-size: 1.25rem; font-weight: 700; color: var(--color-text); margin: 0 0 var(--space-md); }
.modal__text { font-size: 14px; color: var(--color-text-muted); line-height: 1.6; margin: 0 0 var(--space-sm); }
.modal__warning { font-size: 13px; font-weight: 600; color: oklch(55% 0.15 25); margin: 0 0 var(--space-xl); }
.modal__actions { display: flex; gap: var(--space-md); justify-content: center; }
.btn--danger { background: oklch(55% 0.15 25); color: #fff; border: none; cursor: pointer; }
.btn--danger:hover { background: oklch(48% 0.17 25); }
.btn--danger:disabled { opacity: 0.6; cursor: not-allowed; }
</style>

