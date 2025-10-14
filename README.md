# Rooster's Blog

Personal blog of Michael Voorhaen, hosted on GitHub Pages.

## Prerequisites

- Ruby (version 2.7 or higher recommended)
- Bundler
- Git
- Homebrew (for macOS users)

## Local Development Setup

### Quick Setup (macOS)

If you're on macOS with Homebrew, you can use the automated setup script:

```bash
./setup.sh
```

This script will:
- Install rbenv and ruby-build if needed
- Install Ruby 3.2.0
- Configure your shell
- Install all dependencies
- Set up the project

### Manual Setup

#### 1. Clone the repository (if you haven't already)

```bash
git clone https://github.com/mvhaen/mvhaen.github.io.git
cd mvhaen.github.io
```

#### 2. Install Ruby (macOS users)

**Important:** Don't use macOS system Ruby! Install a modern Ruby version using rbenv:

```bash
# Install rbenv and ruby-build
brew install rbenv ruby-build

# Initialize rbenv (add to ~/.zshrc for persistence)
rbenv init

# Install Ruby 3.2.0 (or latest stable)
rbenv install 3.2.0

# Set Ruby version for this project
rbenv local 3.2.0

# Verify Ruby version
ruby -v
```

After running `rbenv init`, you'll need to add this line to your `~/.zshrc`:
```bash
eval "$(rbenv init - zsh)"
```

Then restart your terminal or run `source ~/.zshrc`.

#### 3. Install Bundler

```bash
gem install bundler
```

#### 4. Install dependencies

```bash
# Configure bundler to install gems locally (optional but recommended)
bundle config set --local path 'vendor/bundle'

# Install all gems
bundle install
```

#### 5. Run the site locally

```bash
bundle exec jekyll serve
```

The site will be available at `http://localhost:4000`

For live reloading during development:
```bash
bundle exec jekyll serve --livereload
```

To run on a different port:
```bash
bundle exec jekyll serve --port 4001
```

## Project Structure

```
.
├── _config.yml           # Site configuration
├── _data/                # Data files (YAML, JSON, CSV)
│   └── navigation.yml    # Navigation menu configuration
├── _includes/            # Reusable components
│   ├── carousel.html
│   ├── image-gallery.html
│   └── navigation.html
├── _layouts/             # Page templates
│   ├── page.html
│   └── post.html
├── _posts/               # Blog posts (markdown files)
├── _sass/                # Sass partials
│   └── main.scss
├── assets/               # Static assets
│   ├── css/
│   └── images/
├── about.md              # About page
├── index.html            # Homepage (blog list)
└── Gemfile               # Ruby dependencies
```

## Creating a New Blog Post

1. Create a new markdown file in `_posts/` following the naming convention:
   ```
   YYYY-MM-DD-title-of-post.md
   ```

2. Add front matter at the top of the file:
   ```yaml
   ---
   layout: post
   title: "Your Post Title"
   author: "Michael Voorhaen"
   date: YYYY-MM-DD
   draft: false
   ---
   ```

3. Write your content in Markdown below the front matter.

### Example Post

```markdown
---
layout: post
title: "My New Blog Post"
author: "Michael Voorhaen"
date: 2025-01-26
draft: false
---

This is the first paragraph of my blog post.

## A Heading

More content here...
```

### Working with Drafts

Jekyll has built-in support for drafts. To create a draft article:

1. **Create a draft file** in the `_drafts/` folder (no date prefix needed):
   ```
   _drafts/my-draft-article.md
   ```

2. **Add front matter** (no `draft:` flag needed):
   ```yaml
   ---
   layout: post
   title: "Work in Progress Article"
   author: "Michael Voorhaen"
   ---
   ```

3. **Preview drafts locally** by running Jekyll with the `--drafts` flag:
   ```bash
   bundle exec jekyll serve --drafts
   ```

4. **Drafts won't appear** when running without `--drafts` or on GitHub Pages (production)

5. **To publish a draft:**
   - Move it from `_drafts/` to `_posts/`
   - Add the date prefix to the filename: `YYYY-MM-DD-title.md`
   - Add a `date:` field to the front matter
   - Commit and push

**Example:**
```bash
# Move draft to posts
mv _drafts/my-article.md _posts/2025-01-26-my-article.md

# Edit the file to add date in front matter
# Then commit and push
```

**Note:** This is Jekyll's official recommended approach for handling drafts. Drafts in the `_drafts/` folder are never published to GitHub Pages, even if you push them.

## Adding Images

1. Create a folder for your post's images in `assets/images/`:
   ```
   assets/images/YYYY-MM-DD-post-title/
   ```

2. Place your images in that folder

3. Reference them in your post:
   ```markdown
   ![Alt text](/assets/images/YYYY-MM-DD-post-title/image.png)
   ```

## Using Custom Includes

### Image Gallery

```liquid
{% include image-gallery.html 
   folder="assets/images/your-folder" 
   images="image1.png,image2.png,image3.png" 
%}
```

### Carousel

```liquid
{% include carousel.html 
   folder="assets/images/your-folder" 
   images="image1.png,image2.png" 
%}
```

## Configuration

Edit `_config.yml` to change site-wide settings like:
- Site title
- Description
- Plugins

After changing `_config.yml`, restart the Jekyll server for changes to take effect.

## Deployment

This site is automatically deployed via GitHub Pages. Simply push your changes to the `main` branch:

```bash
git add .
git commit -m "Your commit message"
git push origin main
```

GitHub Pages will automatically build and deploy your site within a few minutes.

## Plugins

This site uses the following Jekyll plugins:
- `jekyll-feed` - Generates an Atom feed
- `jekyll-timeago` - Provides time ago functionality for dates

## Troubleshooting

### Bundle install fails with sudo errors
This happens when using macOS system Ruby. **Solution:**
1. Run the `./setup.sh` script to install rbenv and a modern Ruby version
2. Or follow the manual Ruby installation steps in this README

### Jekyll serve fails
- Make sure you're using `bundle exec jekyll serve` (not just `jekyll serve`)
- Try running `bundle update` to update dependencies
- Ensure you're using Ruby 2.7 or higher: `ruby -v`

### Changes not showing up
- Restart the Jekyll server (Ctrl+C and run `bundle exec jekyll serve` again)
- Clear your browser cache
- Check if you modified `_config.yml` (requires server restart)

### Ruby version issues
- Use rbenv to manage Ruby versions (see setup instructions above)
- Check your Ruby version: `ruby -v`
- The project requires Ruby 2.7 or higher

### "Command not found: bundle"
- Make sure bundler is installed: `gem install bundler`
- If using rbenv, run `rbenv rehash` after installing gems

## Resources

- [Jekyll Documentation](https://jekyllrb.com/docs/)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [Markdown Guide](https://www.markdownguide.org/)

