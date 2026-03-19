<script setup lang="ts">
import AppLayout from '@/Layouts/AppLayout.vue';
import { Link } from '@inertiajs/vue3';

interface Finding {
    id: number;
    category: string;
    code: string;
    severity: string;
    title: string;
    summary: string;
    evidence: Record<string, unknown>;
    is_blocker: boolean;
    status: string;
}

interface Summary {
    total_findings: number;
    blockers: number;
    severity_counts: Record<string, number>;
    checks: Record<string, { status: string; findings_count?: number; elapsed_seconds?: number }>;
}

interface Site {
    id: number;
    display_name: string;
    primary_url: string;
}

interface Scan {
    id: number;
    status: string;
    completed_at: string | null;
}

const props = defineProps<{
    site: Site;
    scan: Scan;
    findings: Finding[];
    summary: Summary;
}>();

const severityOrder: Record<string, number> = {
    critical: 0,
    high: 1,
    medium: 2,
    low: 3,
    info: 4,
};

const sortedFindings = [...props.findings].sort(
    (a, b) => (severityOrder[a.severity] ?? 5) - (severityOrder[b.severity] ?? 5)
);

function severityLabel(severity: string): string {
    return severity.charAt(0).toUpperCase() + severity.slice(1);
}
</script>

<template>
    <AppLayout>
        <div class="scan-results">
            <div class="scan-results__header">
                <div>
                    <Link :href="`/sites/${site.id}`" class="scan-results__back">
                        ← {{ site.display_name }}
                    </Link>
                    <h1 class="page-title">Scan Results</h1>
                </div>
            </div>

            <!-- Summary cards -->
            <div class="scan-results__summary">
                <div class="summary-card">
                    <span class="summary-card__value">{{ summary.total_findings }}</span>
                    <span class="summary-card__label">Total Findings</span>
                </div>
                <div class="summary-card summary-card--critical" v-if="summary.severity_counts.critical">
                    <span class="summary-card__value">{{ summary.severity_counts.critical }}</span>
                    <span class="summary-card__label">Critical</span>
                </div>
                <div class="summary-card summary-card--high" v-if="summary.severity_counts.high">
                    <span class="summary-card__value">{{ summary.severity_counts.high }}</span>
                    <span class="summary-card__label">High</span>
                </div>
                <div class="summary-card summary-card--medium" v-if="summary.severity_counts.medium">
                    <span class="summary-card__value">{{ summary.severity_counts.medium }}</span>
                    <span class="summary-card__label">Medium</span>
                </div>
                <div class="summary-card summary-card--info" v-if="summary.severity_counts.info">
                    <span class="summary-card__value">{{ summary.severity_counts.info }}</span>
                    <span class="summary-card__label">Info</span>
                </div>
            </div>

            <!-- Findings list -->
            <div class="findings-list">
                <div
                    v-for="finding in sortedFindings"
                    :key="finding.id"
                    class="finding-card"
                    :class="'finding-card--' + finding.severity"
                >
                    <div class="finding-card__header">
                        <span class="severity-tag" :class="'severity-tag--' + finding.severity">
                            {{ severityLabel(finding.severity) }}
                        </span>
                        <span v-if="finding.is_blocker" class="blocker-tag">Blocker</span>
                        <span class="finding-card__category">{{ finding.category }}</span>
                    </div>
                    <h3 class="finding-card__title">{{ finding.title }}</h3>
                    <p class="finding-card__summary">{{ finding.summary }}</p>
                    <details v-if="finding.evidence && Object.keys(finding.evidence).length" class="finding-card__evidence">
                        <summary>Evidence</summary>
                        <dl class="evidence-list">
                            <template v-for="(value, key) in finding.evidence" :key="key">
                                <dt>{{ key }}</dt>
                                <dd>{{ value }}</dd>
                            </template>
                        </dl>
                    </details>
                </div>
            </div>

            <div v-if="sortedFindings.length === 0" class="findings-empty">
                <p>No findings from this scan. Your site looks good!</p>
            </div>
        </div>
    </AppLayout>
</template>



<style scoped>
.scan-results__back {
    font-size: 14px;
    color: var(--color-text-muted);
    text-decoration: none;
    transition: color 0.3s ease;
}
.scan-results__back:hover {
    color: var(--color-accent);
}

.scan-results__summary {
    display: flex;
    gap: var(--space-md);
    margin: var(--space-xl) 0;
    flex-wrap: wrap;
}

.summary-card {
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-md);
    padding: var(--space-lg);
    min-width: 120px;
    text-align: center;
    box-shadow: var(--shadow-sm);
}

.summary-card__value {
    display: block;
    font-size: 1.75rem;
    font-weight: 700;
    color: var(--color-text);
    line-height: 1;
}

.summary-card--critical .summary-card__value { color: var(--color-danger); }
.summary-card--high .summary-card__value { color: oklch(58% 0.18 38); }
.summary-card--medium .summary-card__value { color: var(--color-warning); }
.summary-card--info .summary-card__value { color: var(--color-info); }

.summary-card__label {
    display: block;
    font-size: 13px;
    color: var(--color-text-muted);
    margin-top: 4px;
}

.findings-list {
    display: flex;
    flex-direction: column;
    gap: var(--space-md);
}

.finding-card {
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-md);
    padding: var(--space-lg);
    border-left: 4px solid var(--color-border);
    box-shadow: var(--shadow-sm);
}

.finding-card--critical { border-left-color: var(--color-danger); }
.finding-card--high { border-left-color: oklch(58% 0.18 38); }
.finding-card--medium { border-left-color: var(--color-warning); }
.finding-card--low { border-left-color: var(--color-success); }
.finding-card--info { border-left-color: var(--color-info); }

.finding-card__header {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 8px;
}

.severity-tag {
    font-size: 12px;
    font-weight: 600;
    padding: 2px 10px;
    border-radius: var(--radius-sm);
    text-transform: uppercase;
    letter-spacing: 0.03em;
}

.severity-tag--critical { background: var(--color-danger-light); color: var(--color-danger); }
.severity-tag--high { background: oklch(95% 0.04 38); color: oklch(50% 0.18 38); }
.severity-tag--medium { background: var(--color-warning-light); color: oklch(50% 0.14 70); }
.severity-tag--low { background: var(--color-success-light); color: oklch(45% 0.14 145); }
.severity-tag--info { background: var(--color-info-light); color: var(--color-info); }

.blocker-tag {
    font-size: 12px;
    font-weight: 600;
    padding: 2px 10px;
    border-radius: var(--radius-sm);
    background: var(--color-danger);
    color: oklch(100% 0 none);
}

.finding-card__category {
    font-size: 12px;
    color: var(--color-text-muted);
    margin-left: auto;
    text-transform: capitalize;
}

.finding-card__title {
    font-size: 1rem;
    font-weight: 700;
    color: var(--color-cobalt);
    margin: 0 0 4px;
}

.finding-card__summary {
    font-size: 15px;
    color: var(--color-text-muted);
    margin: 0;
    line-height: 1.6;
}

.finding-card__evidence {
    margin-top: var(--space-md);
    font-size: 13px;
}

.finding-card__evidence summary {
    cursor: pointer;
    color: var(--color-text-muted);
    font-weight: 500;
}

.evidence-list {
    display: grid;
    grid-template-columns: auto 1fr;
    gap: 4px 16px;
    margin-top: 8px;
    font-size: 13px;
}

.evidence-list dt {
    font-weight: 600;
    color: var(--color-text-muted);
}

.evidence-list dd {
    margin: 0;
    color: var(--color-text);
    word-break: break-all;
}

.findings-empty {
    text-align: center;
    padding: var(--space-xl);
    color: var(--color-text-muted);
}
</style>
