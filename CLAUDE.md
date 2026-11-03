# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Static website for Kerry Canoe Club (kerrycanoeclub.com), built with Jekyll and deployed by GitHub Pages straight from the default branch (custom domain set in `CNAME`). There is no unit test suite or linter. The one automated check is `.github/workflows/check-site.yml`, which runs on every pull request and every push to `master`: it builds the site and runs `html-proofer` on `_site/` to make sure every internal link, image and script points at a file that exists and every image has alt text. External links are not checked. "Testing" a change means building the site, running the same check (below) and looking at the output.

## Commands

```bash
bundle install                # install the pinned github-pages gem set (see Gemfile)
bundle exec jekyll serve      # local dev server at http://127.0.0.1:4000
bundle exec jekyll build      # build into _site/ (gitignored)
LC_ALL=C.UTF-8 bundle exec htmlproofer ./_site --disable-external   # the CI check, run after a build
```

In cloud sessions, `.claude/hooks/session-start.sh` puts the gem executables folder on `PATH` and runs `bundle install` in the background at session start (skipped when `Gemfile`/`Gemfile.lock` are unchanged), so the session starts without waiting. If a build right at the start of a session fails with missing gems, the install is still running: wait a moment or run `bundle install`. If `bundle exec jekyll` still reports "command not found", run `rbenv rehash` or call the gem directly:

```bash
bundle exec ruby "$(bundle exec ruby -e 'print Gem.bin_path("jekyll","jekyll")')" build
```

Cloud sessions can't reach outside websites (only GitHub works), so don't try to check external links with web fetches or curl. A `PreToolUse` hook (`.claude/hooks/block-web-fetch.sh`) blocks `WebFetch` and the `web-fetch` agent in cloud sessions only; local sessions can fetch pages as normal. List the links that need checking and ask the user to click through them.

Dependencies: `Gemfile` pins `github-pages` to a specific version so local builds match what GitHub Pages runs (Jekyll 3.10). Dependabot opens PRs that bump `Gemfile.lock`. Only plugins on the GitHub Pages allowlist work. `html-proofer` sits in the Gemfile's `test` group because only the CI check uses it, not GitHub Pages. Two plugins are in use: `jekyll-seo-tag` (the `{% seo %}` tag in `_includes/head.html`, which writes each page's `<title>`, description and social-sharing tags) and `jekyll-sitemap` (generates `sitemap.xml`). The `defaults:` block in `_config.yml` sets the share image for every page and keeps `assets/documents/archive/` out of the sitemap.

## Architecture

- **Homepage** (`index.html`, `layout: default`): `_layouts/default.html` stitches together the `_includes/` sections in order: header, home, about, page_content, details, contact, footer and js. The nav in `header.html` scrolls to anchors (`/#about`, `/#details`) on this page and links to the main content pages; `footer.html` has a shorter menu. Add a new page to these menus and to the list in `moreinfo.html`.
- **Homepage feature blocks come from the `_services/` collection**: `_includes/page_content.html` loops over `site.services` sorted by file path and alternates the image left and right. Each file supplies `title`, `img` (a filename under `img/services/`) and HTML body content. To add, reorder or edit a homepage block, edit those files. The filename order (`services-1`, `services-2`, ...) sets the display order. The collection has `output: false` in `_config.yml`, so the blocks never get pages of their own. The site has no blog posts and no RSS feed.
- **Content pages** (`beginners.html`, `safety.html`, `policies.html` and so on) use `_layouts/page.html`. They set `title`, `subTitle`, `description` (one sentence for search results and link previews), `img` (a hero image from `img/services/`) and an explicit `permalink: <name>.html`, so they are served at the site root.
- **Asset paths are relative** (`css/...`, `img/...`, `js/...`, `assets/...`). That only works because every page lives at the site root. A new page needs the same `permalink: <name>.html` pattern, or root-absolute paths.
- **Styling**: Bootstrap 3 (`css/bootstrap.min.css` and `js/bootstrap.min.js`), plus the "landing-page" theme in `css/landing-page.css`, and Font Awesome 4.1 (`font-awesome-4.1.0/`). jQuery 1.11 plus `js/landing-page.js`. There is no Sass, so CSS changes go straight into these `.css` files. `css/landing-page.css` uses CRLF line endings, so keep them when editing it.
- **Site-wide data** (title, contact email, copyright, social links) lives in `_config.yml`. The `social:` list drives the buttons in `home.html` and `contact.html`.
- **Documents**: club PDFs and forms (constitution, safety statement, codes of conduct, juniors and safeguarding documents) are in `assets/documents/` and are linked from `policies.html` and other pages. When a document is replaced with a newer version (often renamed with a year), update every link to it. Delete the superseded file rather than leaving it in the repo. `assets/documents/archive/` holds older club documents that nothing links to but that are kept for reference. `img/archive/` does the same for unused photos and the original high-resolution logo.
