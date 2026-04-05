# Portability

This skill is intentionally repo-owned and platform-neutral.

## Design Rules

- Keep the source of truth in `.ai/skills/blog-post-images/`.
- Avoid vendor-specific directives in the workflow text.
- Use plain Markdown, YAML, Python, shell commands, and repo files.
- Treat `agents/openai.yaml` as optional UI metadata for tools that understand it. The skill itself should still make sense without that file.

## Reuse in Other AI Tools

- For tools that support skill folders, point them at this folder or copy its contents into their skill registry.
- For tools that do not support skill loading, use `SKILL.md` as the operating prompt and run the bundled scripts directly.
- Keep references and scripts inside this folder so the workflow stays portable when copied to another platform.

## Tooling Expectations

The optimizer script prefers portable backends in this order:

1. Pillow, when available
2. ImageMagick (`magick` or `convert`)
3. `sips` on macOS

That order keeps the workflow usable on macOS and Linux while still working in this repo's current environment.
