<script setup lang="ts">
import { Link } from '@inertiajs/vue3';
</script>

<template>
    <div class="app-layout">
        <header class="app-header">
            <div class="app-header__inner">
                <Link href="/" class="app-logo">23P4</Link>
                <nav class="app-nav">
                    <Link href="/" class="app-nav__link">Dashboard</Link>
                </nav>
            </div>
        </header>
        <main class="app-main">
            <slot />
        </main>
    </div>
</template>

<style scoped>
.app-layout {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
}

.app-header {
    border-bottom: 1px solid oklch(0% 0 none / 0.06);
    background: oklch(100% 0 none / 0.85);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    position: sticky;
    top: 0;
    z-index: 100;
    transition: box-shadow 0.3s ease;
}

.app-header__inner {
    max-width: var(--content-max-width);
    margin: 0 auto;
    padding: 0 var(--padding-inline);
    display: flex;
    align-items: center;
    gap: var(--space-xl);
    height: 60px;
}

.app-logo {
    font-size: 1.375rem;
    font-weight: 800;
    color: var(--color-cobalt);
    text-decoration: none;
    letter-spacing: -0.04em;
}
.app-logo:hover {
    color: var(--color-accent);
}

.app-nav {
    display: flex;
    align-items: center;
    gap: var(--space-lg);
}

.app-nav__link {
    font-size: 14px;
    font-weight: 600;
    color: var(--color-text-muted);
    text-decoration: none;
    padding: 6px 0;
    position: relative;
    transition: color 0.3s ease;
}
.app-nav__link::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    width: 0;
    height: 2px;
    background: var(--color-accent);
    transition: width 0.3s var(--ease-out-expo);
}
.app-nav__link:hover {
    color: var(--color-cobalt);
}
.app-nav__link:hover::after {
    width: 100%;
}

.app-main {
    flex: 1;
    max-width: var(--content-max-width);
    margin: 0 auto;
    padding: var(--space-2xl) var(--padding-inline);
    width: 100%;
}
</style>

