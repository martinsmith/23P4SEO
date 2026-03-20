# 23P4 — Product Ethos & North Star

> A reference document to periodically revisit, ensuring development stays aligned with the original vision. Combines the founding product philosophy with the system we've built so far, and maps the road ahead.

---

## 1. What 23P4 Is

23P4 is **NOT an SEO tool**.

23P4 is a **guided website growth system** that replaces confusion, guesswork, and opaque SEO retainers with a clear, step-by-step journey of actions, validation, and measurable progress.

It does **not** overwhelm users with data. It **does** tell users exactly what to do next and confirms whether it worked.

### The North Star Loop

```
Clarity → Action → Validation → Progress → Visibility
```

If a feature does not support this loop, it should not be included.

### The Two Questions

23P4 must **always** answer:

1. **What should I do next?**
2. **Did it work?**

---

## 2. Core Philosophy

| Principle | Meaning |
|---|---|
| **Actionable guidance over raw data** | Never show a metric without telling the user what to do about it |
| **Simplicity over complexity** | If it needs a paragraph to explain, simplify the feature |
| **Progress over reporting** | The system tracks forward movement, not just current state |
| **Clarity over jargon** | Plain English always — explain technical terms when unavoidable |
| **Validation over assumption** | Re-scan and verify; never just trust that work was done |
| **Continuous journey over one-off audits** | 23P4 evolves with the site, generating new missions over time |

---

## 3. Target Users

- **Small business owners** with little or no SEO knowledge
- **Freelancers / developers** who build websites but don't offer SEO services
- **Anyone** who wants clarity, not complexity — and wants to reduce or remove the need for ongoing SEO retainers

---

## 4. Mental Model

23P4 behaves like a **guided journey system** (similar to a learning platform), not a traditional analytics dashboard. The user progresses through missions, validates their work, and moves forward. There is always a next step.

---

## 5. The Mission Model

Every finding — whether from a technical scan, keyword analysis, or competitor insight — becomes a **Mission**: a named, trackable unit of work with concrete tasks.

### Mission structure

| Field | Purpose |
|---|---|
| `source_finding_title` | Short name shown as the card heading (e.g. "XML Sitemap") |
| `user_summary` | Problem statement in plain language (e.g. "No XML sitemap was found…") |
| `rationale_summary` | The "why this matters" explanation |
| `priority_score` | 0–100 → mapped to Critical / High / Medium / Low |
| `impact_level` | How much fixing this will improve the site |
| `effort_level` | How hard the fix is |
| `tasks` | Ordered checklist of concrete, specific steps |
| `resources` | Code snippets, tips, and external links |
| `status` | `suggested` → `active` → `in_progress` → `completed` |

### Mission rules

- Every mission must be **tied to a clear outcome**
- Every mission must be **written in plain English**
- Every mission must contain **specific, achievable tasks**
- Every mission must be **prioritised by impact**
- **No generic checklists** — each mission is contextual

### Mission lifecycle
1. **Generated** — System finds an issue → mission created as `suggested`
2. **Activated** — User clicks "Start Mission" → status becomes `active`
3. **In Progress** — User completes at least one task
4. **Completed** — All tasks done, or system detects the fix on re-scan (auto-heal)

### Pass Missions
When a check finds **no issues**, a pre-completed "pass mission" is created. These appear in the Completed section with a positive summary. The system is **informative** — users see what's right, not just what's wrong.

### Mission Healing (Auto-Complete)
On re-scan, the system checks whether any open mission's issue is still present. If it's gone, the mission and all its tasks are **automatically completed**. Users never manually tick off work the system can verify.

---

## 6. The Full User Journey

This is the complete vision. Phases marked ✅ are built; phases marked 🔲 are ahead.

### Phase 1: Technical Foundation ✅ BUILT

1. User inputs website URL
2. System performs initial scan:
   - Robots.txt (presence, validity, blocking rules, sitemap reference)
   - XML Sitemap (presence, validity, URL count)
   - Homepage (HTTP status, title tag, meta description, H1, noindex)
   - Meta tags (Open Graph: og:title, og:description, og:image)
   - Technical SEO (canonical URL, structured data, viewport, lang)
   - Security headers (HTTPS, CSP, X-Frame-Options, HSTS, mixed content)
3. System generates prioritised missions from findings
4. User works through missions, following task checklists
5. User re-scans → system auto-heals completed missions and generates pass missions

### Phase 2: Business Context 🔲 NEXT

6. User provides context:
   - Business type / sector
   - Location and service area
   - Up to 5 competitors
7. System uses context to generate **smarter, more specific missions**
   - e.g. "Create a dedicated service page targeting 'Lift Engineers Manchester'"
   - e.g. "Add 300–500 words of location-specific content"

### Phase 3: Search Visibility 🔲 PLANNED

8. System suggests high-value keywords based on business + location
9. User can edit/add keywords (limit 5–10 for MVP)
10. Each keyword classified by intent:
    - High-intent service search
    - Informational
    - Local search
11. System tracks for each keyword:
    - Ranking position (top 50–100)
    - Whether the user appears at all
    - Top competitors in results
    - Changes over time

### Phase 4: Continuous Growth Loop 🔲 PLANNED

12. System generates **next set of missions** based on progress + new data
13. Progression model shows:
    - Ranking improvements over time
    - Completed actions
    - Movement toward page 1 visibility
14. The journey never ends — the system adapts as the site grows

---

## 7. Search Visibility (Future)

This is **NOT** a traditional rank tracker. It translates rankings into **meaning and action**.

### What the user sees (per keyword)

**Never** present raw SERP data. **Always** output:

1. **Current status**: "You are not ranking in the top 20" or "You are ranking #12 (up from #18)"
2. **Meaning**: "You have very low visibility for a key local search" or "You are close to page 1 — strong opportunity"
3. **Action**: Clear next steps tied to improving this keyword

### Example output

> **Search: "Lift Engineers Manchester"**
>
> You are currently not in the top 20 results.
>
> **What this means:** You have very low visibility for a key local search.
>
> **What to do next:**
> - Create a dedicated page targeting this keyword
> - Add Manchester-specific content
> - Internally link to this page from your homepage

### Competitor rule

- **Never** output: "Competitors are doing X"
- **Always** output: "You should do X because competitors benefit from it"

### Progress model

Progress must feel **tangible, motivating, and easy to understand**. Avoid obsessive rank tracking, stress-inducing fluctuations, and overly granular data.

### Technical approach (SERP tracking)

- Use **SERP APIs** (SerpAPI, DataForSEO, Zenserp) — not direct Google scraping
- Google Custom Search API as lightweight MVP fallback
- Scheduled tracking (daily/weekly), not real-time
- Location simulation via API parameters for consistent local results
- Store: keyword, position, timestamp, competitor domains
- **Cost control**: limit keywords per user, cache results, avoid unnecessary repeat queries

---

## 8. Visual Design

### Palette
- **Primary**: Deep cobalt — `oklch(45% 0.14 253)` — trust, professionalism
- **Headings**: Deepest navy — `oklch(30% 0.16 253)`
- **Accent**: Teal/cyan — `oklch(81% 0.14 198)` — action, progress
- **Background**: Warm cream — `oklch(95% 0.01 253)` — not cold grey

### Colour system (OKLCH)
All colours use the OKLCH colour space for perceptually uniform lightness. A "pale red" and a "pale green" at the same lightness value actually *look* equally pale.

### Mission card colouring
- **Active missions**: Very pale red/warm background (`oklch(98% 0.006 27)`)
  - Severity tags: Low/Medium → pale orange, High → pale red, Critical → solid red
- **Completed missions**: Very pale green background (`oklch(98% 0.008 145)`)
  - "✓ Passed" tag in darker green (`oklch(82% 0.10 145)`)

### Typography
- **Font**: Inter (400–800 weights)
- **Body**: 15px, line-height 1.7
- **Headings**: 800 weight, tight letter-spacing (-1px)

### Layout principles
- Max content width: 1120px
- 12px rounded corners on cards
- Subtle shadows (`0 1px 2px` base, `0 4px 24px` on hover)
- Micro-interactions: cards lift 2px on hover, arrows slide on button hover

---

## 9. Information Architecture

### Current (Phase 1) ✅

```
Dashboard (/):
├── Site cards with health score, severity counts, mission progress
├── "Add Another Site" card
└── Each card → Missions page

Missions (/sites/{id}/missions):
├── Site name + URL + Re-scan button
├── "To Do" section — active mission cards (pale red)
├── ── Divider ──
├── "Completed" section — passed/healed mission cards (pale green)
└── Danger Zone — delete site

Mission Detail (/sites/{id}/missions/{id}):
├── Finding title + severity + status tags
├── Problem summary + "Why this matters" rationale
├── Task checklist (manual tick-off + automated "Test" verification)
├── Resources (code snippets, tips, links)
└── "Mission Complete" celebration card
```

### Future additions will extend, not replace, this structure. New features (business context, keyword tracking) should surface through the existing Mission model wherever possible.

---

## 10. Technical Stack

| Layer | Technology |
|---|---|
| Backend | Laravel 13, PHP 8.3 |
| Frontend | Vue 3 (TypeScript), Inertia.js v2 |
| Styling | Vanilla CSS (no Tailwind), OKLCH colour space |
| Build | Vite 8 |
| Local dev | DDEV |
| Font loading | Google Fonts (Inter) |

---

## 11. What 23P4 Is NOT

- **Not a dashboard of scores and charts** — missions are the point
- **Not a rank tracker** — it will track rankings *in service of action*, never for their own sake
- **Not enterprise software** — clean, focused, simple enough for a solo site owner
- **Not a one-off audit** — it's a continuous journey that adapts as the site grows
- **Not a replacement for doing the work** — it tells you what to do and verifies it, but you still do it

---

## 12. AI Usage Principles (Future)

AI will be used to:
- **Interpret data** — turn raw scan/SERP results into plain-language insights
- **Prioritise actions** — surface the highest-impact missions first
- **Generate recommendations** — create specific, contextual mission tasks
- **Adapt over time** — adjust guidance based on progress and changing results

AI must **never**:
- Produce vague advice
- Overwhelm users with options
- Replace clarity with verbosity

---

## 13. Feature Gate

Every proposed feature must pass these questions:

1. **Does it help the user know what to do next?**
2. **Does it validate completed work?**
3. **Does it make progress clearer?**
4. **Is the language clear?** No jargon without explanation
5. **Does it auto-resolve?** If the system can detect a fix, it should — never make users do bookkeeping

If a feature fails these → reject or deprioritise.

---

## 14. Constraints

- Built by a solo developer using AI-assisted coding tools
- Must prioritise fast, iterative progress
- Should leverage APIs instead of building from scratch
- Must scale into SaaS

