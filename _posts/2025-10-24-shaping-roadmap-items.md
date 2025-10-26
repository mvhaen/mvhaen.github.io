---
layout: post
title: "Shaping Roadmap Items"
subtitle: "Building resilient and adaptive roadmaps"
author: "Michael Voorhaen"
series: "Roadmap Mastery"
excerpt: "Exploring how to balance scope, time, and quality in roadmap items while avoiding the pitfalls of feature-focused planning and embracing outcome-based approaches."
changelog:
  - date: "2025-10-25"
    changes:
      - "Added 'Feature vs Outcome — And Why It Changes How Teams Work' section to provide a concrete example of how focusing on outcomes rather than features changes team behavior and decision-making"
      - "Added strategic highlights throughout the article to emphasize key concepts"
  - date: "2025-10-26"
    changes:
      - "Added a visual example of how scope creep happens when we fall in love with features instead of focusing on problems"
      - "Added illustrations showing how user story mapping helps you see all the possibilities, then slice the work toward concrete outcomes"
carousels:
  - images:
      - url: /assets/images/2025-10-24-shaping-roadmap-items/story-mapping-1.png
        image: /assets/images/2025-10-24-shaping-roadmap-items/story-mapping-1.png
        title: "Story Mapping Overview"
      - url: /assets/images/2025-10-24-shaping-roadmap-items/story-mapping-2.png
        image: /assets/images/2025-10-24-shaping-roadmap-items/story-mapping-2.png
        title: "Story Mapping Detail"
      - url: /assets/images/2025-10-24-shaping-roadmap-items/story-mapping-3.png
        image: /assets/images/2025-10-24-shaping-roadmap-items/story-mapping-3.png
        title: "Value Slicing"
---

If you've ever struggled to create a roadmap that actually delivers on time and meets expectations, you're not alone. At Strobbo, I faced this challenge repeatedly—roadmaps that looked great on paper but fell apart when reality hit. The problem wasn't the planning itself, but how we were shaping the items on our roadmap.

What I really wanted was a roadmap with margin—not buffer time, but decision space to respond when reality changes. After all, change isn't a risk in product development—it's a constant.

<img src="/assets/images/2025-10-24-shaping-roadmap-items/quality-scope-time.jpg" alt="Quality, Scope, Time triangle" class="no-lightbox" style="width: 30%; float: left; margin: 0 20px 20px 0;" />

### The Three Variables You Can Actually Control

Here's what I've learned: when you're shaping roadmap items, you need to think in terms of variables you can adjust. You might have additional ones like security, user experience, or performance, but the three core elements I focus on are scope, time, and quality.

The key principle I always stick to: **never cave on quality**. Once you start compromising quality, predictability collapses—bugs, rework, and customer frustration eat away at the time you thought you gained.

<div style="clear: both;"></div>

### The Most Common Mistake I See

The most common mistake I see teams make is creating a situation where **scope is fixed** and **time becomes the only variable** you can adjust. When problems arise, the only escape route is to extend your timeline. Sound familiar?

This trap most easily occurs when we put features on a roadmap. I've seen this happen time and again—features become honey traps for ideas, expectations, and assumptions. When you communicate about features with customers or stakeholders, they start filling in how it will solve their problem. But when reality hits and it doesn't deliver as expected, frustration follows.

Feature roadmaps also shift focus from solving **problems** to creating **features**—a subtle but dangerous distinction. We fall in love with the feature, not the problem. The goal becomes to deliver the feature, not to get a solution in the hands of the customer. And the moment you fall in love with the feature, that's also when scope creep starts.

<img src="/assets/images/2025-10-24-shaping-roadmap-items/feature-creep.jpg" alt="Attack of the Feature Creep by Tom Fishburne" style="max-height: 800px; width: 80% !important; display: block; margin: 20px auto;" />

### But What If We Flipped the Script?

That's where **outcome-based, goal-oriented roadmaps** shine. We start from the problem and work towards a meaningful outcome that addresses it. The word **"outcome"** is crucial here—it focuses on what will change, not just what we'll build.

In my experience, moving from solution to problem is a big leap forward. But moving from problem to outcome is just as important—and it's what separates good roadmaps from great ones.

When we focus on outcomes, we give ourselves the flexibility to adjust scope and time while maintaining quality. We're not locked into specific features—we're committed to solving real problems and delivering meaningful results.

### Exploring Different Approaches to Variable Control

Let's investigate the alternatives to feature-based roadmaps where scope is fixed and time becomes the only escape route.

One approach is to fix time and make scope completely variable. This is what [Shape Up](https://basecamp.com/shapeup) does—they form bets of fixed time periods (typically six weeks) where the scope can vary. What I like about this approach is that the team has full control over scope while working on the bet. And even if they fail to deliver anything, the system prevents them from continuing automatically, since work only continues if a new bet is made.

This creates a powerful mechanism for teams to control their clock. You need deliberate moments to pause and reflect—are you still moving in the right direction, or do you need to course-correct?

![Shape Up betting cycle](/assets/images/2025-10-24-shaping-roadmap-items/shape-up.png)

I take a different approach with my [betting methodology](/2024/10/20/bet-on-your-roadmap/). Instead of fixed time periods, I use variable-sized bets measured in sprints. The idea is to have meaningful discussions about investment—how much are you willing to spend on this outcome? This creates natural checkpoints during development where you can decide whether to adjust scope, extend the timeline, or both. In our setup, teams work in two-week sprints, so using sprint-based bets helps us keep the cadence of Scrum while still bringing in the investment mindset of Shape Up.

No matter which approach you choose—fixed-time bets like Shape Up or variable-size bets like ours—the real leverage comes from how you shape the items themselves, and focusing on reaching a meaningful outcome in a pre-defined timebox.

### Feature vs Outcome — And Why It Changes How Teams Work

But what does this actually look like in practice? Let me show you how the same business need can be approached in two completely different ways.

**Feature**: Build a notification center  
**Outcome**: Important updates reach users at the right moment so they take action in time

At first glance, these might seem equivalent. But the impact on teams is completely different.

When you put the feature on the roadmap, the team focuses on building a notification center. And because that's what's on the roadmap, the pull is to make that thing more complete:

- Should we support multiple notification types?
- What about filtering?
- Do we need grouping, priorities, snoozing?
- Push + email + in-app?
- A full notification history?

Soon, you're collecting feedback about what is missing from the feature—**optimizing the solution, not the result**. It becomes a self-fulfilling prophecy: you asked for a notification center, and you will definitely build a notification center.

When you put the outcome on the roadmap, the team focuses on helping users act in time. The conversations shift:

- Which users actually struggle with missing important updates?
- What updates matter most to them?
- How fast do they need them?
- What do they need to do once they get the update?
- What's the smallest thing we can build to help them today?

You start with a few real customers. You measure whether behavior improves. You solve the core problem first.

And maybe the right solution is a notification center. But it could also be:

- A simple in-context alert while they're already working
- A daily summary delivered when they're most likely to act
- A badge showing only actionable items
- Automated actions that remove the need for notifications entirely

Because you're not committed to building the feature—you're committed to making something *better* happen. You solve problems faster. You avoid unnecessary complexity. You deliver value earlier.

So what happens when you eventually build a feature? When you pursue outcomes, you will eventually zoom in on a feature—because something still needs to be built to solve the problem. The difference is how you get there.

All those "feature questions" are still useful—but they belong in the **divergent part of the work**, where you explore solutions freely. Then you use the focus on the outcome to converge toward the smallest version that actually delivers value.

![Diverge to create choices, converge to make choices](/assets/images/2025-10-24-shaping-roadmap-items/diverge-converge.tiff)

*Source: [Dave Bailey's guide to strategic offsites](https://www.dave-bailey.com/blog/offsites)*

Here's how this works in practice. In the **divergent phase**, you ask all those feature questions without judgment: Should we support multiple notification types? What about filtering? Do we need grouping, priorities, snoozing? Push + email + in-app? A full notification history? You explore every possibility, no matter how complex or ambitious.

In the **convergent phase**, your outcome focus becomes your filter. You take all those possibilities and ask: "Which of these actually helps users act in time?" You start with the smallest thing that could work, measure whether it moves the needle, and only add complexity when you have evidence it's needed. Techniques like **user story mapping** can be very powerful here—they help you build out a broad view of all the possibilities, then slice the work toward concrete outcomes.

{% include carousel.html number="1" %}

*Source: [RHT Labs - User Story Mapping and Value Slicing](https://rht-labs.com/tech-exercise/slides/content/?name=user-story-mapping-and-value-slicing)*

You see the full landscape of what could be built, but then you choose the slice that delivers the most value for your specific outcome.

The magic happens in the transition between these phases. Instead of building everything you can think of, you build the smallest thing that could possibly work to achieve your outcome. Then you measure, learn, and iterate.

That keeps the roadmap focused on **progress, not perfection**.

### What This Means for Your Roadmap

Well-shaped roadmap items share a few consistent characteristics:

- **Start with the problem**: What are you really trying to solve?
- **Define the outcome**: What will change when you're successful?
- **Leave room for creativity**: Don't lock yourself into specific features too early
- **Control your clock**: Make sure you have a mechanism in place to stop, pause, and reflect on whether you're still moving in the right direction
- **Keep the focus on outcomes**: Use outcomes as your filter for all decisions, not features
- **Build in margin**: Plan for the inevitable changes that will come

The result? A roadmap that's both *predictable* and *flexible*—exactly what you need to deliver value consistently, even as things change.
