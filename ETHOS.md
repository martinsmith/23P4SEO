# 23P4 — Product Ethos & North Star

> A reference document to periodically revisit, ensuring development stays aligned with the original vision.

---

## 1. What 23P4 Is

23P4 is an **SEO auditing and guidance tool** for website owners who aren't SEO specialists. It scans a site, identifies issues, and — crucially — tells the user **exactly what to do about each one**.

It is not a dashboard of scores and charts. It is a **mission control** that turns SEO problems into completable tasks.

---

## 2. Core Principles

### Informative, not just diagnostic
A scan that says "you're missing a sitemap" is diagnostic. 23P4 goes further: it explains *why* that matters, *what* to do about it, and lets you *verify* the fix — all in one place. When a check **passes**, 23P4 still tells you about it so you understand what's working and why.

### Action-oriented
Every issue becomes a **Mission** — a named, trackable unit of work with concrete tasks. The user never stares at a wall of warnings wondering "now what?". They open a mission, follow the steps, and mark it done.

### Honest & complete
The tool shows the full picture: things that need fixing **and** things that are already right. Completed/passed missions sit alongside active ones, separated visually but never hidden. The user should always be able to see "here's where I stand".

### Self-healing
When a user fixes an issue and re-scans, 23P4 **automatically detects the fix** and completes the corresponding mission and all its tasks. Users should never have to manually tick off work that the scanner can verify.

### No dead ends
Every screen leads somewhere useful. There are no orphan pages, no "overview for overview's sake" screens. The flow is: **Dashboard → Missions → Mission Detail**. Three pages, each with a clear purpose.

---

## 3. The Mission Model

Every SEO check maps to a **Mission**. A mission has:

| Field | Purpose |
|---|---|
| `source_finding_title` | Short name shown as the card heading (e.g. "XML Sitemap") |
| `user_summary` | Problem statement written as plain language (e.g. "No XML sitemap was found…") |
| `rationale_summary` | The "why this matters" explanation |
| `priority_score` | 0–100 numeric score → mapped to Critical / High / Medium / Low |
| `impact_level` | How much fixing this will improve SEO |
| `effort_level` | How hard the fix is |
| `tasks` | Ordered checklist of concrete steps |
| `resources` | Code snippets, tips, and external links to help the user |
| `status` | `suggested` → `active` → `in_progress` → `completed` |

### Mission lifecycle
1. **Generated** — Scanner finds an issue → mission created as `suggested`
2. **Activated** — User clicks "Start Mission" → status becomes `active`
3. **In Progress** — User completes at least one task
4. **Completed** — All tasks done, or scanner detects the fix on re-scan (auto-heal)

### Pass Missions
When a scan finds **no issues** in a check area, a pre-completed "pass mission" is created. These appear in the Completed section with a positive summary (e.g. "Your site has a valid XML sitemap…"). This ensures the tool is **informative** — users see what's right, not just what's wrong.

### Mission Healing
On re-scan, the `healFromScan()` method checks whether any open mission's `source_finding_code` is absent from the new scan results. If so, the mission and all its tasks are auto-completed. The user never manually ticks off work the scanner can verify.

---

## 4. The Scanner

Six check modules run in sequence:

| Check | What it examines |
|---|---|
| `RobotsTxtCheck` | Presence, validity, blocking rules, sitemap reference |
| `SitemapCheck` | Presence, validity, URL count |
| `HomepageCheck` | HTTP status, title tag, meta description, H1, noindex |
| `MetaTagCheck` | Open Graph tags (og:title, og:description, og:image) |
| `TechnicalCheck` | Canonical URL, structured data, viewport, lang attribute |
| `SecurityCheck` | HTTPS, CSP, X-Frame-Options, HSTS, mixed content |

Each check returns `CheckResult` objects with a severity (`critical`, `high`, `medium`, `low`, `info`). Info-level results are recorded but don't generate missions.

---

## 5. Visual Design

### Palette
- **Primary**: Deep cobalt — `oklch(45% 0.14 253)` — trust, professionalism
- **Headings**: Deepest navy — `oklch(30% 0.16 253)`
- **Accent**: Teal/cyan — `oklch(81% 0.14 198)` — action, progress
- **Background**: Warm cream — `oklch(95% 0.01 253)` — not cold grey

### Colour system (OKLCH)
All colours use the OKLCH colour space for perceptually uniform lightness. This means a "pale red" and a "pale green" at the same lightness value actually *look* equally pale.

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

## 6. Information Architecture

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

---

## 7. Technical Stack

| Layer | Technology |
|---|---|
| Backend | Laravel 13, PHP 8.3 |
| Frontend | Vue 3 (TypeScript), Inertia.js v2 |
| Styling | Vanilla CSS (no Tailwind), OKLCH colour space |
| Build | Vite 8 |
| Local dev | DDEV |
| Font loading | Google Fonts (Inter) |

---

## 8. What 23P4 Is NOT

- **Not a crawler** — it checks the homepage and key files (robots.txt, sitemap.xml), not every page
- **Not a rank tracker** — it doesn't monitor keyword positions
- **Not a competitor analysis tool** — it focuses solely on *your* site
- **Not a score-chasing game** — the health score exists but the missions are the point
- **Not enterprise software** — it's clean, focused, and simple enough for a solo site owner

---

## 9. Guiding Questions for Future Decisions

Before adding a feature, ask:

1. **Is it informative?** Does it help the user understand their site better?
2. **Is it actionable?** Can the user do something concrete as a result?
3. **Does it auto-resolve?** If we can detect a fix automatically, we should — never make users do bookkeeping.
4. **Does it fit in three pages?** Dashboard → Missions → Detail. If it needs a fourth page, think hard about why.
5. **Is the language clear?** No jargon without explanation. Problem statements, not status codes.

