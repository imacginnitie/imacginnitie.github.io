# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Jekyll static site using the **al-folio** academic theme, deployed to GitHub Pages at **isabel.fyi**. The site is an academic portfolio for Isabel MacGinnitie.

## Build & Development Commands

```bash
bundle exec jekyll serve          # Local dev server (default: http://localhost:4000)
bundle exec jekyll build          # Build static site to _site/
./bin/deploy                      # Manual deploy to gh-pages branch
npx prettier --write .            # Format code (Liquid, HTML, JS)
```

**Prerequisites**: Ruby 3.3.5, Python 3.13, Node.js, ImageMagick, Bundler (`bundle install` to install gems).

## Deployment

Push to `main` triggers the GitHub Actions workflow (`.github/workflows/deploy.yml`) which builds, runs purgecss, and deploys to GitHub Pages via the `gh-pages` branch.

## Architecture

- **`_config.yml`** — Central configuration (662 lines). Controls plugins, third-party libraries, site metadata, image processing, collections, and all feature toggles.
- **`_pages/`** — Top-level site pages (about, blog, cv, projects, publications, photography, books, teaching). `about.md` is the landing page.
- **`_projects/`** — Project showcase entries. Numbered files with frontmatter controlling `title`, `img`, `importance` (display order), `category`, and `permalink`.
- **`_bibliography/papers.bib`** — BibTeX source for publications, rendered by jekyll-scholar.
- **`_data/`** — YAML data files: `cv.yml`, `socials.yml`, `repositories.yml`, `coauthors.yml`, `citations.yml`, `glossary.yml`, `venues.yml`.
- **`_layouts/`** — Liquid templates (default, about, post, page, bib, cv, distill, profiles).
- **`_includes/`** — Reusable template partials.
- **`_plugins/`** — Custom Ruby plugins (cache busting, 3rd-party downloads, citation fetching).
- **`_sass/`** — SCSS stylesheets.
- **`assets/`** — Static files: images (`img/`), CSS, JS, fonts, PDFs, `json/resume.json` (JSON Resume format).

## Key Patterns

- Content pages use YAML frontmatter for layout, title, permalink, and navigation settings.
- Publications flow: `_bibliography/papers.bib` → jekyll-scholar → `_layouts/bib.liquid`. Citation counts are auto-updated via `.github/workflows/update-citations.yml`.
- Image processing: jekyll-imagemagick generates responsive images (480px, 800px, 1400px) in webp format.
- Formatting: Prettier with `@shopify/prettier-plugin-liquid` handles Liquid/HTML formatting.
- Pre-commit hooks (`.pre-commit-config.yaml`): trailing whitespace, EOF fixes, YAML validation.
