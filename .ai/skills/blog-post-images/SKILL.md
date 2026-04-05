---
name: blog-post-images
description: Add supplied images to markdown blog posts with correct naming, folder placement, alt text, carousel/front-matter wiring, and web-friendly optimization. Use when working on `_drafts/` or `_posts/` in this Jekyll repo and the task includes screenshots, conference photos, slide images, speaker photos, or image cleanup before publish.
---

# Blog Post Images

## Overview

Use this skill to turn raw screenshots or camera images into article-ready assets.

Keep the workflow portable. Prefer plain Markdown, YAML front matter, Python, `git`, and `bundle exec jekyll build --drafts`. Do not depend on Codex-specific directives or macOS-only commands unless the bundled script selects them as a fallback.

Read [references/repo-media-rules.md](references/repo-media-rules.md) before editing article media in this repo. Read [references/portability.md](references/portability.md) if the skill needs to be wired into another AI tool.

## Workflow

1. Read the target article and identify the section each image should support.
2. Follow the article's existing image folder if one already exists. For new work, prefer a folder aligned with the post slug. For published posts in this repo, prefer `assets/images/YYYY-MM-DD-post-title/`.
3. Decide the presentation pattern before copying files:
   - Use a single Markdown image when one image supports one point.
   - Use a front-matter carousel when 2-4 images belong to the same subsection, moment, or comparison.
   - Avoid turning a carousel into a dumping ground for unrelated images.
4. Copy source images into the article folder with descriptive, lowercase, hyphenated filenames.
5. Write or update references in the article:
   - For a single image, use normal Markdown.
   - For a carousel, add items to `carousels:` in front matter and place `{% include carousel.html number="N" %}` where the set should appear.
6. Add meaningful alt text. For carousels, use `title` for the visible caption and `alt` for the description.
7. Optimize oversized media with `scripts/optimize_post_images.py`.
8. Verify the result:
   - referenced files exist
   - carousel numbering matches front matter order
   - the article still builds with `bundle exec jekyll build --drafts`

## Naming Rules

- Name files by subject, section, or takeaway instead of the camera filename.
- Keep names lowercase and hyphenated.
- Prefer names that are readable in git status, for example:
  - `chris-matts-unlock-value-of-llms.jpg`
  - `andrey-platformops-wardley-map.jpg`
  - `beffroi-exterior.jpg`
- If an article already uses a naming pattern, follow it instead of introducing a second one.

## Placement Rules

- Keep images close to the paragraph they support.
- Place a carousel immediately after the paragraph that introduces the shared point or example set.
- Mention the idea in the prose too. Do not rely on the image alone to communicate an important point.
- If the article already mixes standalone images and carousels, preserve that structure unless there is a clear editorial improvement.

## Optimization Rules

- Resize full-resolution photos down to a web-friendly maximum dimension. Default to `1600px` on the longest side unless a larger image is clearly necessary.
- Convert opaque screenshots or slide captures from `png` to `jpg` when that produces a meaningful size reduction and the image does not need transparency.
- Keep `png` when transparency matters or when the content would visibly degrade.
- Keep the original file when recompression makes the result larger.
- After a format change, update every article reference and any carousel front matter that points at the old extension.
- Rebuild the site after optimization.

Use the optimizer script for deterministic media cleanup:

```bash
python3 .ai/skills/blog-post-images/scripts/optimize_post_images.py \
  assets/images/your-post/*.png \
  --replace \
  --target-format auto \
  --max-dimension 1600 \
  --quality 82
```

Use `--output-dir` instead of `--replace` when you want to inspect generated files before swapping them in.

## Verification Checklist

- `git status --short` shows only the expected article and asset changes.
- Every referenced asset exists.
- Carousel numbering is still correct.
- No placeholder camera filenames leaked into the repo.
- `bundle exec jekyll build --drafts` succeeds.
