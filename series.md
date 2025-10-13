---
layout: page
title: "Series"
---

<div class="series-index">
  <h1>Article Series</h1>
  <p>Explore collections of related articles organized by topic.</p>

  <div class="series-list">
    {% for series in site.data.series %}
      {% assign series_posts = site.posts | where: "series", series.name %}
      {% if series_posts.size > 0 %}
        <div class="series-item">
          <div class="series-item--header">
            <h2><a href="/series/{{ series.slug }}.html">{{ series.name }}</a></h2>
            <span class="series-count">{{ series_posts.size }} article{% if series_posts.size != 1 %}s{% endif %}</span>
          </div>
          <p class="series-description">{{ series.description }}</p>
          <div class="series-preview">
            {% assign latest_posts = series_posts | sort: "date" | reverse | limit: 3 %}
            {% for post in latest_posts %}
              <div class="series-preview--item">
                <a href="{{ post.url }}">{{ post.title }}</a>
                <span class="preview-date">{{ post.date | date_to_string }}</span>
              </div>
            {% endfor %}
          </div>
        </div>
      {% endif %}
    {% endfor %}
  </div>
</div>
