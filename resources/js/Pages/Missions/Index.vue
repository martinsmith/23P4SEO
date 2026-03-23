<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue';
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

interface BusinessProfile {
    id?: number;
    business_name: string | null;
    business_type: string | null;
    service_model: string | null;
    description: string | null;
    primary_location: string | null;
    service_area_summary: string | null;
    target_customer_summary: string | null;
}

interface SerpPresenceResult {
    title: string;
    link: string;
    snippet: string;
    position: number | null;
}

interface Competitor {
    id?: number;
    domain: string;
    label: string | null;
}

interface KeywordSnapshot {
    checked_at: string;
    position: number | null;
    found: boolean;
    result_url: string | null;
    top_competitors: string[];
    previous_position: number | null;
}

interface TrackedKeyword {
    id: number;
    keyword: string;
    intent_type: string;
    location_name: string | null;
    target_url: string | null;
    latest_snapshot: KeywordSnapshot | null;
}

const props = defineProps<{
    site: { id: number; display_name: string; primary_url: string; normalized_domain: string };
    latestScan: Scan | null;
    missions: Mission[];
    businessProfile: BusinessProfile | null;
    competitors: Competitor[];
    trackedKeywords: TrackedKeyword[];
    serperConfigured: boolean;
}>();

const activeTab = ref('visibility');
const scanning = ref(false);
const showDeleteModal = ref(false);
const deleting = ref(false);

/* ── Refresh props on mount (handles back-navigation from mission detail) ── */
onMounted(() => {
    router.reload({ only: ['missions'] });
});

/* ── Sub-tab system ── */
const visibilitySubTab = ref('technical');
const businessSubTab = ref('profile');

const visibilitySubTabs = [
    { key: 'technical', label: 'Technical', categories: ['technical', 'analytics', 'visibility'] },
    { key: 'social',    label: 'Social',    categories: ['social'] },
    { key: 'security',  label: 'Security',  categories: ['security'] },
    { key: 'misc',      label: 'Misc',      categories: [] as string[] },
] as const;

const businessSubTabs = [
    { key: 'profile',       label: 'Profile',       categories: [] as string[] },
    { key: 'content',       label: 'Content',       categories: ['content'] },
    { key: 'localisation',  label: 'Localisation',  categories: ['local_seo'] },
    { key: 'keywords',      label: 'Keywords',      categories: [] as string[] },
    { key: 'competitors',   label: 'Competitors',   categories: [] as string[] },
    { key: 'misc',          label: 'Misc',          categories: [] as string[] },
] as const;

const allVisibilityCategories = visibilitySubTabs.flatMap(t => t.categories);
const allBusinessCategories = businessSubTabs.flatMap(t => t.categories);

function missionsForSubTab(
    subTabKey: string,
    subTabs: readonly { key: string; categories: readonly string[] }[],
    allKnown: string[],
    parentKnown: string[],
) {
    const tab = subTabs.find(t => t.key === subTabKey);
    if (!tab) return [];
    if (tab.key === 'misc') {
        // Catch-all: missions in this parent tab but not in any named sub-tab
        return props.missions.filter(m => !allKnown.includes(m.category) && !parentKnown.includes(m.category));
    }
    return props.missions.filter(m => (tab.categories as readonly string[]).includes(m.category));
}

const visibilityMissions = computed(() =>
    missionsForSubTab(visibilitySubTab.value, visibilitySubTabs, allVisibilityCategories, allBusinessCategories)
);
const businessMissions = computed(() =>
    missionsForSubTab(businessSubTab.value, businessSubTabs, allBusinessCategories, allVisibilityCategories)
);

const activeMissions = computed(() => visibilityMissions.value.filter(m => m.status !== 'completed'));
const completedMissions = computed(() => visibilityMissions.value.filter(m => m.status === 'completed'));
const activeBusinessMissions = computed(() => businessMissions.value.filter(m => m.status !== 'completed'));
const completedBusinessMissions = computed(() => businessMissions.value.filter(m => m.status === 'completed'));

function subTabCount(
    subTabKey: string,
    subTabs: readonly { key: string; categories: readonly string[] }[],
    allKnown: string[],
    parentKnown: string[],
) {
    const all = missionsForSubTab(subTabKey, subTabs, allKnown, parentKnown);
    return all.filter(m => m.status !== 'completed').length;
}

/* ── Business Context form state ── */
const profileForm = reactive({
    business_name: props.businessProfile?.business_name ?? '',
    business_type: props.businessProfile?.business_type ?? '',
    service_model: props.businessProfile?.service_model ?? '',
    description: props.businessProfile?.description ?? '',
    primary_location: props.businessProfile?.primary_location ?? '',
    service_area_summary: props.businessProfile?.service_area_summary ?? '',
    target_customer_summary: props.businessProfile?.target_customer_summary ?? '',
});
const profileSaving = ref(false);
const profileSaved = ref(false);

/* ── SERP Presence state ── */
const serpPresenceResults = ref<SerpPresenceResult[]>([]);
const serpPresenceMentions = ref<SerpPresenceResult[]>([]);
const serpPresenceLoading = ref(false);
const serpPresenceError = ref<string | null>(null);
const serpPresenceSearched = ref(false);

const competitorsForm = reactive({
    competitors: props.competitors.length > 0
        ? props.competitors.map(c => ({ domain: c.domain, label: c.label ?? '' }))
        : [{ domain: '', label: '' }],
});
const competitorsSaving = ref(false);
const competitorsSaved = ref(false);

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

/* ── Business Context actions ── */
function flash(flag: { value: boolean }) {
    flag.value = true;
    setTimeout(() => { flag.value = false; }, 2500);
}

function saveProfile() {
    profileSaving.value = true;
    router.put(`/sites/${props.site.id}/business-profile`, { ...profileForm }, {
        preserveScroll: true,
        onFinish: () => { profileSaving.value = false; flash(profileSaved); },
    });
}

async function searchSerpPresence() {
    serpPresenceLoading.value = true;
    serpPresenceError.value = null;
    serpPresenceSearched.value = true;
    try {
        const res = await fetch(`/sites/${props.site.id}/serp-presence`);
        const data = await res.json();
        if (data.error) {
            serpPresenceError.value = data.error;
            serpPresenceResults.value = [];
            serpPresenceMentions.value = [];
        } else {
            serpPresenceResults.value = data.results ?? [];
            serpPresenceMentions.value = data.mentions ?? [];
        }
    } catch {
        serpPresenceError.value = 'Failed to search. Please try again.';
    } finally {
        serpPresenceLoading.value = false;
    }
}

function addCompetitor() { competitorsForm.competitors.push({ domain: '', label: '' }); }
function removeCompetitor(i: number) { competitorsForm.competitors.splice(i, 1); }

function saveCompetitors() {
    competitorsSaving.value = true;
    router.put(`/sites/${props.site.id}/business-competitors`, { competitors: competitorsForm.competitors }, {
        preserveScroll: true,
        onFinish: () => { competitorsSaving.value = false; flash(competitorsSaved); },
    });
}

/* ── Keywords state ── */
const newKeyword = ref('');
const addingKeyword = ref(false);
const suggestions = ref<{ keyword: string; intent_type: string; source: string }[]>([]);
const loadingSuggestions = ref(false);
const checkingKeyword = ref<number | null>(null);
const checkingAll = ref(false);
const keywordResult = ref<{ keyword_id: number; status: string; meaning: string } | null>(null);

function addKeyword() {
    if (!newKeyword.value.trim()) return;
    addingKeyword.value = true;
    router.post(`/sites/${props.site.id}/keywords`, {
        keyword: newKeyword.value.trim(),
    }, {
        preserveScroll: true,
        onFinish: () => { addingKeyword.value = false; newKeyword.value = ''; },
    });
}

function removeKeyword(kwId: number) {
    router.delete(`/sites/${props.site.id}/keywords/${kwId}`, { preserveScroll: true });
}

async function loadSuggestions() {
    loadingSuggestions.value = true;
    try {
        const res = await fetch(`/sites/${props.site.id}/keywords/suggestions`);
        const data = await res.json();
        suggestions.value = data.suggestions || [];
    } catch { suggestions.value = []; }
    loadingSuggestions.value = false;
}

function addSuggested(s: { keyword: string; intent_type: string }) {
    router.post(`/sites/${props.site.id}/keywords`, {
        keyword: s.keyword,
        intent_type: s.intent_type,
    }, { preserveScroll: true, onSuccess: () => {
        suggestions.value = suggestions.value.filter(x => x.keyword !== s.keyword);
    }});
}

function addAllSuggested() {
    const toAdd = suggestions.value.map(s => ({ keyword: s.keyword, intent_type: s.intent_type }));
    router.post(`/sites/${props.site.id}/keywords/bulk`, { keywords: toAdd }, {
        preserveScroll: true,
        onSuccess: () => { suggestions.value = []; },
    });
}

async function checkKeywordRanking(kwId: number) {
    checkingKeyword.value = kwId;
    keywordResult.value = null;
    try {
        const res = await fetch(`/sites/${props.site.id}/keywords/${kwId}/check`, { method: 'POST', headers: { 'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || '', 'Accept': 'application/json' } });
        const data = await res.json();
        if (data.error) { alert(data.error); }
        else { keywordResult.value = data; }
    } catch (e) { alert('Failed to check ranking'); }
    checkingKeyword.value = null;
    // Refresh page data
    router.reload({ only: ['trackedKeywords'], preserveScroll: true });
}

function checkAllRankings() {
    checkingAll.value = true;
    router.post(`/sites/${props.site.id}/keywords/check-all`, {}, {
        preserveScroll: true,
        onFinish: () => { checkingAll.value = false; },
    });
}

function rankingStatusText(kw: TrackedKeyword): string {
    const s = kw.latest_snapshot;
    if (!s) return 'Not checked yet';
    if (!s.found) return 'Not found in top 50';
    let text = `#${s.position}`;
    if (s.previous_position !== null && s.previous_position !== undefined) {
        const diff = s.previous_position - (s.position ?? 0);
        if (diff > 0) text += ` ↑${diff}`;
        else if (diff < 0) text += ` ↓${Math.abs(diff)}`;
    }
    return text;
}

function rankingMeaning(kw: TrackedKeyword): string {
    const s = kw.latest_snapshot;
    if (!s) return 'Check this keyword to see where you rank.';
    if (!s.found) return 'Your site does not appear in the first 50 results for this search.';
    if ((s.position ?? 99) <= 3) return 'Excellent — top 3 visibility. Maintain your position.';
    if ((s.position ?? 99) <= 10) return 'Page 1 — strong visibility. Small tweaks could push you higher.';
    if ((s.position ?? 99) <= 20) return 'Close to page 1 — a strong opportunity to improve.';
    return 'Limited visibility. Dedicated content could help.';
}

function rankingClass(kw: TrackedKeyword): string {
    const s = kw.latest_snapshot;
    if (!s || !s.found) return 'kw-rank--none';
    if ((s.position ?? 99) <= 3) return 'kw-rank--top';
    if ((s.position ?? 99) <= 10) return 'kw-rank--page1';
    if ((s.position ?? 99) <= 20) return 'kw-rank--close';
    return 'kw-rank--far';
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

            <!-- Tab bar -->
            <nav class="tab-bar">
                <button
                    :class="['tab-bar__tab', { 'tab-bar__tab--active': activeTab === 'visibility' }]"
                    @click="activeTab = 'visibility'"
                >Visibility</button>
                <button
                    :class="['tab-bar__tab', { 'tab-bar__tab--active': activeTab === 'business' }]"
                    @click="activeTab = 'business'"
                >Business Context</button>
            </nav>

            <!-- ═══ TAB: Visibility ═══ -->
            <div v-show="activeTab === 'visibility'">
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
                    <!-- Sub-tab bar -->
                    <nav class="sub-tab-bar">
                        <button
                            v-for="st in visibilitySubTabs"
                            :key="st.key"
                            :class="['sub-tab-bar__tab', { 'sub-tab-bar__tab--active': visibilitySubTab === st.key }]"
                            @click="visibilitySubTab = st.key"
                        >
                            {{ st.label }}
                            <span v-if="subTabCount(st.key, visibilitySubTabs, allVisibilityCategories, allBusinessCategories) > 0" class="sub-tab-bar__badge">
                                {{ subTabCount(st.key, visibilitySubTabs, allVisibilityCategories, allBusinessCategories) }}
                            </span>
                        </button>
                    </nav>

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

                    <!-- No active missions in this sub-tab -->
                    <div v-else class="card missions-index__empty">
                        <p class="missions-index__empty-text">✅ All clear — nothing to do here.</p>
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
            </div>

            <!-- ═══ TAB: Business Context ═══ -->
            <div v-show="activeTab === 'business'" class="biz-context">
                <p class="biz-context__intro">
                    Tell us about your business so we can tailor missions to your sector, location, and competitive landscape.
                </p>

                <!-- Sub-tab bar -->
                <nav class="sub-tab-bar">
                    <button
                        v-for="st in businessSubTabs"
                        :key="st.key"
                        :class="['sub-tab-bar__tab', { 'sub-tab-bar__tab--active': businessSubTab === st.key }]"
                        @click="businessSubTab = st.key"
                    >
                        {{ st.label }}
                        <span v-if="subTabCount(st.key, businessSubTabs, allBusinessCategories, allVisibilityCategories) > 0" class="sub-tab-bar__badge">
                            {{ subTabCount(st.key, businessSubTabs, allBusinessCategories, allVisibilityCategories) }}
                        </span>
                    </button>
                </nav>

                <!-- ── Profile sub-tab ── -->
                <div v-show="businessSubTab === 'profile'">
                    <form class="card biz-form" @submit.prevent="saveProfile">
                        <h3 class="biz-form__title">About Your Business</h3>
                        <div class="biz-form__grid">
                            <label class="biz-field">
                                <span class="biz-field__label">Business Name</span>
                                <input v-model="profileForm.business_name" type="text" class="biz-field__input" placeholder="e.g. Smith & Co Plumbing" />
                            </label>
                            <label class="biz-field">
                                <span class="biz-field__label">Business Type / Sector</span>
                                <input v-model="profileForm.business_type" type="text" class="biz-field__input" placeholder="e.g. Plumber, Bakery, Solicitor" />
                            </label>
                            <label class="biz-field">
                                <span class="biz-field__label">Service Model</span>
                                <select v-model="profileForm.service_model" class="biz-field__input">
                                    <option value="">Select…</option>
                                    <option value="local">Local (serves a specific area)</option>
                                    <option value="national">National</option>
                                    <option value="online">Online / E-commerce</option>
                                    <option value="hybrid">Hybrid (local + online)</option>
                                </select>
                            </label>
                            <label class="biz-field">
                                <span class="biz-field__label">Primary Location</span>
                                <input v-model="profileForm.primary_location" type="text" class="biz-field__input" placeholder="e.g. Manchester, UK" />
                            </label>
                        </div>
                        <label class="biz-field">
                            <span class="biz-field__label">Short Description</span>
                            <textarea v-model="profileForm.description" class="biz-field__textarea" rows="2" placeholder="What does your business do in one or two sentences?"></textarea>
                        </label>
                        <label class="biz-field">
                            <span class="biz-field__label">Service Area</span>
                            <input v-model="profileForm.service_area_summary" type="text" class="biz-field__input" placeholder="e.g. Greater Manchester, North West England" />
                        </label>
                        <label class="biz-field">
                            <span class="biz-field__label">Target Customers</span>
                            <input v-model="profileForm.target_customer_summary" type="text" class="biz-field__input" placeholder="e.g. Homeowners, Small businesses" />
                        </label>
                        <div class="biz-form__actions">
                            <button type="submit" class="btn btn--primary btn--sm" :disabled="profileSaving">
                                {{ profileSaving ? 'Saving…' : 'Save Profile' }}
                            </button>
                            <span v-if="profileSaved" class="biz-form__saved">✓ Saved</span>
                        </div>
                    </form>

                    <!-- SERP Presence Search -->
                    <div class="card biz-form">
                        <div class="kw-tracked__header">
                            <h3 class="biz-form__title">Search Presence</h3>
                            <button class="btn btn--secondary btn--sm" :disabled="serpPresenceLoading || !serperConfigured" @click="searchSerpPresence">
                                {{ serpPresenceLoading ? 'Searching…' : 'Check Presence' }}
                            </button>
                        </div>
                        <p class="biz-form__hint">Discover which of your pages Google currently knows about. This searches for <strong>{{ site.normalized_domain }}</strong> across Google's index.</p>

                        <div v-if="!serperConfigured" class="serp-presence__notice">
                            🔑 Add your <code>SERPER_API_KEY</code> in <code>.env</code> to enable SERP presence search.
                        </div>

                        <div v-if="serpPresenceError" class="serp-presence__error">{{ serpPresenceError }}</div>

                        <div v-if="serpPresenceSearched && !serpPresenceLoading && !serpPresenceError">
                            <div v-if="serpPresenceResults.length === 0 && serpPresenceMentions.length === 0" class="serp-presence__empty">
                                <p class="serp-presence__status serp-presence__status--warning">⚠️ No results found</p>
                                <p class="serp-presence__meaning">Google doesn't appear to return any results when searching for your domain. This could mean your site is very new, has indexing issues, or is blocked from search engines.</p>
                                <div class="serp-presence__actions">
                                    <p><strong>What to do next:</strong></p>
                                    <ul>
                                        <li>Check your robots.txt isn't blocking Google</li>
                                        <li>Submit your sitemap via Google Search Console</li>
                                        <li>Ensure your pages have proper meta tags</li>
                                    </ul>
                                </div>
                            </div>

                            <div v-else>
                                <!-- Your pages -->
                                <div v-if="serpPresenceResults.length > 0">
                                    <p class="serp-presence__status serp-presence__status--good">
                                        ✅ {{ serpPresenceResults.length }} of your pages appear in search results
                                    </p>
                                    <p class="serp-presence__meaning">When someone searches for "{{ site.normalized_domain }}", these pages from your site appear. The position shows where they rank.</p>
                                    <div class="serp-presence__list">
                                        <div v-for="(result, i) in serpPresenceResults" :key="'own-'+i" class="serp-presence__item">
                                            <div class="serp-presence__item-header">
                                                <a :href="result.link" target="_blank" rel="noopener" class="serp-presence__link">{{ result.title }}</a>
                                                <span class="serp-presence__position">#{{ result.position }}</span>
                                            </div>
                                            <span class="serp-presence__url">{{ result.link }}</span>
                                            <p v-if="result.snippet" class="serp-presence__snippet">{{ result.snippet }}</p>
                                        </div>
                                    </div>
                                </div>
                                <div v-else>
                                    <p class="serp-presence__status serp-presence__status--warning">⚠️ None of your own pages appear in the top results</p>
                                    <p class="serp-presence__meaning">When someone searches for your domain, your site doesn't appear in the top results. This may indicate indexing issues.</p>
                                </div>

                                <!-- Mentions on other sites -->
                                <div v-if="serpPresenceMentions.length > 0" class="serp-presence__mentions">
                                    <h4 class="serp-presence__subtitle">Other sites mentioning you</h4>
                                    <p class="serp-presence__meaning">These third-party pages also appear when someone searches for your domain — directories, reviews, social profiles, etc.</p>
                                    <div class="serp-presence__list">
                                        <div v-for="(result, i) in serpPresenceMentions.slice(0, 10)" :key="'mention-'+i" class="serp-presence__item serp-presence__item--mention">
                                            <div class="serp-presence__item-header">
                                                <a :href="result.link" target="_blank" rel="noopener" class="serp-presence__link">{{ result.title }}</a>
                                                <span class="serp-presence__position">#{{ result.position }}</span>
                                            </div>
                                            <span class="serp-presence__url">{{ result.link }}</span>
                                            <p v-if="result.snippet" class="serp-presence__snippet">{{ result.snippet }}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ── Content sub-tab ── -->
                <div v-show="businessSubTab === 'content'">
                    <template v-if="activeBusinessMissions.length > 0 || completedBusinessMissions.length > 0">
                        <div v-if="activeBusinessMissions.length > 0" class="missions-section">
                            <h2 class="missions-section__title">To Do <span class="missions-section__count">{{ activeBusinessMissions.length }}</span></h2>
                            <div class="missions-grid">
                                <Link v-for="mission in activeBusinessMissions" :key="mission.id" :href="`/sites/${site.id}/missions/${mission.id}`" class="card card--interactive mission-card">
                                    <div class="mission-card__header">
                                        <span :class="['tag', priorityClass(mission.priority_score)]">{{ priorityLabel(mission.priority_score) }}</span>
                                        <span :class="['tag', statusClass(mission.status)]">{{ statusLabel(mission.status) }}</span>
                                    </div>
                                    <h3 class="mission-card__finding">{{ mission.source_finding_title || mission.outcome_statement }}</h3>
                                    <p class="mission-card__summary">{{ mission.user_summary }}</p>
                                    <div class="mission-card__footer">
                                        <div class="mission-card__progress">
                                            <div class="mission-card__progress-bar">
                                                <div class="mission-card__progress-fill" :style="{ width: mission.total_tasks > 0 ? (mission.completed_tasks / mission.total_tasks * 100) + '%' : '0%' }"></div>
                                            </div>
                                            <span class="mission-card__progress-text">{{ mission.completed_tasks }}/{{ mission.total_tasks }} tasks</span>
                                        </div>
                                        <span class="mission-card__category">{{ mission.category }}</span>
                                    </div>
                                </Link>
                            </div>
                        </div>
                        <hr v-if="activeBusinessMissions.length > 0 && completedBusinessMissions.length > 0" class="missions-divider" />
                        <div v-if="completedBusinessMissions.length > 0" class="missions-section">
                            <h2 class="missions-section__title">Completed <span class="missions-section__count">{{ completedBusinessMissions.length }}</span></h2>
                            <div class="missions-grid">
                                <Link v-for="mission in completedBusinessMissions" :key="mission.id" :href="`/sites/${site.id}/missions/${mission.id}`" class="card card--interactive mission-card mission-card--completed">
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
                    <div v-else class="card missions-index__empty">
                        <p class="missions-index__empty-text">✅ No content missions — looking good.</p>
                    </div>
                </div>

                <!-- ── Localisation sub-tab ── -->
                <div v-show="businessSubTab === 'localisation'">
                    <template v-if="activeBusinessMissions.length > 0 || completedBusinessMissions.length > 0">
                        <div v-if="activeBusinessMissions.length > 0" class="missions-section">
                            <h2 class="missions-section__title">To Do <span class="missions-section__count">{{ activeBusinessMissions.length }}</span></h2>
                            <div class="missions-grid">
                                <Link v-for="mission in activeBusinessMissions" :key="mission.id" :href="`/sites/${site.id}/missions/${mission.id}`" class="card card--interactive mission-card">
                                    <div class="mission-card__header">
                                        <span :class="['tag', priorityClass(mission.priority_score)]">{{ priorityLabel(mission.priority_score) }}</span>
                                        <span :class="['tag', statusClass(mission.status)]">{{ statusLabel(mission.status) }}</span>
                                    </div>
                                    <h3 class="mission-card__finding">{{ mission.source_finding_title || mission.outcome_statement }}</h3>
                                    <p class="mission-card__summary">{{ mission.user_summary }}</p>
                                    <div class="mission-card__footer">
                                        <div class="mission-card__progress">
                                            <div class="mission-card__progress-bar">
                                                <div class="mission-card__progress-fill" :style="{ width: mission.total_tasks > 0 ? (mission.completed_tasks / mission.total_tasks * 100) + '%' : '0%' }"></div>
                                            </div>
                                            <span class="mission-card__progress-text">{{ mission.completed_tasks }}/{{ mission.total_tasks }} tasks</span>
                                        </div>
                                        <span class="mission-card__category">{{ mission.category }}</span>
                                    </div>
                                </Link>
                            </div>
                        </div>
                        <hr v-if="activeBusinessMissions.length > 0 && completedBusinessMissions.length > 0" class="missions-divider" />
                        <div v-if="completedBusinessMissions.length > 0" class="missions-section">
                            <h2 class="missions-section__title">Completed <span class="missions-section__count">{{ completedBusinessMissions.length }}</span></h2>
                            <div class="missions-grid">
                                <Link v-for="mission in completedBusinessMissions" :key="mission.id" :href="`/sites/${site.id}/missions/${mission.id}`" class="card card--interactive mission-card mission-card--completed">
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
                    <div v-else class="card missions-index__empty">
                        <p class="missions-index__empty-text">✅ No localisation issues found.</p>
                    </div>
                </div>

                <!-- ── Keywords sub-tab ── -->
                <div v-show="businessSubTab === 'keywords'">
                    <div v-if="!serperConfigured" class="card missions-index__empty">
                        <p class="missions-index__empty-text">🔑 Search ranking API is not configured. Add your <code>SERPER_API_KEY</code> in <code>.env</code> to enable keyword tracking.</p>
                    </div>
                    <template v-else>
                        <!-- Add keyword -->
                        <div class="card kw-add">
                            <h3 class="biz-form__title">Track a Keyword</h3>
                            <form class="kw-add__form" @submit.prevent="addKeyword">
                                <input v-model="newKeyword" type="text" class="biz-field__input kw-add__input" placeholder="e.g. Lift Engineers Manchester" />
                                <button type="submit" class="btn btn--primary btn--sm" :disabled="addingKeyword || !newKeyword.trim()">
                                    {{ addingKeyword ? 'Adding…' : 'Add Keyword' }}
                                </button>
                            </form>
                        </div>

                        <!-- Suggestions -->
                        <div class="card kw-suggestions">
                            <div class="kw-suggestions__header">
                                <h3 class="biz-form__title">Suggested Keywords</h3>
                                <button class="btn btn--secondary btn--sm" :disabled="loadingSuggestions" @click="loadSuggestions">
                                    {{ loadingSuggestions ? 'Loading…' : 'Get Suggestions' }}
                                </button>
                            </div>
                            <p class="biz-form__hint">Based on your services, location, and competitors.</p>
                            <div v-if="suggestions.length > 0" class="kw-suggestions__list">
                                <div v-for="s in suggestions" :key="s.keyword" class="kw-suggestion">
                                    <div class="kw-suggestion__info">
                                        <span class="kw-suggestion__keyword">{{ s.keyword }}</span>
                                        <span class="kw-suggestion__source tag tag--neutral">{{ s.source }}</span>
                                    </div>
                                    <button class="btn btn--primary btn--xs" @click="addSuggested(s)">+ Track</button>
                                </div>
                                <button class="btn btn--secondary btn--sm kw-suggestions__add-all" @click="addAllSuggested">Track All Suggestions</button>
                            </div>
                            <p v-else-if="!loadingSuggestions" class="kw-suggestions__empty">Click "Get Suggestions" to generate keyword ideas from your business profile.</p>
                        </div>

                        <!-- Tracked keywords list -->
                        <div v-if="trackedKeywords.length > 0" class="card kw-tracked">
                            <div class="kw-tracked__header">
                                <h3 class="biz-form__title">Your Tracked Keywords</h3>
                                <button class="btn btn--secondary btn--sm" :disabled="checkingAll" @click="checkAllRankings">
                                    {{ checkingAll ? 'Checking…' : 'Check All Rankings' }}
                                </button>
                            </div>

                            <div class="kw-list">
                                <div v-for="kw in trackedKeywords" :key="kw.id" class="kw-item">
                                    <div class="kw-item__main">
                                        <div class="kw-item__keyword">{{ kw.keyword }}</div>
                                        <div :class="['kw-item__rank', rankingClass(kw)]">
                                            {{ rankingStatusText(kw) }}
                                        </div>
                                    </div>
                                    <p class="kw-item__meaning">{{ rankingMeaning(kw) }}</p>
                                    <div v-if="kw.latest_snapshot && kw.latest_snapshot.top_competitors && kw.latest_snapshot.top_competitors.length > 0" class="kw-item__competitors">
                                        <span class="kw-item__comp-label">Also ranking:</span>
                                        <span v-for="comp in kw.latest_snapshot.top_competitors.slice(0, 3)" :key="comp" class="tag tag--neutral kw-item__comp-tag">{{ comp }}</span>
                                    </div>
                                    <div class="kw-item__actions">
                                        <button class="btn btn--secondary btn--xs" :disabled="checkingKeyword === kw.id" @click="checkKeywordRanking(kw.id)">
                                            {{ checkingKeyword === kw.id ? 'Checking…' : 'Check Now' }}
                                        </button>
                                        <button class="kw-item__remove" @click="removeKeyword(kw.id)" title="Remove keyword">×</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </template>
                </div>

                <!-- ── Competitors sub-tab ── -->
                <div v-show="businessSubTab === 'competitors'">
                    <form class="card biz-form" @submit.prevent="saveCompetitors">
                        <h3 class="biz-form__title">Competitors</h3>
                        <p class="biz-form__hint">Add competitor websites you'd like to benchmark against. We'll use these in future keyword and visibility missions.</p>
                        <div v-for="(comp, i) in competitorsForm.competitors" :key="i" class="biz-form__row">
                            <input v-model="comp.domain" type="text" class="biz-field__input biz-field__input--wide" placeholder="competitor.com" />
                            <input v-model="comp.label" type="text" class="biz-field__input" placeholder="Label (optional)" />
                            <button v-if="competitorsForm.competitors.length > 1" type="button" class="biz-form__remove" @click="removeCompetitor(i)" title="Remove">×</button>
                        </div>
                        <button type="button" class="biz-form__add" @click="addCompetitor">+ Add competitor</button>
                        <div class="biz-form__actions">
                            <button type="submit" class="btn btn--primary btn--sm" :disabled="competitorsSaving">
                                {{ competitorsSaving ? 'Saving…' : 'Save Competitors' }}
                            </button>
                            <span v-if="competitorsSaved" class="biz-form__saved">✓ Saved</span>
                        </div>
                    </form>
                </div>

                <!-- ── Misc sub-tab ── -->
                <div v-show="businessSubTab === 'misc'">
                    <template v-if="activeBusinessMissions.length > 0 || completedBusinessMissions.length > 0">
                        <div v-if="activeBusinessMissions.length > 0" class="missions-section">
                            <h2 class="missions-section__title">To Do <span class="missions-section__count">{{ activeBusinessMissions.length }}</span></h2>
                            <div class="missions-grid">
                                <Link v-for="mission in activeBusinessMissions" :key="mission.id" :href="`/sites/${site.id}/missions/${mission.id}`" class="card card--interactive mission-card">
                                    <div class="mission-card__header">
                                        <span :class="['tag', priorityClass(mission.priority_score)]">{{ priorityLabel(mission.priority_score) }}</span>
                                        <span :class="['tag', statusClass(mission.status)]">{{ statusLabel(mission.status) }}</span>
                                    </div>
                                    <h3 class="mission-card__finding">{{ mission.source_finding_title || mission.outcome_statement }}</h3>
                                    <p class="mission-card__summary">{{ mission.user_summary }}</p>
                                    <div class="mission-card__footer">
                                        <div class="mission-card__progress">
                                            <div class="mission-card__progress-bar">
                                                <div class="mission-card__progress-fill" :style="{ width: mission.total_tasks > 0 ? (mission.completed_tasks / mission.total_tasks * 100) + '%' : '0%' }"></div>
                                            </div>
                                            <span class="mission-card__progress-text">{{ mission.completed_tasks }}/{{ mission.total_tasks }} tasks</span>
                                        </div>
                                        <span class="mission-card__category">{{ mission.category }}</span>
                                    </div>
                                </Link>
                            </div>
                        </div>
                    </template>
                    <div v-else class="card missions-index__empty">
                        <p class="missions-index__empty-text">No miscellaneous business missions yet.</p>
                    </div>
                </div>
            </div>

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

/* ═══ Tab bar ═══ */
.tab-bar {
    display: flex; gap: 0; margin-bottom: var(--space-xl);
    border-bottom: 2px solid var(--color-border);
}
.tab-bar__tab {
    padding: 10px 20px; font-size: 14px; font-weight: 600;
    color: var(--color-text-muted); background: none; border: none;
    border-bottom: 2px solid transparent; margin-bottom: -2px;
    cursor: pointer; transition: color 0.2s, border-color 0.2s;
}
.tab-bar__tab:hover { color: var(--color-text); }
.tab-bar__tab--active {
    color: var(--color-cobalt);
    border-bottom-color: var(--color-primary);
}

/* ═══ Sub-tab bar ═══ */
.sub-tab-bar {
    display: flex; gap: var(--space-sm); margin-bottom: var(--space-xl);
    padding: 4px; background: var(--color-border); border-radius: var(--radius-sm);
}
.sub-tab-bar__tab {
    padding: 6px 16px; font-size: 13px; font-weight: 600;
    color: var(--color-text-muted); background: none; border: none;
    border-radius: calc(var(--radius-sm) - 2px);
    cursor: pointer; transition: background 0.2s, color 0.2s;
    display: inline-flex; align-items: center; gap: 6px;
}
.sub-tab-bar__tab:hover { color: var(--color-text); background: oklch(98% 0.005 253 / 0.5); }
.sub-tab-bar__tab--active {
    color: var(--color-cobalt); background: var(--color-surface, #fff);
    box-shadow: 0 1px 3px oklch(0% 0 0 / 0.08);
}
.sub-tab-bar__badge {
    font-size: 11px; font-weight: 700; min-width: 18px; height: 18px;
    display: inline-flex; align-items: center; justify-content: center;
    background: oklch(55% 0.15 25 / 0.12); color: oklch(50% 0.15 25);
    border-radius: 9px; padding: 0 5px;
}
.sub-tab-bar__tab--active .sub-tab-bar__badge {
    background: oklch(45% 0.14 253 / 0.12); color: var(--color-cobalt);
}

/* ═══ Business Context tab ═══ */
.biz-context__intro {
    font-size: 15px; color: var(--color-text-muted); line-height: 1.7;
    margin: 0 0 var(--space-xl);
}
.biz-form { margin-bottom: var(--space-lg); }
.biz-form__title {
    font-size: 1rem; font-weight: 700; color: var(--color-cobalt);
    margin: 0 0 var(--space-sm);
}
.biz-form__hint {
    font-size: 13px; color: var(--color-text-muted); margin: 0 0 var(--space-md); line-height: 1.6;
}
.biz-form__grid {
    display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-md);
    margin-bottom: var(--space-md);
}
@media (max-width: 640px) { .biz-form__grid { grid-template-columns: 1fr; } }

.biz-field { display: flex; flex-direction: column; gap: 4px; margin-bottom: var(--space-md); }
.biz-field__label { font-size: 13px; font-weight: 600; color: var(--color-text); }
.biz-field__input {
    padding: 8px 12px; font-size: 14px; border: 1px solid var(--color-border);
    border-radius: var(--radius-sm); background: var(--color-surface);
    color: var(--color-text); transition: border-color 0.2s;
}
.biz-field__input:focus { border-color: var(--color-primary); outline: none; }
.biz-field__input--wide { flex: 2; }
.biz-field__textarea {
    padding: 8px 12px; font-size: 14px; border: 1px solid var(--color-border);
    border-radius: var(--radius-sm); background: var(--color-surface);
    color: var(--color-text); resize: vertical; font-family: inherit;
}
.biz-field__textarea:focus { border-color: var(--color-primary); outline: none; }

.biz-form__row {
    display: flex; gap: var(--space-sm); align-items: center; margin-bottom: var(--space-sm);
}
.biz-form__row .biz-field__input { flex: 1; }
.biz-form__remove {
    width: 28px; height: 28px; border-radius: 50%; border: 1px solid var(--color-border);
    background: none; color: var(--color-text-muted); font-size: 16px;
    cursor: pointer; display: flex; align-items: center; justify-content: center;
    flex-shrink: 0; transition: background 0.2s, color 0.2s;
}
.biz-form__remove:hover { background: oklch(95% 0.04 27); color: oklch(55% 0.15 25); }
.biz-form__add {
    background: none; border: none; color: var(--color-primary);
    font-size: 13px; font-weight: 600; cursor: pointer; padding: 4px 0;
    margin-bottom: var(--space-md);
}
.biz-form__add:hover { text-decoration: underline; }
.biz-form__actions { display: flex; align-items: center; gap: var(--space-md); }
.biz-form__saved {
    font-size: 13px; font-weight: 600; color: var(--color-success);
    animation: fade-in 0.3s ease;
}
@keyframes fade-in { from { opacity: 0; } to { opacity: 1; } }

/* ═══ Keywords sub-tab ═══ */
.kw-add { margin-bottom: var(--space-lg); }
.kw-add__form { display: flex; gap: var(--space-sm); align-items: center; }
.kw-add__input { flex: 1; }

.kw-suggestions { margin-bottom: var(--space-lg); }
.kw-suggestions__header { display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-xs); }
.kw-suggestions__list { margin-top: var(--space-md); display: flex; flex-direction: column; gap: var(--space-sm); }
.kw-suggestions__empty { font-size: 13px; color: var(--color-text-faint); margin-top: var(--space-sm); }
.kw-suggestions__add-all { margin-top: var(--space-md); align-self: flex-start; }

.kw-suggestion {
    display: flex; align-items: center; justify-content: space-between;
    padding: 8px 12px; background: oklch(97% 0.005 253); border-radius: var(--radius-sm);
    border: 1px solid var(--color-border);
}
.kw-suggestion__info { display: flex; align-items: center; gap: var(--space-sm); }
.kw-suggestion__keyword { font-size: 14px; font-weight: 600; color: var(--color-text); }
.kw-suggestion__source { font-size: 11px; }

.kw-tracked { margin-bottom: var(--space-lg); }
.kw-tracked__header { display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-md); }

.kw-list { display: flex; flex-direction: column; gap: var(--space-md); }

.kw-item {
    padding: var(--space-md); background: oklch(98% 0.006 253);
    border: 1px solid var(--color-border); border-radius: var(--radius-sm);
}
.kw-item__main { display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px; }
.kw-item__keyword { font-size: 15px; font-weight: 700; color: var(--color-text); }
.kw-item__rank {
    font-size: 14px; font-weight: 700; padding: 4px 12px;
    border-radius: var(--radius-sm);
}
.kw-rank--none { background: oklch(92% 0.01 253); color: var(--color-text-muted); }
.kw-rank--top { background: oklch(88% 0.12 145); color: oklch(30% 0.12 145); }
.kw-rank--page1 { background: oklch(90% 0.10 198); color: oklch(30% 0.12 198); }
.kw-rank--close { background: oklch(90% 0.06 70); color: oklch(42% 0.10 70); }
.kw-rank--far { background: oklch(88% 0.06 27); color: oklch(42% 0.16 27); }

.kw-item__meaning { font-size: 13px; color: var(--color-text-muted); line-height: 1.6; margin: 0 0 8px; }
.kw-item__competitors { display: flex; align-items: center; gap: 6px; margin-bottom: 8px; flex-wrap: wrap; }
.kw-item__comp-label { font-size: 12px; color: var(--color-text-faint); font-weight: 600; }
.kw-item__comp-tag { font-size: 11px; }

.kw-item__actions { display: flex; align-items: center; gap: var(--space-sm); }
.kw-item__remove {
    width: 24px; height: 24px; border-radius: 50%; border: 1px solid var(--color-border);
    background: none; color: var(--color-text-muted); font-size: 14px;
    cursor: pointer; display: flex; align-items: center; justify-content: center;
}
.kw-item__remove:hover { background: oklch(95% 0.04 27); color: oklch(55% 0.15 25); }

.btn--xs { padding: 4px 10px; font-size: 12px; }

/* ── SERP Presence ── */
.serp-presence__notice { padding: var(--space-sm); background: oklch(92% 0.04 80); border-radius: 8px; font-size: 14px; color: oklch(45% 0.08 80); }
.serp-presence__error { padding: var(--space-sm); background: oklch(92% 0.04 27); border-radius: 8px; font-size: 14px; color: oklch(50% 0.15 25); margin-bottom: var(--space-md); }
.serp-presence__empty { margin-top: var(--space-md); }
.serp-presence__status { font-weight: 600; font-size: 15px; margin-bottom: var(--space-xs); }
.serp-presence__status--warning { color: oklch(55% 0.15 60); }
.serp-presence__status--good { color: oklch(50% 0.14 155); }
.serp-presence__meaning { font-size: 14px; color: oklch(55% 0.02 253); margin-bottom: var(--space-sm); }
.serp-presence__actions { font-size: 14px; color: oklch(45% 0.02 253); }
.serp-presence__actions ul { margin: var(--space-xs) 0 0 var(--space-md); padding: 0; }
.serp-presence__actions li { margin-bottom: 4px; }
.serp-presence__list { margin-top: var(--space-md); display: flex; flex-direction: column; gap: var(--space-sm); }
.serp-presence__item { padding: var(--space-sm); background: oklch(97% 0.005 253); border-radius: 8px; border: 1px solid oklch(90% 0.01 253); }
.serp-presence__link { font-weight: 600; font-size: 14px; color: oklch(45% 0.14 253); text-decoration: none; display: block; }
.serp-presence__link:hover { text-decoration: underline; }
.serp-presence__url { font-size: 12px; color: oklch(55% 0.08 155); display: block; margin: 2px 0 4px; word-break: break-all; }
.serp-presence__snippet { font-size: 13px; color: oklch(50% 0.02 253); margin: 0; line-height: 1.4; }
.serp-presence__item-header { display: flex; justify-content: space-between; align-items: flex-start; gap: var(--space-sm); }
.serp-presence__position { font-size: 12px; font-weight: 600; color: oklch(50% 0.14 253); background: oklch(93% 0.03 253); padding: 2px 8px; border-radius: 10px; white-space: nowrap; }
.serp-presence__item--mention { border-left: 3px solid oklch(85% 0.08 198); }
.serp-presence__mentions { margin-top: var(--space-lg); padding-top: var(--space-md); border-top: 1px solid oklch(90% 0.01 253); }
.serp-presence__subtitle { font-size: 15px; font-weight: 600; color: oklch(35% 0.05 253); margin: 0 0 var(--space-xs); }
</style>

