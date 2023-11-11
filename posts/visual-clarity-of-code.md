title: Visual clarity of code
summary: The importance of visual processing to code readability
date: 2022-12-13 12:00
tags: thought
---

> # inline info 
> ## Disclaimer 
> 
> This post is old and in need of a rewrite. Yet another box on my to-do list
> that I will _definitely_ get to.

When discussing how easy a programming language is to read or write, we
primarily think about functionality; what abstractions does the language provide
to make programming easier? What's not often mentioned explicitly—even if we
recognize it instinctually—is the visual clarity of the language.

Take the following snippets:

```python
def mult_by_2(arr):
  return map(lambda x: x * 2, arr)
```

```python
def mult_by_2(arr):
return [x * 2 for x in arr]
```

You probably found the second snippet more readable. We're operating at the same
level of abstraction: these two snippets map one-to-one. However, the list
comprehension syntax makes it visually clear that we're mapping elements of a
list, and presents the information in a more natural reading order. We've gained
type information and readability through a bit of syntax sugar.

Let's look at a more extreme example:

```scheme
(integrate x a b
  (/
    (exp (- (/ (^ x 2) 2)))
    (sqrt (* 2 pi))))
```

```latex
\int_a^b \frac{e^{-x^2/2}}{\sqrt{2\pi}}
```

Fundamentally, these two snippets represent the same operation at the same
level of abstraction. Yet the mathematical notation visually communicates that:
1. We're doing math
2. We're performing an integral from a to b
3. We have a fraction with an exponential term over a constant
4. This is an integral over the normal distribution

Teasing this information out of the Lisp program takes a lot more effort.

Except, well, _I lied_. At least a little bit. Sure, you can technically grasp
all that information quicker from the mathematical notation, but you could also
be unfamiliar with something like integration and be left without even a
function name to look up.

## Climbing the curve
The Lisp snippet has a much lower barrier to entry. As long as you know Lisp
syntax (which is famously simple enough to fit on a business card), you can see
what function is applied to what variables/numbers. And if you're lost as to
what `integrate` or `exp` do, you can look it up pretty easily. 

On the other hand, getting a complete picture of the equation in Lisp is
difficult. If you can read the mathematical equation, you probably find that
syntax much easier to comprehend.

Every piece of syntax represents a chance to add a visually distinct operation,
but also increases the learning curve—especially for reading code.

This is (in my opinion) one reason why many find Lisp and APL difficult to
use despite them being such powerful languages. In Lisp, everything has exactly
one visual form, rendering visual processing of the code very difficult. APL's
symbols make it easier to scan for operations, but because it's almost entirely
non-textual and doesn't use other visual demarcations like whitespace, a
massive amount of memorization is necessary.

> # caption
> ```
> life ← {⊃1 ⍵ ∨.∧ 3 4 = +/ +⌿ ¯1 0 1 ∘.⊖ ¯1 0 1 ⌽¨ ⊂⍵}
> ```
>
> An [APL implementation](https://aplwiki.com/wiki/Conway%27s_Game_of_Life")
> of Conway's game of life. Impressive stuff—for the people who understand it.

Figuring out how to create programs that are both visual and readable is
important. Math and engineering rely heavily on symbols and visualizations for a
reason; the human brain is an incredibly efficient visual processor, which we neglect
when we adopt a single syntax for every problem domain. In general purpose
languages, all code devolves into a series of functions and control statements,
regardless of the code's meaning.

Imagine if there was an easily recognizable syntax for accessing a database,
or logging a block of code. Every hint we give to our pattern recognition system
makes understanding code easier, and we should take advantage of it.

So let's take a look at the practical challenges of visual programming
representation and how we might approach them.

## Dealing with the domain
It's not very hard/impossible to have the necessary visual patterns in a
general purpose language out of the box. Common patterns vary between domain,
specific application, and even subapplications. Users need to be able to create
their own syntax to express their architecture.

Lisp does the functionality part of this pretty well, but due to its limited
syntax misses out on visual clarity. Other languages do some form of this, but
I've not found a language that's truly flexible in terms of program syntax yet.

But there's good reason even macro-focused languages don't venture here.
Even ignoring techinical challenges like parsing, how would we make such a
language readable to people outside the domain? Due to the wide applicability of
programming, programmers shift between domains more often than in many other
knowledge fields; if it takes a week to learn the application syntax, we can
basically kiss open-source contributions goodbye. We need another solution.

## Multiple representations
Putting a layer of indirection between the canonical program representation and
what the user sees is not unheard of; it's what every
[WYSIWYG](https://en.wikipedia.org/wiki/WYSIWYG) editor does. In programming,
projects like [Enso](https://enso.org/), [Smalltalk](https://squeak.org/), or
even syntax highlighting act as middlemen between the literal program file and
what shows up on the screen. Using indirection, we can modify what people see to
align with their experience level. A symbolic language like APL could show
textual versions of it's operations, or a textual data science language could
show a boxes-and-lines style visual representation.

This is similar in spirit to the gradual programming model of
[Hedy](https://hedy-beta.herokuapp.com/). The needs of beginners and experts are
different, and switching program representations should accomodate that.

## Language support
The previous section hints about how we would get this to actually work. Even
with custom syntax, there's a canonical AST that can be used by tooling. There's
even prior work here; [Tree-sitter](https://tree-sitter.github.io/tree-sitter/)
provides language-independent syntax higlighting, and
[Tree-edit](https://github.com/ethan-leba/tree-edit) provides structural editing
on top of that AST.

## So what?
Ok, say you're not convinced that we need better visualizations of code.
What does all this work get us?

As is often the case when indirection is introduced, a whole lot.

Bidirectional representations for editing source code are fairly limited, since
you have to maintain complete information over the transformation. But what if
you allowed one-way transformations? You probably don't care what AST your
programming language uses under the hood, so what if they just used the same
one?

Everytime we start a new language, we start at almost a blank slate. Debugging,
editing, profiling, introspection, toolkits, package management; every language
rebuilds these ideas all over again. Hell, nowadays these tend to be the killer
features of new languages. We should be able to focus on the language syntax and
features—the _representation_ of the language—separately from the tooling.

Having this separation makes it much easier to develop small, easy to reason
about DSLs instead of hammering everything into general purpose languages.

We already have this functionality in highly programmable languages like Lisps.
It's how we can get powerful features like pattern matching without compiler
support. All we're missing is the ability to visualize our new constructs in
readable ways.

## Wrapping up
Hopefully this post gave you some new insights. This space is massive, and
there's probably a lot of research material out there I'm not aware of. I've
included some further reading below; if there's something cool I'm missing let
me know and I'll add it in!

## Further reading
- [Stop writing dead programs](https://jackrusher.com/strange-loop-2022/): A wonderful
  talk by Jack Rusher that goes into syntax and visual program representation,
  among other topics.
- [Is it really "Complex"? Or did we just make it
  "Complicated"?](https://www.youtube.com/watch?v=ubaX1Smg6pY): A famous talk by
  Alan Kay about using smarter, smaller languages.
- [Enso](https://enso.org/): A data science language with a
  boxes-and-lines representation.
- [Subtext](https://www.subtext-lang.org/): A "programming by example"
  language with a custom editing UI.
