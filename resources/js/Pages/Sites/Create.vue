<script setup lang="ts">
import AppLayout from '@/Layouts/AppLayout.vue';
import { ref } from 'vue';
import { router, usePage } from '@inertiajs/vue3';

const url = ref('');
const submitting = ref(false);

const page = usePage();

function submit() {
    submitting.value = true;
    router.post('/sites', { url: url.value }, {
        onFinish: () => {
            submitting.value = false;
        },
    });
}
</script>

<template>
    <AppLayout>
        <div class="create-site">
            <h1 class="page-title">Add your website</h1>
            <p class="page-subtitle" style="margin-bottom: var(--space-xl);">
                Enter your website URL to get started. We'll scan it and
                create your first set of missions.
            </p>

            <form class="card create-site__form" @submit.prevent="submit">
                <div class="form-group">
                    <label for="url" class="form-label">Website URL</label>
                    <input
                        id="url"
                        v-model="url"
                        type="url"
                        class="form-input"
                        placeholder="https://example.com"
                        required
                        autofocus
                    />
                    <p v-if="page.props.errors?.url" class="form-error">
                        {{ page.props.errors.url }}
                    </p>
                </div>

                <button
                    type="submit"
                    class="btn btn--primary"
                    :disabled="submitting || !url"
                >
                    {{ submitting ? 'Adding...' : 'Add Site' }}
                </button>
            </form>
        </div>
    </AppLayout>
</template>

<style scoped>
.create-site__form {
    max-width: 540px;
}
</style>

