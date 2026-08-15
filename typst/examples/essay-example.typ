// Example document for the ESSAY style.
//
// Real content: three chapters of Life Itself's "What is the Second
// Renaissance?" essay, lightly abridged, with the editorial devices used
// as they are meant to be used. The standfirsts are the essay's own
// bolded claim paragraphs; the pull quotes are sentences lifted verbatim
// from the prose beside them. Choosing *which* sentence to lift is an
// editorial judgement, not a template one — which is why a template that
// only offers the device is not finished.

#import "../lib/styles/essay.typ": (
  blockquote, dfn, fig, figrow, opening, palette, pullquote, report, standfirst,
)

#show: report.with(
  title: "The Second Renaissance",
  subtitle: "A time of civilizational crisis and awakening",
  authors: "Sylvie Barbier, Rosie Bell and Rufus Pollock",
  date: "Draft v1.0-r1, published May 2024",
  epigraph: [
    "Two young fish are swimming along and they meet an older fish swimming
    the other way. The older fish nods at them and says 'Morning, boys.
    How's the water?' The two young fish swim on for a while. Then one of
    them looks over at the other and goes 'What the hell is water?'"

    #h(1fr) — David Foster Wallace
  ],
  colophon: [
    Set in the #emph[Essay] style — Fraunces over Literata, 120mm measure,
    mirrored margins. Specified in `docs/styles/essay.md`. This excerpt
    reproduces three chapters of the essay for typesetting purposes.
  ],
)

= Introduction

#standfirst[
  The Second Renaissance is both a period and a movement: a "time between
  worlds", and a growing movement of people working to build shared
  understanding towards a radically wiser future.
]

#opening[From the climate crisis to populism, from rising inequality to AI risk, visible and growing cracks are appearing in planetary civilization. Accurate diagnosis is vital if we are not only to address the symptoms but heal, transform and transcend our interconnected crises. The stakes are high — never before has human civilization risked collapse on a global scale.]

Here we will suggest that these growing cracks go to the foundations of our
societies: to the way we see ourselves, each other and the world. At the
very root of the challenges we face is a dying cultural paradigm:
Modernity. The modern era was itself a period of extraordinary human
achievement and advance, initiated by a cultural Renaissance or rebirth.
However like any paradigm, Modernity casts a long shadow, and ultimately
contained the seeds of its own decline.

#pullquote[
  Whatever its gifts, today Modernity is exhausted. We find ourselves
  unable to address our current crises through the Modern logic and value
  systems that created them.
]

We need profound shifts in our ways of being, thinking, feeling and
acting: a Second Renaissance. And we need proactive people willing to
dedicate themselves to imagining collectively what this might look like.
By becoming aware of where we are standing within the long view of history
and examining how we got here, we can begin to imagine where we might go
next, and how we might avoid repeating the same mistakes.

Here we will introduce a provisional model for understanding cultural
evolution at a foundational level, and a set of tools for navigating our
cultural landscape — and exploring new territory. We will propose that a
wholesome transition must prioritize the human inner world as well as the
outer structures of society. And we will suggest that creating pragmatic
ways to embody and enact new ideas in our lives together is every bit as
important as the ideas themselves.#footnote[This essay refers broadly to
"we" and to "our world", without intending to reduce the plurality of human
experience to any single or simple thing. Similarly we discuss globally
dominant structures of thought that coalesced at a particular time in
Europe, without implying that they are absolute or consented to by all.]

== On the word "renaissance"

We have adopted the imperfect term "Second Renaissance" in the
understanding that no one term will universally feel appropriate, or do
justice to the variety of transformation taking place. In particular, we
recognize the eurocentric nature of the term — and encourage readers, if
they wish, to substitute a term more relevant to their own cultural
context.

At the same time, the term has certain useful resonances. The current
dominant cultural paradigm of modernity was born in the first renaissance
in Europe, though we emphasize that this next transition will have many
roots all over the world. In addition, the basic meaning of the term —
rebirth — seems appropriate to this "time between worlds", and offers a
framing of possibility whilst also implicitly acknowledging the risks of
breakdown and collapse. Birth and death are profoundly intertwined.

= Modern Civilization: Cracks in the Walls

#standfirst[
  If our solutions are failing, it is worth interrogating whether we are
  misdiagnosing the problems.
]

#opening[From poverty and spiraling inequality to ecological breakdown, rising authoritarianism and social fragmentation, globalized modern civilisation faces major threats. For the good of all life, we urgently require meaningful solutions. But we have known this for a while, and thus far our interventions are not working very well.]

Let's start with a metaphor. You've lived in your house for a number of
years and everything about it has seemed more or less fine. A few years ago
you had to do some damp-proofing, perhaps. And there was that time a bunch
of tiles slid off the roof — but nothing serious. Recently however, you've
started noticing cracks appearing in some of the walls. You're no slacker,
and you already plastered over them, but rather alarmingly they just came
back — and they're getting bigger. Now the upstairs doors won't close
properly and yesterday a little bit of ceiling-plaster fell into the bath.

Are these co-occurring breakdowns a coincidence? Do you just carry on with
the Polyfilla? Or is it time to start asking whether there's a common
source problem coming from somewhere deeper — most likely the foundations?

#fig(
  "/typst/assets/modernity-in-decline-cracks-diagram.png",
  caption: [The visible crises are not independent. Read as symptoms of a
  common foundational problem, they stop looking like a list and start
  looking like a diagnosis.],
  source: [Life Itself],
  width: 88%,
)

We don't #emph[want] our problems to be foundational. Going so deep, with
so much complicated stuff layered on top of them, they're hard to access.
To fix them properly, large parts of our house might need to be rebuilt
entirely. We may even need to pack up and move.

#pullquote[
  It's tempting to keep plastering over each crack as best we can. But
  those symptoms will keep showing up, and getting worse.
]

If our foundations are flawed, our only real option is to deal with the
root of the problems — to start in the basement. The alternative is to keep
fixing the wrong problems as our house collapses around us: gradually, then
perhaps all at once.

= What Are the Foundations of Civilization?

#standfirst[
  Among the most fundamental aspects of a built structure are the core
  ideas that guided its construction, and that continue to motivate the
  people who maintain it.
]

#opening[If we're in agreement, then it might be time to examine the foundations of civilization. But where are they, exactly? Like most metaphors, our house is imperfect and radically oversimplified — if human civilization were bricks and mortar we wouldn't be struggling so hard to fix it.]

Complex interdependencies entail that no aspect of a system is
foundational in any simple sense. However we might argue that among the
most fundamental aspects of a built structure are the core #emph[ideas]
that guided its construction. Terminology varies — but whether we talk
about worldviews, cultural paradigms, belief systems, or similar, we're
essentially pointing to the deep structures of views and values that
underpin individual choices and societal norms.

#dfn[Views][core frameworks of assumptions about the nature of reality: what
the world is, how it works, and humanity's place within it.]

#dfn[Values][core beliefs about what #emph[matters]: what is good,
meaningful and desirable.]

Views and values are mutually implicit, and always operating within human
choice and behaviour at individual and societal levels.

== Why they are hard to shift

A number of characteristics suggest views and values as foundational in
civilization. Importantly, these structures of thought tend to be more
resistant to change than technological and institutional structures. Over
time a feedback mechanism emerges: we co-create structures and institutions
that formalise certain views, and in channelling societal life through
those structures we entrench the values they embody.

The intransigence of views and values arises in part from their close
relationship with personal and group identity. Because core beliefs about
what's right or real are typically experienced as indistinguishable from
"who I am", challenges to views can be received as a personal or cultural
attack — attracting strong resistance and redoubled attachment to existing
beliefs.

#blockquote(attribution: [David Foster Wallace, after a Chinese proverb])[
  Two young fish are swimming along and they meet an older fish swimming
  the other way. The older fish nods at them and says "Morning, boys. How's
  the water?" The two young fish swim on for a while. Then one of them
  looks over at the other and goes "What the hell is water?"
]

Like the fish, unaware of the water it's swimming in, we perceive reality
without awareness of the mental models that deliver it to our perception —
and particular views and values are often most visible to those living
outside them in some way. As well as speaking to their foundational nature,
this invisibility reinforces the difficulty we may have in shifting views
and values, and our related tendency to neglect their importance when
diagnosing societal challenges.

#figrow(
  (
    ("/typst/assets/cimabue-pre-perspective.png", [Cimabue, before linear perspective: space is symbolic, not measured.]),
    ("/typst/assets/perugino-linear-perspective.png", [Perugino: one vanishing point, one correct place to stand.]),
    ("/typst/assets/picasso-plural-perspective.png", [Picasso: several viewpoints held at once, none privileged.]),
  ),
  caption: [Three ways of rendering space, six centuries apart. The
  paradigm is not what is depicted but what counts as depicting
  correctly — which is exactly the kind of assumption that is invisible
  from inside it.],
)
