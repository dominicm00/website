title: Technology sucks. Why?
summary: Exploring the psychological, sociological, and technical reasons for the failure of technology
slug: why-does-technology-suck
date: 2024-3-4 14:27
tags: thought
---

I live and breath technology. I program for work and for fun. I play games,
watch shows, and spend time with friends all on my computer. Technology is an
incredible innovation that has unlocked a range of new activities and
possibilities, quickly becoming something we rely on every day.

It's also a piece of f\*\*\*ing shit.

## Part one: I'm not being melodramatic, I swear
I am admittedly a bit biased due to my intimate connection to technology, but I
think the tech industry is failing in ways not seen in other industries. I
encounter significant bugs in major pieces of software like Google Maps,
Android, or Windows on a daily basis. Many large tech companies are debugging
and patching multiple user-facing issues per-day. Software is regularly
abandoned or completely rewritten due to tech debt. Upgrades seem to make things
slower and less usable rather than the opposite.

I am not focusing on your average small-business website made by the lowest
bidder. Those are admittedly bad, and I think there's ways we can improve them,
but low quality in projects like that is common across industries. I'm talking
about companies with thousands of crazy smart, talented, full-time engineers who
are struggling to make something good.

Why are we stuck with a few pieces of good software and a frustratingly bad
majority? The industry is certainly paying enough to attract necessary talent.
It's not like software companies are uniquely bad at making things either; the
worst part of pretty much any modern car is generally the infotainment system!
It seems to just be software itself that's the issue. Why?


## Part two: What went wrong?
> # inline info
> ## Disclaimer
> Everything here is my personal opinion, with no real research backing it up.
> Take this with the appropriate dose of salt.

### Software is abstract
Unlike in mechanical engineering where the product is a physical object,
software is abstract. I believe this is actually a major barrier to creating
software at scale.

Humans have evolved to be masters of visual pattern recognition, and the
physicality of mechanical engineering provides a source of truth for what you're
creating. Where is each part? What parts are interacting? Where are likely
failure points? How does the system work at a high level? It's orders of
magnitude quicker to get this information from a 3d model of a part versus
carefully reading a codebase.

This abstractness makes code much more opaque. We use abstractions to solidify
this opacity in logical places, but in a company setting it's very easy to
create poor, undocumented, or incorrect abstractions. Fundamentally, software
engineers are operating with less information and a poorer understanding of
their work.

Complex, abstract work isn't limited to software engineering. I think a lot of
similarity can be drawn between a mathematical paper and a piece of software.
Both have "hard" bugs, where an oversight leads to a result that's just plain
wrong. Both are abstract, and take a significant amount of time to audit and
understand. Where software engineering becomes unique is in its scale, both in
the amount of code and the number of people working on it at once.

### Software is relatively unconstrained
There's a ton of constraints when building physical objects. Every new part
costs money up front and per-unit, so there's a very strong incentive to
minimize complexity and use pre-existing parts. And of course, the design itself
is limited by reality; you can't just build a stove that floats or have your
fridge magically cool your bathroom.

By comparison, software has much fewer constraints, both from a technical and
economical perspective. The cost of a programmer is so enormous compared to any
running costs of the software itself that extra complexity and inefficiencies
are easy to justify. Technically, any part of a piece of software can interact
with any other piece.

This freedom is one of the strengths of software! It's how we can iterate
quickly, and have such creativity. But it also means that, left to grow
organically, software becomes overly complex and interconnected. In tandem with
its abstract nature, large pieces of software are fragile and
difficult to understand.

### Best practices aren't enough
In a perfect world, we have best practices and architectures to deal with the
above issues. With enough work and thought, we can create clean and maintainable
software.

The world is, suprise, rarely perfect.

Discipline does not beat incentives. Engineers with the best of intentions will
make mistakes, and over time as best practices become more difficult to maintain
discipline will erode. Even if each individual change is well-designed, their
sum will eventually corrode the quality of the code. As the system becomes more
complex, the understanding needed to develop an intelligent architecture also
becomes harder to obtain.

Putting effort into developing a better piece of software is important, but our
systems are not supporting it at scale.

### Mistakes are cheap (until they aren't)
Mistakes in software are among the cheapest to fix. You don't have to do a
product recall or change manufacturing; you just push out an update. As a
result, you don't generally need to take as much care when developing software.
A fix is always a rollback away.

That is, *if* the mistake is a bug.

A bug is relatively obvious; the program is not doing what it's supposed to. But
we make other mistakes too. We may architect a program incorrectly, not
anticipate a future use case, or simply make tradeoffs that were reasonable at
the time but cause issues later down the road.

These mistakes usually don't rear their head for years or decades, and once they
do they are extremely hard to remove. It's why Windows is still compatible with
DOS, why memory safety vulnerabilities are so prevalent, and why the mainstream
way to create a cross-platform application is to embed it in its own
mini-operating system (read: a web browser).

Software builds on software in a way that's extremely costly to change, possibly
even more than in manufacturing. This is a dire enough problem on its own, but
combined with the apparent cheapness of fixing software, we are lulled into a
false sense of complacency with lackadaisical software development. Costly
mistakes are introduced at a rate that's not feasible to deal with continuously,
and so the demon of tech debt begins to rear its head.

### We live in a society
And finally, sometimes building good software just isn't the goal. Almost all
software we use is commercial, and the end goal is to extract value. If a
crappier product makes more money, then the crappier product *will* win in a
commercial setting. Software also has powerful monopolistic properties that
means it can be cheaper to just force people to keep using your product rather
than fixing it.

This topic deserves its own blog post, but needless to say, if making really
good software is hard (and it is), companies will find ways to make money from
software without focusing on quality.


## Part three: So what do we do?
¯\\\_(ツ)\_/¯

In all seriousness, this post is mostly just a rant. I believe we can fix these
issues, and I'm actively developing tools that I think will get us part of the
way there. But we need, as an industry, to focus more on the fundamental aspects
of coding than the next new shiny.
