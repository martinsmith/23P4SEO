<?php

namespace App\Services;

use App\Models\Mission;
use App\Models\ScanFinding;
use App\Models\SiteScan;

class MissionGenerator
{
    /**
     * Generate missions from scan findings.
     * Skips info-level findings and findings that already have active missions.
     */
    public function generateFromScan(SiteScan $scan): array
    {
        $findings = $scan->findings()
            ->where('severity', '!=', 'info')
            ->where('status', 'open')
            ->get();

        $created = [];

        foreach ($findings as $finding) {
            $template = $this->templateFor($finding->code);

            if (!$template) {
                continue;
            }

            // Skip if an open mission already exists for this finding code on this site.
            // We match by outcome_statement + category as a proxy for the finding code,
            // since multiple finding codes can map to different templates with unique outcomes.
            $existingMission = Mission::where('site_id', $finding->site_id)
                ->whereIn('status', ['suggested', 'active', 'in_progress'])
                ->where('source_type', 'scan_finding')
                ->where('category', $template['category'])
                ->where('outcome_statement', $template['outcome'])
                ->first();

            if ($existingMission) {
                continue;
            }

            $mission = Mission::create([
                'site_id' => $finding->site_id,
                'source_scan_id' => $scan->id,
                'source_type' => 'scan_finding',
                'source_finding_title' => $finding->title,
                'category' => $template['category'],
                'status' => 'suggested',
                'priority_score' => $template['priority'],
                'impact_level' => $template['impact'],
                'effort_level' => $template['effort'],
                'outcome_statement' => $template['outcome'],
                'user_summary' => $template['summary'],
                'rationale_summary' => $template['rationale'],
                'resources_json' => $template['resources'] ?? [],
                'created_by' => 'system',
            ]);

            // Create tasks
            foreach ($template['tasks'] as $i => $task) {
                $mission->tasks()->create([
                    'sort_order' => $i + 1,
                    'task_text' => $task['text'],
                    'task_type' => $task['type'],
                    'target_url' => $task['target_url'] ?? null,
                    'validation_rule_json' => $task['validation'] ?? null,
                    'status' => 'pending',
                ]);
            }

            $created[] = $mission;
        }

        return $created;
    }

    /**
     * Map finding codes to mission templates.
     */
    protected function templateFor(string $code): ?array
    {
        $templates = $this->templates();
        return $templates[$code] ?? null;
    }

    /**
     * Full template registry.
     */
    protected function templates(): array
    {
        return [
            // === ROBOTS.TXT ===
            'robots_txt_blocks_all' => [
                'category' => 'technical',
                'priority' => 95,
                'impact' => 'critical',
                'effort' => 'low',
                'outcome' => 'Search engines can crawl your site',
                'summary' => 'Your robots.txt is blocking all search engine crawlers. Until this is fixed, your site cannot appear in search results.',
                'rationale' => 'The Disallow: / directive in robots.txt tells all crawlers to stay away from every page on your site.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Example: Correct robots.txt that allows crawling', 'content' => "User-agent: *\nAllow: /\n\nSitemap: https://yourdomain.com/sitemap.xml"],
                    ['type' => 'code', 'label' => 'What to look for (the problem)', 'content' => "User-agent: *\nDisallow: /"],
                    ['type' => 'link', 'label' => 'Google: Introduction to robots.txt', 'url' => 'https://developers.google.com/search/docs/crawling-indexing/robots/intro'],
                    ['type' => 'link', 'label' => 'Google: robots.txt tester tool', 'url' => 'https://search.google.com/search-console/robots-testing-tool'],
                ],
                'tasks' => [
                    ['text' => 'Open your robots.txt file (usually at the root of your website)', 'type' => 'manual'],
                    ['text' => 'Remove or modify the "Disallow: /" line to allow crawling', 'type' => 'manual'],
                    ['text' => 'Verify the change by visiting /robots.txt in your browser', 'type' => 'verify', 'validation' => ['check' => 'robots_not_blocking']],
                ],
            ],
            'robots_txt_missing' => [
                'category' => 'technical',
                'priority' => 40,
                'impact' => 'low',
                'effort' => 'low',
                'outcome' => 'Your site has a robots.txt file guiding search engines',
                'summary' => 'Your site is missing a robots.txt file. While not strictly required, it helps communicate crawling preferences.',
                'rationale' => 'A robots.txt file helps search engines crawl your site more efficiently.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Example: A basic robots.txt file', 'content' => "User-agent: *\nAllow: /\n\n# Block admin/private areas\nUser-agent: *\nDisallow: /admin/\nDisallow: /private/\n\nSitemap: https://yourdomain.com/sitemap.xml"],
                    ['type' => 'link', 'label' => 'Google: Create a robots.txt file', 'url' => 'https://developers.google.com/search/docs/crawling-indexing/robots/create-robots-txt'],
                    ['type' => 'tip', 'label' => 'Where to put it', 'content' => 'The robots.txt file must be placed at the root of your domain, e.g. https://yourdomain.com/robots.txt — it will not be found in subdirectories.'],
                ],
                'tasks' => [
                    ['text' => 'Create a robots.txt file in your website root directory', 'type' => 'manual'],
                    ['text' => 'Add basic directives: User-agent: * and Allow: /', 'type' => 'manual'],
                    ['text' => 'Add a Sitemap directive pointing to your sitemap.xml', 'type' => 'manual'],
                    ['text' => 'Upload the file and verify at /robots.txt', 'type' => 'verify', 'validation' => ['check' => 'robots_exists']],
                ],
            ],
            'robots_txt_no_sitemap' => [
                'category' => 'technical',
                'priority' => 35,
                'impact' => 'low',
                'effort' => 'low',
                'outcome' => 'Your robots.txt references your sitemap for faster discovery',
                'summary' => 'Your robots.txt does not include a Sitemap directive. Adding one helps search engines find your sitemap faster.',
                'rationale' => 'The Sitemap directive in robots.txt is an additional discovery mechanism beyond Search Console submission.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Add this line to the end of your robots.txt', 'content' => "Sitemap: https://yourdomain.com/sitemap.xml"],
                    ['type' => 'tip', 'label' => 'Multiple sitemaps', 'content' => 'You can list multiple sitemaps if you have them, e.g. one per language or content section. Just add a separate Sitemap: line for each.'],
                    ['type' => 'link', 'label' => 'Google: robots.txt specification', 'url' => 'https://developers.google.com/search/docs/crawling-indexing/robots/robots_txt'],
                ],
                'tasks' => [
                    ['text' => 'Open your robots.txt file', 'type' => 'manual'],
                    ['text' => 'Add a line: Sitemap: https://yourdomain.com/sitemap.xml', 'type' => 'manual'],
                    ['text' => 'Save and verify the change', 'type' => 'verify', 'validation' => ['check' => 'robots_has_sitemap']],
                ],
            ],
            'robots_txt_invalid' => [
                'category' => 'technical',
                'priority' => 45,
                'impact' => 'medium',
                'effort' => 'low',
                'outcome' => 'Your robots.txt contains valid directives',
                'summary' => 'Your robots.txt file exists but doesn\'t contain valid directives. Search engines may ignore it.',
                'rationale' => 'An invalid robots.txt can lead to unpredictable crawling behavior.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Example: Properly formatted robots.txt', 'content' => "User-agent: *\nAllow: /\nDisallow: /admin/\n\nUser-agent: Googlebot\nAllow: /\n\nSitemap: https://yourdomain.com/sitemap.xml"],
                    ['type' => 'tip', 'label' => 'Common mistakes', 'content' => "Each group must start with a User-agent: line. Directives like Allow: and Disallow: only apply to the User-agent above them. Blank lines separate groups. Comments start with #."],
                    ['type' => 'link', 'label' => 'Google: robots.txt tester tool', 'url' => 'https://search.google.com/search-console/robots-testing-tool'],
                    ['type' => 'link', 'label' => 'Google: robots.txt specification', 'url' => 'https://developers.google.com/search/docs/crawling-indexing/robots/robots_txt'],
                ],
                'tasks' => [
                    ['text' => 'Review your robots.txt file for correct syntax', 'type' => 'manual'],
                    ['text' => 'Ensure it starts with User-agent: followed by Allow/Disallow directives', 'type' => 'manual'],
                    ['text' => 'Test with Google\'s robots.txt tester in Search Console', 'type' => 'manual'],
                ],
            ],

            // === SITEMAP ===
            'sitemap_missing' => [
                'category' => 'technical',
                'priority' => 70,
                'impact' => 'high',
                'effort' => 'medium',
                'outcome' => 'Search engines can discover all your pages via an XML sitemap',
                'summary' => 'Your site has no XML sitemap. Without one, search engines must rely on crawling links to find your pages.',
                'rationale' => 'An XML sitemap is one of the most effective ways to ensure search engines know about all your important pages.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Example: A basic sitemap.xml', 'content' => "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n  <url>\n    <loc>https://yourdomain.com/</loc>\n    <lastmod>2026-01-15</lastmod>\n    <priority>1.0</priority>\n  </url>\n  <url>\n    <loc>https://yourdomain.com/about</loc>\n    <lastmod>2026-01-10</lastmod>\n    <priority>0.8</priority>\n  </url>\n</urlset>"],
                    ['type' => 'tip', 'label' => 'CMS plugins', 'content' => 'Most CMS platforms have sitemap plugins: Yoast SEO (WordPress), next-sitemap (Next.js), gatsby-plugin-sitemap (Gatsby). These generate and update your sitemap automatically.'],
                    ['type' => 'link', 'label' => 'Google: Build and submit a sitemap', 'url' => 'https://developers.google.com/search/docs/crawling-indexing/sitemaps/build-sitemap'],
                    ['type' => 'link', 'label' => 'sitemaps.org protocol specification', 'url' => 'https://www.sitemaps.org/protocol.html'],
                ],
                'tasks' => [
                    ['text' => 'Generate an XML sitemap listing all important pages on your site', 'type' => 'manual'],
                    ['text' => 'Place the sitemap.xml file at your website root (e.g. yourdomain.com/sitemap.xml)', 'type' => 'manual'],
                    ['text' => 'Add a Sitemap directive to your robots.txt', 'type' => 'manual'],
                    ['text' => 'Submit the sitemap in Google Search Console', 'type' => 'manual'],
                    ['text' => 'Verify the sitemap is accessible', 'type' => 'verify', 'validation' => ['check' => 'sitemap_exists']],
                ],
            ],
            'sitemap_empty' => [
                'category' => 'technical',
                'priority' => 65,
                'impact' => 'high',
                'effort' => 'medium',
                'outcome' => 'Your sitemap contains URLs for search engines to index',
                'summary' => 'Your sitemap exists but contains no URLs. Search engines cannot discover pages from an empty sitemap.',
                'rationale' => 'A sitemap with zero URLs provides no benefit. It needs to list your important pages.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Example: Sitemap with URL entries', 'content' => "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n  <url>\n    <loc>https://yourdomain.com/</loc>\n    <changefreq>weekly</changefreq>\n    <priority>1.0</priority>\n  </url>\n  <url>\n    <loc>https://yourdomain.com/services</loc>\n    <changefreq>monthly</changefreq>\n    <priority>0.8</priority>\n  </url>\n</urlset>"],
                    ['type' => 'tip', 'label' => 'Which pages to include', 'content' => 'Include pages you want indexed: your homepage, key landing pages, blog posts, and product pages. Exclude admin pages, search result pages, and duplicate content.'],
                    ['type' => 'link', 'label' => 'Google: Build and submit a sitemap', 'url' => 'https://developers.google.com/search/docs/crawling-indexing/sitemaps/build-sitemap'],
                ],
                'tasks' => [
                    ['text' => 'Identify all important pages on your site that should be indexed', 'type' => 'manual'],
                    ['text' => 'Update your sitemap.xml to include these pages with proper <url> entries', 'type' => 'manual'],
                    ['text' => 'Verify the sitemap now contains URLs', 'type' => 'verify', 'validation' => ['check' => 'sitemap_has_urls']],
                ],
            ],
            'sitemap_invalid' => [
                'category' => 'technical',
                'priority' => 60,
                'impact' => 'high',
                'effort' => 'medium',
                'outcome' => 'Your sitemap is valid XML that search engines can parse',
                'summary' => 'Your sitemap.xml file exists but doesn\'t contain valid sitemap XML structure.',
                'rationale' => 'Search engines need properly structured XML to parse your sitemap.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Required XML structure', 'content' => "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n  <url>\n    <loc>https://yourdomain.com/page</loc>\n  </url>\n</urlset>"],
                    ['type' => 'tip', 'label' => 'Common XML errors', 'content' => "Missing the XML declaration, wrong namespace URL, unclosed tags, or using HTML instead of XML. The namespace must be exactly: http://www.sitemaps.org/schemas/sitemap/0.9"],
                    ['type' => 'link', 'label' => 'XML Sitemap Validator', 'url' => 'https://www.xml-sitemaps.com/validate-xml-sitemap.html'],
                    ['type' => 'link', 'label' => 'sitemaps.org protocol specification', 'url' => 'https://www.sitemaps.org/protocol.html'],
                ],
                'tasks' => [
                    ['text' => 'Check your sitemap.xml for XML syntax errors', 'type' => 'manual'],
                    ['text' => 'Ensure it uses the correct sitemap namespace and <urlset> or <sitemapindex> structure', 'type' => 'manual'],
                    ['text' => 'Validate with an XML validator tool', 'type' => 'manual'],
                ],
            ],

            // === HOMEPAGE ===
            'homepage_noindex' => [
                'category' => 'technical',
                'priority' => 98,
                'impact' => 'critical',
                'effort' => 'low',
                'outcome' => 'Your homepage can be indexed by search engines',
                'summary' => 'Your homepage has a noindex directive, preventing it from appearing in search results entirely.',
                'rationale' => 'A noindex tag or header tells search engines to exclude the page. This is almost certainly unintentional for a homepage.',
                'resources' => [
                    ['type' => 'code', 'label' => 'What to look for in your HTML <head>', 'content' => "<!-- Remove this tag if found -->\n<meta name=\"robots\" content=\"noindex\">\n\n<!-- Or this variation -->\n<meta name=\"robots\" content=\"noindex, nofollow\">"],
                    ['type' => 'tip', 'label' => 'HTTP header variant', 'content' => 'The noindex can also be set via an HTTP header: X-Robots-Tag: noindex. Check your server config (nginx.conf, .htaccess, or app middleware) for this header.'],
                    ['type' => 'link', 'label' => 'Google: Robots meta tag specification', 'url' => 'https://developers.google.com/search/docs/crawling-indexing/robots-meta-tag'],
                ],
                'tasks' => [
                    ['text' => 'Check for a <meta name="robots" content="noindex"> tag in your homepage HTML', 'type' => 'manual'],
                    ['text' => 'Check for an X-Robots-Tag: noindex HTTP header', 'type' => 'manual'],
                    ['text' => 'Remove the noindex directive', 'type' => 'manual'],
                    ['text' => 'Verify the noindex is removed', 'type' => 'verify', 'validation' => ['check' => 'homepage_indexable']],
                ],
            ],
            'homepage_no_title' => [
                'category' => 'content',
                'priority' => 90,
                'impact' => 'critical',
                'effort' => 'low',
                'outcome' => 'Your homepage has a descriptive title tag for search results',
                'summary' => 'Your homepage is missing a <title> tag — one of the most important on-page SEO elements.',
                'rationale' => 'The title tag is displayed in search results and browser tabs. It\'s a primary ranking signal.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Example: Adding a title tag', 'content' => "<head>\n  <title>Your Business Name — What You Do | Location</title>\n</head>"],
                    ['type' => 'tip', 'label' => 'Title tag best practices', 'content' => "Keep it 50–60 characters. Put your primary keyword near the front. Make it unique and descriptive. Avoid keyword stuffing. Include your brand name, typically at the end separated by a pipe (|) or dash (—)."],
                    ['type' => 'link', 'label' => 'Google: Influence your title links in search results', 'url' => 'https://developers.google.com/search/docs/appearance/title-link'],
                    ['type' => 'link', 'label' => 'Moz: Title tag guide', 'url' => 'https://moz.com/learn/seo/title-tag'],
                ],
                'tasks' => [
                    ['text' => 'Write a compelling title (50–60 characters) that includes your primary keyword', 'type' => 'manual'],
                    ['text' => 'Add the <title> tag inside the <head> section of your homepage', 'type' => 'manual'],
                    ['text' => 'Verify the title tag is present', 'type' => 'verify', 'validation' => ['check' => 'homepage_has_title']],
                ],
            ],
            'homepage_title_too_short' => [
                'category' => 'content',
                'priority' => 55,
                'impact' => 'medium',
                'effort' => 'low',
                'outcome' => 'Your homepage title is descriptive and keyword-rich',
                'summary' => 'Your homepage title is very short. A well-crafted title of 50–60 characters can improve click-through rates.',
                'rationale' => 'Short titles miss the opportunity to include relevant keywords and compelling copy.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Example: Short vs. optimised title', 'content' => "<!-- Too short -->\n<title>My Site</title>\n\n<!-- Better: descriptive and keyword-rich -->\n<title>My Site — Expert Web Design & SEO Services in London</title>"],
                    ['type' => 'tip', 'label' => 'Formula for a good title', 'content' => 'Try this pattern: Primary Keyword — Secondary Keyword | Brand Name. Aim for 50–60 characters to avoid truncation in search results.'],
                    ['type' => 'link', 'label' => 'Google: Title link best practices', 'url' => 'https://developers.google.com/search/docs/appearance/title-link'],
                ],
                'tasks' => [
                    ['text' => 'Review your current title and identify your primary keyword', 'type' => 'manual'],
                    ['text' => 'Rewrite the title to be 50–60 characters, including your main keyword naturally', 'type' => 'manual'],
                    ['text' => 'Verify the updated title', 'type' => 'verify', 'validation' => ['check' => 'homepage_title_length']],
                ],
            ],
            'homepage_no_meta_description' => [
                'category' => 'content',
                'priority' => 60,
                'impact' => 'medium',
                'effort' => 'low',
                'outcome' => 'Your homepage has a compelling meta description for search results',
                'summary' => 'Your homepage is missing a meta description. This text often appears below your title in search results.',
                'rationale' => 'While not a direct ranking factor, a good meta description improves click-through rates from search results.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Example: Adding a meta description', 'content' => "<head>\n  <meta name=\"description\" content=\"We help small businesses grow online with expert SEO, web design, and digital marketing services. Free consultation available.\">\n</head>"],
                    ['type' => 'tip', 'label' => 'Writing a good meta description', 'content' => "Keep it 150–160 characters. Include a call to action. Summarise the page's value proposition. Include your primary keyword naturally — Google will bold matching terms in search results."],
                    ['type' => 'link', 'label' => 'Google: Control your snippets in search results', 'url' => 'https://developers.google.com/search/docs/appearance/snippet'],
                ],
                'tasks' => [
                    ['text' => 'Write a meta description (150–160 characters) summarising what your site offers', 'type' => 'manual'],
                    ['text' => 'Add the meta description tag to your homepage <head> section', 'type' => 'manual'],
                    ['text' => 'Verify the meta description is present', 'type' => 'verify', 'validation' => ['check' => 'homepage_has_meta_desc']],
                ],
            ],
            'homepage_no_h1' => [
                'category' => 'content',
                'priority' => 50,
                'impact' => 'medium',
                'effort' => 'low',
                'outcome' => 'Your homepage has a clear H1 heading',
                'summary' => 'Your homepage doesn\'t have an H1 heading. The H1 should clearly state what your page is about.',
                'rationale' => 'H1 tags help search engines and users understand your page\'s main topic.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Example: Adding an H1 heading', 'content' => "<body>\n  <h1>Expert Web Design & SEO Services for Small Businesses</h1>\n  <!-- rest of page content -->\n</body>"],
                    ['type' => 'tip', 'label' => 'H1 best practices', 'content' => "Use exactly one H1 per page. Make it descriptive and include your primary keyword. It should be the most prominent heading on the page — not your logo or site name."],
                    ['type' => 'link', 'label' => 'Google: Headings and SEO', 'url' => 'https://developers.google.com/search/docs/fundamentals/seo-starter-guide#use-heading-tags'],
                ],
                'tasks' => [
                    ['text' => 'Identify the main heading or value proposition for your homepage', 'type' => 'manual'],
                    ['text' => 'Add it as an <h1> tag, ideally near the top of the page content', 'type' => 'manual'],
                    ['text' => 'Verify the H1 is present', 'type' => 'verify', 'validation' => ['check' => 'homepage_has_h1']],
                ],
            ],
            'homepage_not_https' => [
                'category' => 'technical',
                'priority' => 75,
                'impact' => 'high',
                'effort' => 'medium',
                'outcome' => 'Your site is served securely over HTTPS',
                'summary' => 'Your site is not using HTTPS. Google uses HTTPS as a ranking signal, and browsers mark HTTP sites as "Not Secure".',
                'rationale' => 'HTTPS is essential for user trust, data security, and SEO. Most hosting providers offer free SSL certificates.',
                'resources' => [
                    ['type' => 'tip', 'label' => 'Free SSL certificates', 'content' => "Let's Encrypt provides free SSL certificates. Most hosting providers (Netlify, Vercel, Cloudflare, cPanel hosts) offer one-click SSL setup."],
                    ['type' => 'code', 'label' => 'Apache .htaccess redirect (HTTP → HTTPS)', 'content' => "RewriteEngine On\nRewriteCond %{HTTPS} off\nRewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]"],
                    ['type' => 'code', 'label' => 'Nginx redirect (HTTP → HTTPS)', 'content' => "server {\n    listen 80;\n    server_name yourdomain.com;\n    return 301 https://\$host\$request_uri;\n}"],
                    ['type' => 'link', 'label' => 'Let\'s Encrypt: Getting Started', 'url' => 'https://letsencrypt.org/getting-started/'],
                    ['type' => 'link', 'label' => 'Google: Secure your site with HTTPS', 'url' => 'https://developers.google.com/search/docs/crawling-indexing/https'],
                ],
                'tasks' => [
                    ['text' => 'Obtain an SSL certificate (many hosts offer free Let\'s Encrypt certificates)', 'type' => 'manual'],
                    ['text' => 'Install the certificate on your web server', 'type' => 'manual'],
                    ['text' => 'Set up redirects from HTTP to HTTPS for all pages', 'type' => 'manual'],
                    ['text' => 'Update internal links to use HTTPS', 'type' => 'manual'],
                    ['text' => 'Verify your site loads over HTTPS', 'type' => 'verify', 'validation' => ['check' => 'homepage_uses_https']],
                ],
            ],
            // === META TAGS & SOCIAL ===
            'missing_og_title' => [
                'category' => 'social',
                'priority' => 45,
                'impact' => 'medium',
                'effort' => 'low',
                'outcome' => 'Your homepage has Open Graph tags for rich social sharing',
                'summary' => 'Your homepage is missing an og:title meta tag. When shared on Facebook or LinkedIn, the preview won\'t have a proper title.',
                'rationale' => 'Open Graph tags control how your page appears when shared on social platforms. Without them, platforms guess — often poorly.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Add these OG tags to your <head>', 'content' => "<meta property=\"og:title\" content=\"Your Page Title\">\n<meta property=\"og:description\" content=\"A brief description of your page\">\n<meta property=\"og:image\" content=\"https://yourdomain.com/images/share.jpg\">\n<meta property=\"og:url\" content=\"https://yourdomain.com/\">\n<meta property=\"og:type\" content=\"website\">"],
                    ['type' => 'link', 'label' => 'Facebook Sharing Debugger', 'url' => 'https://developers.facebook.com/tools/debug/'],
                    ['type' => 'link', 'label' => 'Open Graph Protocol', 'url' => 'https://ogp.me/'],
                ],
                'tasks' => [
                    ['text' => 'Add an og:title meta tag to your homepage <head> section', 'type' => 'manual'],
                    ['text' => 'Add og:description and og:image tags as well for complete social previews', 'type' => 'manual'],
                    ['text' => 'Test with Facebook\'s Sharing Debugger tool', 'type' => 'manual'],
                    ['text' => 'Verify og:title is present', 'type' => 'verify', 'validation' => ['check' => 'has_og_title']],
                ],
            ],
            'missing_og_description' => [
                'category' => 'social',
                'priority' => 40,
                'impact' => 'medium',
                'effort' => 'low',
                'outcome' => 'Your social shares include a compelling description',
                'summary' => 'Your homepage is missing an og:description tag. Social previews will lack a description.',
                'rationale' => 'The og:description controls the snippet text shown in social media previews.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Example og:description tag', 'content' => "<meta property=\"og:description\" content=\"We help small businesses grow with expert SEO and web design. Free consultation.\">"],
                    ['type' => 'tip', 'label' => 'Best practice', 'content' => 'Keep og:description under 200 characters. Make it compelling — this is your pitch when someone shares your link.'],
                ],
                'tasks' => [
                    ['text' => 'Write a concise description (under 200 characters) for social sharing', 'type' => 'manual'],
                    ['text' => 'Add <meta property="og:description" content="..."> to your <head>', 'type' => 'manual'],
                    ['text' => 'Verify og:description is present', 'type' => 'verify', 'validation' => ['check' => 'has_og_description']],
                ],
            ],
            'missing_og_image' => [
                'category' => 'social',
                'priority' => 50,
                'impact' => 'high',
                'effort' => 'low',
                'outcome' => 'Your social shares display an eye-catching image',
                'summary' => 'Your homepage has no og:image tag. Posts shared on social media will have no image, dramatically reducing engagement.',
                'rationale' => 'Social posts with images get significantly more clicks and shares than those without.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Example og:image tag', 'content' => "<meta property=\"og:image\" content=\"https://yourdomain.com/images/og-share.jpg\">\n<meta property=\"og:image:width\" content=\"1200\">\n<meta property=\"og:image:height\" content=\"630\">"],
                    ['type' => 'tip', 'label' => 'Image size', 'content' => 'Use 1200×630 pixels for best results across all platforms. Use JPG or PNG format under 8MB.'],
                ],
                'tasks' => [
                    ['text' => 'Create a share image (1200×630 px) representing your brand/site', 'type' => 'manual'],
                    ['text' => 'Upload it to your website and add the og:image meta tag', 'type' => 'manual'],
                    ['text' => 'Verify og:image is present', 'type' => 'verify', 'validation' => ['check' => 'has_og_image']],
                ],
            ],
            'missing_twitter_card' => [
                'category' => 'social',
                'priority' => 30,
                'impact' => 'low',
                'effort' => 'low',
                'outcome' => 'Your site displays rich previews when shared on X/Twitter',
                'summary' => 'Your homepage lacks a twitter:card meta tag. Shares on X/Twitter won\'t show rich previews.',
                'rationale' => 'Twitter Cards enable rich media previews. Without them, links appear as plain text URLs.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Add Twitter Card tags', 'content' => "<meta name=\"twitter:card\" content=\"summary_large_image\">\n<meta name=\"twitter:title\" content=\"Your Page Title\">\n<meta name=\"twitter:description\" content=\"A brief description\">\n<meta name=\"twitter:image\" content=\"https://yourdomain.com/images/share.jpg\">"],
                    ['type' => 'link', 'label' => 'Twitter Card Validator', 'url' => 'https://cards-dev.twitter.com/validator'],
                ],
                'tasks' => [
                    ['text' => 'Add twitter:card meta tag (use "summary_large_image" for best display)', 'type' => 'manual'],
                    ['text' => 'Add twitter:title, twitter:description, and twitter:image tags', 'type' => 'manual'],
                    ['text' => 'Verify twitter:card is present', 'type' => 'verify', 'validation' => ['check' => 'has_twitter_card']],
                ],
            ],

            // === TECHNICAL SEO ===
            'missing_canonical' => [
                'category' => 'technical',
                'priority' => 55,
                'impact' => 'medium',
                'effort' => 'low',
                'outcome' => 'Your homepage specifies a canonical URL to prevent duplicate content',
                'summary' => 'Your homepage does not have a canonical link tag. This can cause duplicate content issues if your page is reachable via multiple URLs.',
                'rationale' => 'A canonical tag tells search engines which URL is the "official" version of a page, consolidating ranking signals.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Add a canonical tag to your <head>', 'content' => "<link rel=\"canonical\" href=\"https://yourdomain.com/\">"],
                    ['type' => 'tip', 'label' => 'When to use canonical', 'content' => 'Use canonical tags when the same content is accessible via multiple URLs (www vs non-www, HTTP vs HTTPS, trailing slash variations, query parameters).'],
                    ['type' => 'link', 'label' => 'Google: Consolidate duplicate URLs', 'url' => 'https://developers.google.com/search/docs/crawling-indexing/consolidate-duplicate-urls'],
                ],
                'tasks' => [
                    ['text' => 'Add a <link rel="canonical"> tag to your homepage <head> pointing to the preferred URL', 'type' => 'manual'],
                    ['text' => 'Ensure the canonical URL uses HTTPS and your preferred domain format (www or non-www)', 'type' => 'manual'],
                    ['text' => 'Verify the canonical tag is present', 'type' => 'verify', 'validation' => ['check' => 'has_canonical']],
                ],
            ],
            'missing_structured_data' => [
                'category' => 'technical',
                'priority' => 45,
                'impact' => 'medium',
                'effort' => 'medium',
                'outcome' => 'Your homepage uses structured data to enable rich search results',
                'summary' => 'Your homepage has no JSON-LD structured data. Adding schema markup can enable rich results like star ratings, FAQs, and business info in search.',
                'rationale' => 'Structured data helps search engines understand your content and can unlock rich result features that increase click-through rates.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Example: Local Business JSON-LD', 'content' => "<script type=\"application/ld+json\">\n{\n  \"@context\": \"https://schema.org\",\n  \"@type\": \"LocalBusiness\",\n  \"name\": \"Your Business Name\",\n  \"url\": \"https://yourdomain.com\",\n  \"telephone\": \"+44 1234 567890\",\n  \"address\": {\n    \"@type\": \"PostalAddress\",\n    \"streetAddress\": \"123 Main St\",\n    \"addressLocality\": \"London\",\n    \"postalCode\": \"SW1A 1AA\",\n    \"addressCountry\": \"GB\"\n  }\n}\n</script>"],
                    ['type' => 'link', 'label' => 'Google Rich Results Test', 'url' => 'https://search.google.com/test/rich-results'],
                    ['type' => 'link', 'label' => 'Schema.org: Getting Started', 'url' => 'https://schema.org/docs/gs.html'],
                ],
                'tasks' => [
                    ['text' => 'Choose the appropriate schema type for your business (LocalBusiness, Organization, etc.)', 'type' => 'manual'],
                    ['text' => 'Create a JSON-LD script block with your business details', 'type' => 'manual'],
                    ['text' => 'Add the <script type="application/ld+json"> block to your homepage <head>', 'type' => 'manual'],
                    ['text' => 'Test with Google\'s Rich Results Test tool', 'type' => 'manual'],
                    ['text' => 'Verify structured data is present', 'type' => 'verify', 'validation' => ['check' => 'has_structured_data']],
                ],
            ],
            'missing_html_lang' => [
                'category' => 'technical',
                'priority' => 40,
                'impact' => 'medium',
                'effort' => 'low',
                'outcome' => 'Your page declares its language for search engines and accessibility tools',
                'summary' => 'Your homepage\'s <html> tag is missing a lang attribute. This helps search engines serve your page to the right audience.',
                'rationale' => 'The lang attribute improves accessibility for screen readers and helps search engines understand your content\'s language.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Add lang to your <html> tag', 'content' => "<html lang=\"en\">\n  <!-- for UK English use lang=\"en-GB\" -->\n  <!-- for US English use lang=\"en-US\" -->"],
                    ['type' => 'link', 'label' => 'MDN: lang attribute', 'url' => 'https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/lang'],
                ],
                'tasks' => [
                    ['text' => 'Add a lang attribute to your <html> tag (e.g., lang="en")', 'type' => 'manual'],
                    ['text' => 'Verify the lang attribute is present', 'type' => 'verify', 'validation' => ['check' => 'has_html_lang']],
                ],
            ],
            'missing_viewport' => [
                'category' => 'technical',
                'priority' => 75,
                'impact' => 'high',
                'effort' => 'low',
                'outcome' => 'Your site is mobile-friendly with a proper viewport tag',
                'summary' => 'Your homepage is missing the viewport meta tag. Without it, mobile devices will render the page at desktop width, making it unusable.',
                'rationale' => 'Google uses mobile-first indexing. A missing viewport tag means your site fails mobile-friendliness checks.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Add the viewport meta tag', 'content' => "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"],
                    ['type' => 'link', 'label' => 'Google: Mobile-Friendly Test', 'url' => 'https://search.google.com/test/mobile-friendly'],
                ],
                'tasks' => [
                    ['text' => 'Add the viewport meta tag to your homepage <head> section', 'type' => 'manual'],
                    ['text' => 'Verify the viewport tag is present', 'type' => 'verify', 'validation' => ['check' => 'has_viewport']],
                ],
            ],
            'missing_charset' => [
                'category' => 'technical',
                'priority' => 25,
                'impact' => 'low',
                'effort' => 'low',
                'outcome' => 'Your page declares its character encoding',
                'summary' => 'Your homepage does not declare a character encoding. Some browsers may display text incorrectly.',
                'rationale' => 'Declaring charset ensures consistent text rendering across all browsers and devices.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Add charset as the first tag in <head>', 'content' => "<head>\n  <meta charset=\"UTF-8\">\n  <!-- other head elements -->\n</head>"],
                ],
                'tasks' => [
                    ['text' => 'Add <meta charset="UTF-8"> as the first element in your <head> section', 'type' => 'manual'],
                    ['text' => 'Verify charset is declared', 'type' => 'verify', 'validation' => ['check' => 'has_charset']],
                ],
            ],

            // === SECURITY ===
            'missing_csp_header' => [
                'category' => 'security',
                'priority' => 20,
                'impact' => 'low',
                'effort' => 'high',
                'outcome' => 'Your site uses Content-Security-Policy to prevent XSS attacks',
                'summary' => 'Your site does not send a Content-Security-Policy header. CSP is a defence-in-depth measure against cross-site scripting.',
                'rationale' => 'While not a direct ranking factor, security headers build trust and prevent attacks that could compromise your site.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Example basic CSP header', 'content' => "Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'"],
                    ['type' => 'link', 'label' => 'MDN: Content-Security-Policy', 'url' => 'https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy'],
                    ['type' => 'tip', 'label' => 'Start with report-only', 'content' => 'Use Content-Security-Policy-Report-Only first to test your policy without breaking anything.'],
                ],
                'tasks' => [
                    ['text' => 'Determine which external resources your site loads (scripts, styles, fonts, images)', 'type' => 'manual'],
                    ['text' => 'Create a CSP policy that allows your required sources', 'type' => 'manual'],
                    ['text' => 'Deploy the header in report-only mode first to test', 'type' => 'manual'],
                    ['text' => 'Switch to enforcing mode once verified', 'type' => 'manual'],
                ],
            ],
            'missing_x_content_type_options' => [
                'category' => 'security',
                'priority' => 20,
                'impact' => 'low',
                'effort' => 'low',
                'outcome' => 'Your site sends the X-Content-Type-Options security header',
                'summary' => 'Your site is missing the X-Content-Type-Options: nosniff header, which prevents MIME-type sniffing attacks.',
                'rationale' => 'This is a simple security header that prevents browsers from incorrectly interpreting files as different content types.',
                'resources' => [
                    ['type' => 'code', 'label' => 'Add this header in your server config', 'content' => "# Apache (.htaccess)\nHeader set X-Content-Type-Options \"nosniff\"\n\n# Nginx\nadd_header X-Content-Type-Options \"nosniff\" always;"],
                ],
                'tasks' => [
                    ['text' => 'Add X-Content-Type-Options: nosniff to your server configuration', 'type' => 'manual'],
                    ['text' => 'Verify the header is present', 'type' => 'verify', 'validation' => ['check' => 'has_x_content_type_options']],
                ],
            ],
            'mixed_content_detected' => [
                'category' => 'security',
                'priority' => 55,
                'impact' => 'medium',
                'effort' => 'medium',
                'outcome' => 'Your HTTPS site loads all resources securely',
                'summary' => 'Your HTTPS page references resources over plain HTTP. This can trigger browser warnings and block content.',
                'rationale' => 'Mixed content undermines HTTPS security. Browsers may block insecure resources, breaking page functionality.',
                'resources' => [
                    ['type' => 'tip', 'label' => 'Finding mixed content', 'content' => 'Open your browser\'s DevTools console and look for "Mixed Content" warnings. These tell you exactly which resources need updating.'],
                    ['type' => 'link', 'label' => 'MDN: Mixed content', 'url' => 'https://developer.mozilla.org/en-US/docs/Web/Security/Mixed_content'],
                ],
                'tasks' => [
                    ['text' => 'Open browser DevTools and identify all mixed content warnings', 'type' => 'manual'],
                    ['text' => 'Update all resource URLs from http:// to https://', 'type' => 'manual'],
                    ['text' => 'If resources are from external domains, verify they support HTTPS', 'type' => 'manual'],
                ],
            ],

            'homepage_not_200' => [
                'category' => 'technical',
                'priority' => 92,
                'impact' => 'critical',
                'effort' => 'high',
                'outcome' => 'Your homepage returns a successful HTTP 200 response',
                'summary' => 'Your homepage is returning an error status code. This means search engines and visitors cannot access your site properly.',
                'rationale' => 'A homepage that doesn\'t return HTTP 200 is a critical issue that prevents indexing and drives away visitors.',
                'resources' => [
                    ['type' => 'tip', 'label' => 'Common HTTP error codes', 'content' => "403 = Forbidden (check file permissions). 404 = Not Found (check your web root or routing). 500 = Server Error (check application logs). 502/503 = Gateway/Unavailable (check your server or hosting is running)."],
                    ['type' => 'link', 'label' => 'MDN: HTTP response status codes', 'url' => 'https://developer.mozilla.org/en-US/docs/Web/HTTP/Status'],
                    ['type' => 'link', 'label' => 'Google: HTTP status codes and Search', 'url' => 'https://developers.google.com/search/docs/crawling-indexing/http-network-errors'],
                ],
                'tasks' => [
                    ['text' => 'Check your web server error logs for the cause', 'type' => 'manual'],
                    ['text' => 'Verify your DNS is pointing to the correct server', 'type' => 'manual'],
                    ['text' => 'Check your application or CMS for errors', 'type' => 'manual'],
                    ['text' => 'Verify your homepage returns HTTP 200', 'type' => 'verify', 'validation' => ['check' => 'homepage_returns_200']],
                ],
            ],
        ];
    }
}

