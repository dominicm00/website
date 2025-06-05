title: Going beyond the REPL
summary: Improving the UX of interactive programming
date: 2023-11-11 12:05
tags: thought
---

> # inline info
>
> ## Disclaimer
>
> This post is currently rambles a bit. I'll try and make it more concise.

REPL-driven development has
[long](https://mikelevins.github.io/posts/2020-12-18-repl-driven/)
[been](https://web.archive.org/web/20110112075449/http://programming-musings.org/2006/01/14/the-joy-of-repl)
[lauded](http://blog.jayfields.com/2014/01/repl-driven-development.html) by Lisp
programmers, but has failed to go mainstream. Can we find a better approach to
interactive development?

## The problems with REPLs

### Separation of the REPL and code

REPL-driven development generally involves testing expressions in a REPL, and
then transferring them to code when completed. The state of your REPL and code
are completely disconnected. Some common issues here are:

- Changing a function in code and forgetting to change it in the REPL
- Using a variable with different values in the code vs the REPL
- Using a function or variable that no longer exists in the code
- Needing to emulate the state of the program at the point an expression is run

### Ephemeral knowledge

Exploratory development via a REPL can be incredibly empowering. Rather than
guessing-and-checking via print statements, you can interactively test any
expression.

But once you've finished your coding session, what happens? You've built
knowledge on how all the expressions in your function operate, and after closing
your REPL window…it all disappears. We just throw it away.

By giving the developer powerful introspection abilities but not the reader,
REPLs create a rift in understanding. Questions that are trivially answered in
the developer's state of mind are lost to the reader because they don't have the
same context. Code written without a REPL is clearer to the reader by necessity,
because the information the developer and reader are working are more similar.

## What about debuggers?

Debuggers are great, but they don't replace REPLs. Testing an arbitrary
expression requires writing it, re-running the entire program to a breakpoint,
and then inspecting the value. This is too slow for REPL-driven development; we
need to incrementally update the program state.

## What about computational notebooks?

[Computational notebooks](https://en.wikipedia.org/wiki/Notebook_interface) have
gained mainstream support, primarily due to their REPL-like structure.
Unfortunately, they are generally single-file programs meant to run
interactively, and are too narrow in scope for a general programming technique.
Computational notebooks do, however, hint at the direction we need to go.

## The idea

Regardless of what language you're in, there's always _some_ way to inspect an
expression. The problem is not can we test an expression, but how fast we can do
so. REPLs test small expressions quickly, but introduce a friction boundary
between the REPL and code. Can we test small changes directly in the code,
rather than in a REPL?

```haskell
f x = out
  where
    a = op1 x
    b = op2 a
    out = some_complex_function b

-- We need to know what b is first!
-- Copying all the previous expressions is tedious
>> a = op1 "my input"
>> b = op2 a
>> some_complex_function d
"my answer"
```

Technologically, this is not an interesting idea; debuggers already do this. The
point is developing a UX that encourages a healthier developer workflow.

How many times have you written an entire function, file, or more before ever
running any code? How often were you unsure if an expression was correct, but
delayed testing it until the function was complete? The harder it is to inspect
and test code, the longer we will wait until testing it.

We need to put the value of an expression right in your face, as soon as you
write it. **Let's evaluate our code continuously, and show the values of
expressions as soon as you type them**.

As a developer, this makes the feedback between writing and testing code
instant. There's no explicit action to take to start a test, and so no incentive
to wait to test. If an expression is incorrect on the given test case, the
developer will see that immediately after writing it.

As a reader, this is a powerful tool for exploring an unfamiliar codebase.
Learning by example is a powerful tool, and seeing concrete instances of any
value lets readers think less abstractly about code.

### Hijacking unit tests

![An example function with the values of all intermediate expressions shown on screen based on a unit test](/assets/images/going-beyond-the-repl/live-expression-example.png)

We can use unit tests to run our desired function. Not only does give the reader
documented examples to introspect, but it also encourages developing unit tests
in parallel with function development.

### Loops & recursion

If our function has recursion (or loops which can be expressed as recursion), an
expression can be run multiple times in a single call. How do we let the user
explore all different usages?

As long as our arguments are immutable, storing the arguments to all calls of a
function is generally not significantly expensive. Then the user can selectively
introspect a specific call, or see the value of an expression/return value
across a series of calls.

```haskell
factorial 0 = 2 -- Uh oh, this should be 1!
factorial x = x * factorial (x - 1)

-- Seeing the return values across the call stack
-- makes finding the bug easy
>> factorial 3
factorial 3 -- 12
factorial 2 -- 4
factorial 1 -- 2
factorial 0 -- 2
```

In pathological cases where complete storage is too expensive, we can still:

1. Explore a single branch of recursion rather than the entire tree, which is
   guaranteed to be as cheap as the function call
2. If the input range of the expression is small, wrap it in an anonymous
   function and observe all the times it is called

### Retrofitting existing languages

We can inefficiently implement this in any functional language with a REPL via
code transformation. Adding wrappers around the tested function and expressions
makes it easy to track their values and arguments.

```haskell
factorial x = x * factorial (x - 1)
=> factorial x = memoize
		(Memo {args=[x], value=x * factorial (x - 1)})
```

But this requires re-running the entire function on change! A key feature of
REPLs and computational notebooks is running an expensive expression once, and
then re-using it. Can we do this automatically?

### Taking advantage of purely functional code

If we know parts of our code are purely functional, then yes! Let's look at a
simplified model of function design to see why.

Say a function is a series of assignments, that eventually returns an expression:

```haskell
format_matrix matrix = -- some expensive computation

make_csv headers matrix = csv_output
  where
    formatted_matrix = format_matrix matrix
    csv_lines = map (join ",") (headers : formatted_matrix)
    csv_output = join "\n" csv_lines
```

Now we want to change the file to be tab delimited:

```haskell
format_matrix matrix = -- some expensive computation

make_csv headers matrix = csv_output
  where
    formatted_matrix = format_matrix matrix
    csv_lines = map (join "\t") (headers : formatted_matrix)
    csv_output = join "\n" csv_lines
```

We know that `format_matrix` has no side effects, so we can skip it and just
re-run the `csv_lines` and `csv_output` expressions. Or, inversely, we know we
only have to re-run `csv_lines` and the things that depend on it.

If we develop a function top-down, we'll generally only have to re-run the last
expression. This is potentially much more efficient than running a test case
from scratch.

## Parting thoughts

For decades, our solution to fundamental challenges with programming has been
"make a new language". This is important, but I think we have neglected
innovating how we _interface_ with code. Going beyond the REPL is just one step
in improving our programming methodologies.
