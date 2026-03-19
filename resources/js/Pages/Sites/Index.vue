<script setup lang="ts">
import AppLayout from '@/Layouts/AppLayout.vue';
import { Link } from '@inertiajs/vue3';

interface Site {
    id: number;
    display_name: string;
    primary_url: string;
    onboarding_status: string;
    created_at: string;
}

defineProps<{
    sites: Site[];
}>();
</script>

<template>
    <AppLayout>
        <div class="sites-index">
            <div class="sites-index__header">
                <h1 class="page-title">Your Sites</h1>
                <Link href="/sites/create" class="btn btn--primary">
                    Add Site
                </Link>
            </div>

            <div v-if="sites.length === 0" class="card sites-index__empty">
                <p>You haven't added any sites yet.</p>
                <Link href="/sites/create" class="btn btn--primary">
                    Add your first site
                </Link>
            </div>

            <div v-else class="sites-index__list">
                <Link
                    v-for="site in sites"
                    :key="site.id"
                    :href="'/sites/' + site.id"
                    class="card card--interactive site-card"
                >
                    <div class="site-card__name">{{ site.display_name }}</div>
                    <div class="site-card__url">{{ site.primary_url }}</div>
                    <span class="tag" :class="site.onboarding_status === 'pending_scan' ? 'tag--warning' : 'tag--neutral'">
                        {{ site.onboarding_status.replace(/_/g, ' ') }}
                    </span>
                </Link>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
.sites-index__header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: var(--space-xl);
}

.sites-index__empty {
    text-align: center;
    padding: var(--space-2xl);
    color: var(--color-text-muted);
}

.sites-index__empty p {
    margin: 0 0 var(--space-lg);
}

.sites-index__list {
    display: grid;
    gap: var(--space-md);
}

.site-card {
    display: block;
    text-decoration: none;
}

.site-card__name {
    font-size: 1.0625rem;
    font-weight: 700;
    color: var(--color-cobalt);
    margin-bottom: 4px;
}

.site-card__url {
    font-size: 13px;
    color: var(--color-text-muted);
    margin-bottom: 8px;
}
</style>

