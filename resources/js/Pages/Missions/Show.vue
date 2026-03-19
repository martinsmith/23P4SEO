<script setup lang="ts">
import { Link, router } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import { reactive, ref } from 'vue';

interface Task {
    id: number;
    sort_order: number;
    task_text: string;
    task_type: string;
    validation_rule: { check: string } | null;
    status: string;
    completed_at: string | null;
}

interface Resource {
    type: 'code' | 'tip' | 'link';
    label: string;
    content?: string;
    url?: string;
}

interface Mission {
    id: number;
    category: string;
    status: string;
    priority_score: number;
    impact_level: string;
    effort_level: string;
    outcome_statement: string;
    user_summary: string;
    rationale_summary: string | null;
    resources: Resource[];
    created_by: string;
    created_at: string;
    activated_at: string | null;
    completed_at: string | null;
}

const props = defineProps<{
    site: { id: number; display_name: string; normalized_domain: string };
    mission: Mission;
    tasks: Task[];
}>();

const testResults = reactive<Record<number, { loading: boolean; passed?: boolean; message?: string }>>({});

function completeTask(taskId: number) {
    router.post(`/sites/${props.site.id}/missions/${props.mission.id}/tasks/${taskId}/complete`);
}

async function testTask(taskId: number) {
    testResults[taskId] = { loading: true };
    try {
        const response = await fetch(`/sites/${props.site.id}/missions/${props.mission.id}/tasks/${taskId}/test`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]')?.content ?? '',
                'Accept': 'application/json',
            },
        });
        const data = await response.json();
        testResults[taskId] = { loading: false, passed: data.passed, message: data.message };
        if (data.passed) {
            // Reload page to reflect completed task state
            setTimeout(() => router.reload(), 1200);
        }
    } catch {
        testResults[taskId] = { loading: false, passed: false, message: 'Request failed. Please try again.' };
    }
}

function activateMission() {
    router.post(`/sites/${props.site.id}/missions/${props.mission.id}/activate`);
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

// Sitemap generator state
const isSitemapMission = props.mission.outcome_statement.toLowerCase().includes('sitemap');
const sitemapLoading = ref(false);
const sitemapXml = ref<string | null>(null);
const sitemapUrlCount = ref(0);

async function generateSitemap() {
    sitemapLoading.value = true;
    try {
        const response = await fetch(`/sites/${props.site.id}/generate-sitemap`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]')?.content ?? '',
                'Accept': 'application/json',
            },
        });
        const data = await response.json();
        sitemapXml.value = data.xml;
        sitemapUrlCount.value = data.url_count;
    } catch {
        sitemapXml.value = '<!-- Error generating sitemap. Please try again. -->';
    } finally {
        sitemapLoading.value = false;
    }
}

function copySitemap() {
    if (sitemapXml.value) {
        navigator.clipboard.writeText(sitemapXml.value);
    }
}

function downloadSitemap() {
    if (!sitemapXml.value) return;
    const blob = new Blob([sitemapXml.value], { type: 'application/xml' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'sitemap.xml';
    a.click();
    URL.revokeObjectURL(url);
}

const completedCount = props.tasks.filter(t => t.status === 'completed').length;
const totalCount = props.tasks.length;
const progressPct = totalCount > 0 ? (completedCount / totalCount * 100) : 0;
</script>

<template>
    <AppLayout>
        <div class="mission-show">
            <Link :href="`/sites/${site.id}/missions`" class="mission-show__back">← Back to Missions</Link>

            <div class="mission-show__header">
                <div class="mission-show__tags">
                    <span :class="['tag', priorityClass(mission.priority_score)]">
                        {{ priorityLabel(mission.priority_score) }} Priority
                    </span>
                    <span class="tag tag--neutral">{{ mission.category }}</span>
                    <span class="tag tag--neutral">{{ mission.impact_level }} impact</span>
                    <span class="tag tag--neutral">{{ mission.effort_level }} effort</span>
                </div>

                <h1 class="section-heading">{{ mission.outcome_statement }}</h1>
                <p class="mission-show__summary">{{ mission.user_summary }}</p>

                <div v-if="mission.rationale_summary" class="mission-show__rationale">
                    <strong>Why this matters:</strong> {{ mission.rationale_summary }}
                </div>
            </div>

            <div v-if="mission.resources && mission.resources.length" class="mission-show__resources">
                <h2 class="mission-show__section-title">📚 Resources & Examples</h2>

                <div v-for="(resource, idx) in mission.resources" :key="idx" class="mission-resource">
                    <!-- Code snippet -->
                    <div v-if="resource.type === 'code'" class="mission-resource__code">
                        <div class="mission-resource__label">{{ resource.label }}</div>
                        <pre class="mission-resource__pre"><code>{{ resource.content }}</code></pre>
                    </div>

                    <!-- Tip -->
                    <div v-if="resource.type === 'tip'" class="mission-resource__tip">
                        <div class="mission-resource__tip-icon">💡</div>
                        <div>
                            <div class="mission-resource__label">{{ resource.label }}</div>
                            <p class="mission-resource__tip-text">{{ resource.content }}</p>
                        </div>
                    </div>

                    <!-- Link -->
                    <a v-if="resource.type === 'link'" :href="resource.url" target="_blank" rel="noopener" class="mission-resource__link">
                        <span class="mission-resource__link-icon">🔗</span>
                        <span>{{ resource.label }}</span>
                        <span class="mission-resource__link-arrow">↗</span>
                    </a>
                </div>
            </div>

            <div class="mission-show__progress-section">
                <div class="mission-show__progress-header">
                    <h2 class="mission-show__section-title">Tasks</h2>
                    <span class="mission-show__progress-count">{{ completedCount }}/{{ totalCount }} complete</span>
                </div>
                <div class="mission-show__progress-bar">
                    <div class="mission-show__progress-fill" :style="{ width: progressPct + '%' }"></div>
                </div>
            </div>

            <ul class="mission-tasks">
                <li v-for="task in tasks" :key="task.id" :class="['mission-task', { 'mission-task--done': task.status === 'completed' }]">
                    <!-- Completed state -->
                    <span v-if="task.status === 'completed'" class="mission-task__check-done">✓</span>

                    <!-- Manual task: checkbox -->
                    <button
                        v-else-if="task.task_type === 'manual'"
                        class="mission-task__check"
                        @click="completeTask(task.id)"
                        title="Mark as done"
                    >
                        <span class="mission-task__check-circle"></span>
                    </button>

                    <!-- Verify task: no checkbox icon, handled by test button -->
                    <span v-else class="mission-task__verify-icon">🔍</span>

                    <div class="mission-task__content">
                        <span class="mission-task__text">{{ task.task_text }}</span>

                        <!-- Test button for verify tasks that aren't complete -->
                        <template v-if="task.task_type === 'verify' && task.validation_rule && task.status !== 'completed'">
                            <button
                                class="btn btn--test"
                                :disabled="testResults[task.id]?.loading"
                                @click="testTask(task.id)"
                            >
                                <span v-if="testResults[task.id]?.loading" class="btn--test__spinner"></span>
                                <span v-else>Test</span>
                            </button>
                        </template>

                        <!-- Test result message -->
                        <div v-if="testResults[task.id] && !testResults[task.id].loading" :class="['mission-task__result', testResults[task.id].passed ? 'mission-task__result--pass' : 'mission-task__result--fail']">
                            {{ testResults[task.id].passed ? '✅' : '❌' }} {{ testResults[task.id].message }}
                        </div>
                    </div>
                </li>
            </ul>

            <!-- Sitemap Generator -->
            <div v-if="isSitemapMission" class="card sitemap-generator">
                <h3 class="sitemap-generator__title">🗺️ Sitemap Generator</h3>
                <p class="sitemap-generator__desc">
                    We can crawl your site and generate an XML sitemap for you. Upload the resulting file to your server root.
                </p>

                <button
                    v-if="!sitemapXml"
                    class="btn btn--accent"
                    :disabled="sitemapLoading"
                    @click="generateSitemap"
                >
                    <span v-if="sitemapLoading" class="btn--test__spinner"></span>
                    <span v-else>Generate Sitemap <span class="arrow">→</span></span>
                </button>

                <div v-if="sitemapXml" class="sitemap-generator__result">
                    <div class="sitemap-generator__meta">
                        <span class="tag tag--info">{{ sitemapUrlCount }} URLs found</span>
                        <div class="sitemap-generator__actions">
                            <button class="btn btn--primary" @click="copySitemap">📋 Copy XML</button>
                            <button class="btn btn--accent" @click="downloadSitemap">⬇ Download</button>
                        </div>
                    </div>
                    <pre class="sitemap-generator__xml"><code>{{ sitemapXml }}</code></pre>
                </div>
            </div>

            <div v-if="mission.status === 'suggested'" class="mission-show__actions">
                <button class="btn btn--primary" @click="activateMission">
                    Start This Mission <span class="arrow">→</span>
                </button>
            </div>

            <div v-if="mission.status === 'completed'" class="card mission-show__complete-card">
                <div class="mission-show__complete-icon">🎉</div>
                <h3>Mission Complete!</h3>
                <p>All tasks have been finished. Run a new scan to validate the changes.</p>
                <Link :href="`/sites/${site.id}`" class="btn btn--accent">
                    Back to Site <span class="arrow">→</span>
                </Link>
            </div>
        </div>
    </AppLayout>
</template>



<style scoped>
.mission-show__back {
    display: inline-block;
    font-size: 14px;
    color: var(--color-text-muted);
    margin-bottom: var(--space-lg);
    transition: color 0.3s ease;
}
.mission-show__back:hover {
    color: var(--color-accent);
}

.mission-show__header {
    margin-bottom: var(--space-2xl);
}

.mission-show__tags {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-bottom: var(--space-md);
}

.mission-show__summary {
    font-size: 16px;
    color: var(--color-text-muted);
    line-height: 1.8;
    max-width: 700px;
}

.mission-show__rationale {
    margin-top: var(--space-md);
    padding: var(--space-md) var(--space-lg);
    background: oklch(from var(--color-accent) l c h / 0.06);
    border-left: 3px solid var(--color-accent);
    border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
    font-size: 14px;
    color: var(--color-text-muted);
    line-height: 1.7;
    max-width: 700px;
}
.mission-show__rationale strong {
    color: var(--color-cobalt);
}

.mission-show__progress-section {
    margin-bottom: var(--space-xl);
}

.mission-show__progress-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: var(--space-sm);
}

.mission-show__section-title {
    font-size: 1.125rem;
    font-weight: 700;
    color: var(--color-cobalt);
}

.mission-show__progress-count {
    font-size: 13px;
    font-weight: 600;
    color: var(--color-text-muted);
}

.mission-show__progress-bar {
    height: 8px;
    background: var(--color-border);
    border-radius: 4px;
    overflow: hidden;
}

.mission-show__progress-fill {
    height: 100%;
    background: linear-gradient(90deg, var(--color-accent), var(--color-accent-hover));
    border-radius: 4px;
    transition: width 0.5s var(--ease-out-expo);
}

.mission-tasks {
    list-style: none;
    margin: 0 0 var(--space-2xl);
}

.mission-task {
    display: flex;
    align-items: flex-start;
    gap: 14px;
    padding: 16px 0;
    border-bottom: 1px solid var(--color-border);
}
.mission-task:last-child {
    border-bottom: none;
}

.mission-task__check {
    flex-shrink: 0;
    padding: 0;
    margin-top: 2px;
    cursor: pointer;
}

.mission-task__check-circle {
    display: block;
    width: 22px;
    height: 22px;
    border: 2px solid var(--color-border-hover);
    border-radius: 50%;
    transition: all 0.2s ease;
}
.mission-task__check:hover .mission-task__check-circle {
    border-color: var(--color-accent);
    background: oklch(from var(--color-accent) l c h / 0.1);
}

.mission-task__check-done {
    flex-shrink: 0;
    width: 22px;
    height: 22px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    background: var(--color-accent);
    color: var(--color-cobalt);
    font-size: 12px;
    font-weight: 700;
    margin-top: 2px;
}

.mission-task__content {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
}

.mission-task__text {
    font-size: 15px;
    color: var(--color-text);
    line-height: 1.5;
}

.mission-task__verify-icon {
    flex-shrink: 0;
    width: 22px;
    height: 22px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    margin-top: 2px;
}

.mission-task--done .mission-task__text {
    color: var(--color-text-faint);
    text-decoration: line-through;
}

.btn--test {
    margin-left: 12px;
    padding: 4px 14px;
    font-size: 12px;
    font-weight: 700;
    border-radius: 6px;
    background: var(--color-cobalt);
    color: #fff;
    cursor: pointer;
    transition: all 0.2s ease;
    flex-shrink: 0;
}
.btn--test:hover:not(:disabled) {
    background: var(--color-primary);
    transform: translateY(-1px);
}
.btn--test:disabled {
    opacity: 0.6;
    cursor: wait;
}

.btn--test__spinner {
    display: inline-block;
    width: 14px;
    height: 14px;
    border: 2px solid rgba(255,255,255,0.3);
    border-top-color: #fff;
    border-radius: 50%;
    animation: spin 0.6s linear infinite;
}

@keyframes spin {
    to { transform: rotate(360deg); }
}

.mission-task__result {
    width: 100%;
    margin-top: 6px;
    font-size: 13px;
    line-height: 1.5;
    padding: 6px 12px;
    border-radius: var(--radius-sm);
}
.mission-task__result--pass {
    background: oklch(from var(--color-accent) l c h / 0.08);
    color: oklch(35% 0.12 165);
}
.mission-task__result--fail {
    background: oklch(90% 0.06 25);
    color: oklch(40% 0.15 25);
}

/* Sitemap Generator */
.sitemap-generator {
    padding: var(--space-xl);
    margin-bottom: var(--space-2xl);
}
.sitemap-generator__title {
    font-size: 1.125rem;
    font-weight: 700;
    color: var(--color-cobalt);
    margin-bottom: 6px;
}
.sitemap-generator__desc {
    font-size: 14px;
    color: var(--color-text-muted);
    line-height: 1.7;
    margin-bottom: var(--space-lg);
    max-width: 600px;
}
.sitemap-generator__result {
    margin-top: var(--space-lg);
}
.sitemap-generator__meta {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 12px;
    margin-bottom: var(--space-md);
}
.sitemap-generator__actions {
    display: flex;
    gap: 8px;
}
.sitemap-generator__xml {
    background: var(--color-dark-deep, #1a1a2e);
    border-radius: var(--radius-sm);
    padding: var(--space-md) var(--space-lg);
    overflow-x: auto;
    max-height: 400px;
    font-family: 'SF Mono', 'Fira Code', 'Cascadia Code', monospace;
    font-size: 12px;
    line-height: 1.6;
    color: #e0e0e0;
    white-space: pre;
    margin: 0;
}

.mission-show__actions {
    margin-bottom: var(--space-2xl);
}

.mission-show__complete-card {
    text-align: center;
    padding: var(--space-2xl);
}
.mission-show__complete-icon {
    font-size: 2.5rem;
    margin-bottom: var(--space-md);
}
.mission-show__complete-card h3 {
    font-size: 1.25rem;
    font-weight: 700;
    color: var(--color-cobalt);
    margin-bottom: 6px;
}
.mission-show__complete-card p {
    color: var(--color-text-muted);
    margin-bottom: var(--space-lg);
}

/* Resources section */
.mission-show__resources {
    margin-bottom: var(--space-2xl);
}
.mission-show__resources > .mission-show__section-title {
    margin-bottom: var(--space-lg);
}

.mission-resource {
    margin-bottom: var(--space-md);
}

.mission-resource__label {
    font-size: 13px;
    font-weight: 700;
    color: var(--color-cobalt);
    margin-bottom: 6px;
}

.mission-resource__code {
    background: var(--color-dark-deep, #1a1a2e);
    border-radius: var(--radius-sm);
    padding: var(--space-md) var(--space-lg);
}
.mission-resource__code .mission-resource__label {
    color: var(--color-accent);
    margin-bottom: var(--space-sm);
}
.mission-resource__pre {
    margin: 0;
    overflow-x: auto;
    font-family: 'SF Mono', 'Fira Code', 'Cascadia Code', monospace;
    font-size: 13px;
    line-height: 1.6;
    color: #e0e0e0;
    white-space: pre-wrap;
    word-break: break-word;
}

.mission-resource__tip {
    display: flex;
    gap: 12px;
    padding: var(--space-md) var(--space-lg);
    background: oklch(from var(--color-accent) l c h / 0.06);
    border-left: 3px solid var(--color-accent);
    border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
}
.mission-resource__tip-icon {
    font-size: 1.25rem;
    flex-shrink: 0;
    margin-top: 1px;
}
.mission-resource__tip-text {
    font-size: 14px;
    line-height: 1.7;
    color: var(--color-text-muted);
    margin: 0;
}

.mission-resource__link {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 12px var(--space-lg);
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-sm);
    font-size: 14px;
    color: var(--color-cobalt);
    text-decoration: none;
    transition: all 0.25s ease;
}
.mission-resource__link:hover {
    border-color: var(--color-accent);
    background: oklch(from var(--color-accent) l c h / 0.04);
    color: var(--color-primary);
}
.mission-resource__link-icon {
    font-size: 1rem;
    flex-shrink: 0;
}
.mission-resource__link-arrow {
    margin-left: auto;
    opacity: 0.4;
    transition: opacity 0.2s ease, transform 0.2s ease;
}
.mission-resource__link:hover .mission-resource__link-arrow {
    opacity: 1;
    transform: translate(2px, -2px);
}
</style>
