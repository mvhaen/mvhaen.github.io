# Repo Media Rules

Use these rules when applying the skill inside this repo.

## Source of Truth

- Read `EDITORIAL_WORKFLOW.md`, especially section 7 on images and carousels.
- If prose changes are involved, follow `WRITING_STYLE_GUIDE.md` and `.cursorrules`.

## Folder Choice

- For published posts, prefer `assets/images/YYYY-MM-DD-post-title/`.
- For drafts, follow the folder already used by the draft. Do not rename an existing draft image folder unless the user explicitly asks.

## Single Image vs Carousel

- Use a standalone Markdown image when one image supports one point.
- Use a carousel when several images belong to the same moment, comparison, or subsection.
- Keep carousels coherent and reasonably small.

## Carousel Pattern

Define carousel items in front matter:

```yaml
carousels:
  - images:
      - image: /assets/images/post/example-1.jpg
        url: /assets/images/post/example-1.jpg
        title: "Visible caption"
        alt: "What the image shows"
```

Render the carousel where it belongs:

```liquid
{% include carousel.html number="1" %}
```

## Accessibility

- Every standalone image needs meaningful alt text.
- Carousel items should use `alt` for description and `title` for the visible caption.
- If the image contains a key idea, mention the idea in the prose too.
