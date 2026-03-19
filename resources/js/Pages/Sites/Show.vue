<script setup lang="ts">
import AppLayout from '@/Layouts/AppLayout.vue';
import { ref } from 'vue';
import { router, Link } from '@inertiajs/vue3';

interface Scan {
    id: number;
    status: string;
    completed_at: string | null;
    summary_json: {
        total_findings: number;
        blockers: number;
        severity_counts: Record<string, number>;
    } | null;
}

interface Site {
    id: number;
    display_name: string;
    primary_url: string;
    normalized_domain: string;
    onboarding_status: string;
    lifecycle_status: string;
    last_scanned_at: string | null;
    created_at: string;
}

const props = defineProps<{
    site: Site;
    latestScan: Scan | null;
}>();

const scanning = ref(false);

function runScan() {
    scanning.value = true;
    router.post(`/sites/${props.site.id}/scan`, {}, {
        onFinish: () => {
            scanning.value = false;
        },
    });
}

function formatStatus(status: string): string {
    return status.replace(/_/g, ' ').replace(/\b\w/g, (c: string) => c.toUpperCase());
}
</script>

<template>
    <AppLayout>
        <div class="site-overview">
            <div class="site-overview__header">
                <h1 class="page-title">{{ site.display_name }}</h1>
                <a
                    :href="site.primary_url"
                    target="_blank"
                    rel="noopener"
                    class="site-overview__url"
                >
                    {{ site.primary_url }} ↗
                </a>
            </div>

            <div class="site-overview__status-bar">
                <span class="tag" :class="site.onboarding_status === 'pending_scan' ? 'tag--warning' : site.onboarding_status === 'scanned' ? 'tag--success' : 'tag--neutral'">
                    {{ formatStatus(site.onboarding_status) }}
                </span>
            </div>

            <!-- No scan yet -->
            <div v-if="!latestScan" class="card">
                <h2 class="site-overview__card-title">Ready to scan</h2>
                <p class="site-overview__card-text">
                    Your site has been added. The next step is to run your first
                    scan to discover what's working and what needs attention.
                </p>
                <button
                    class="btn btn--primary"
                    :disabled="scanning"
                    @click="runScan"
                >
                    {{ scanning ? 'Scanning...' : 'Run First Scan' }}
                </button>
            </div>

            <!-- Scan completed -->
            <div v-else class="card">
                <h2 class="site-overview__card-title">Scan Complete</h2>
                <div class="scan-summary">
                    <div class="scan-stat">
                        <span class="scan-stat__value">{{ latestScan.summary_json?.total_findings ?? 0 }}</span>
                        <span class="scan-stat__label">Findings</span>
                    </div>
                    <div class="scan-stat scan-stat--blockers">
                        <span class="scan-stat__value">{{ latestScan.summary_json?.blockers ?? 0 }}</span>
                        <span class="scan-stat__label">Blockers</span>
                    </div>
                </div>
                <div class="site-overview__actions">
                    <Link
                        :href="`/sites/${site.id}/scans/${latestScan.id}`"
                        class="btn btn--primary"
                    >
                        View Results
                    </Link>
                    <Link
                        :href="`/sites/${site.id}/missions`"
                        class="btn btn--accent"
                    >
                        View Missions <span class="arrow">→</span>
                    </Link>
                    <button
                        class="btn btn--secondary"
                        :disabled="scanning"
                        @click="runScan"
                    >
                        {{ scanning ? 'Scanning...' : 'Run Again' }}
                    </button>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
.site-overview__header {
    margin-bottom: var(--space-lg);
}

.site-overview__url {
    font-size: 14px;
    color: var(--color-text-muted);
}
.site-overview__url:hover {
    color: var(--color-accent);
}

.site-overview__status-bar {
    margin-bottom: var(--space-xl);
}

.site-overview__card-title {
    font-size: 1.25rem;
    font-weight: 700;
    color: var(--color-cobalt);
    margin: 0 0 0.5rem;
}

.site-overview__card-text {
    font-size: 15px;
    color: var(--color-text-muted);
    margin: 0 0 var(--space-lg);
    line-height: 1.7;
}

.scan-summary {
    display: flex;
    gap: var(--space-xl);
    margin-bottom: var(--space-lg);
}

.scan-stat {
    display: flex;
    flex-direction: column;
}

.scan-stat__value {
    font-size: 2rem;
    font-weight: 700;
    color: var(--color-text);
    line-height: 1;
}

.scan-stat--blockers .scan-stat__value {
    color: var(--color-danger);
}

.scan-stat__label {
    font-size: 13px;
    color: var(--color-text-muted);
    margin-top: 4px;
}

.site-overview__actions {
    display: flex;
    gap: var(--space-md);
}
</style>

