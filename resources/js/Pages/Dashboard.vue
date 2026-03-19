<script setup lang="ts">
import AppLayout from '@/Layouts/AppLayout.vue';
import { Link } from '@inertiajs/vue3';
</script>

<template>
    <AppLayout>
        <div class="dashboard">
            <span class="section-tag">Dashboard</span>
            <h1 class="page-title">Welcome to 23P4</h1>
            <p class="page-subtitle" style="margin-bottom: var(--space-xl);">
                Your guided website growth system. Add your first site to get
                scanning and receive actionable missions.
            </p>
            <div class="card dashboard__card">
                <div class="dashboard__card-icon">🚀</div>
                <h2 class="dashboard__card-title">Get Started</h2>
                <p class="dashboard__card-text">
                    Add your website to begin your first scan and receive
                    your first set of missions.
                </p>
                <Link href="/sites/create" class="btn btn--primary">
                    Add Your Website <span class="arrow">→</span>
                </Link>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
.dashboard__card {
    max-width: 540px;
}

.dashboard__card-icon {
    font-size: 2rem;
    margin-bottom: var(--space-md);
}

.dashboard__card-title {
    font-size: 1.25rem;
    font-weight: 700;
    color: var(--color-cobalt);
    margin: 0 0 0.5rem;
}

.dashboard__card-text {
    font-size: 15px;
    color: var(--color-text-muted);
    margin: 0 0 var(--space-lg);
    line-height: 1.7;
}
</style>

