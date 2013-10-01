---
kind:           article
published:      2013-09-30
image: /Scratch/img/blog/Useful-Haskell/main.png
en: title: Useful Haskell
fr: title: Useful Haskell
author: Yann Esposito
authoruri: yannesposito.com
tags: programming
theme: scientific
---
blogimage("main.png","Main image")

<div class="intro">

en: %tldr

fr: %tlal

</div>

To put Haskell programming to the next level.

1. Finding the minimal syntax core you need to learn Haskell

    a. Basic syntax
    b. Types

2. Basic Usages (verbose documentation)

    a. compare haddock doc to markdown
    b. basic project with cabal (cabal haddock)

3. Types to the core, the hidden secret

    a. bad prelude!


1.a. Minimal syntax

Mathematical expression: as usual, just take care of difference between
Integers and Float (div and (/) ) are different.

Function declaration:

    f x = x^2 + 1

basic keywords:

    f x = if x < 0 then -x else x

    g x = case x of
            0 -> "zero"
            1 -> "one"
            otherwise -> "many"

    no for!
    To replace for you have to chose the _right_ for.

    -- imperative: modify a table element by element
    -- for i = 1 to 10; t[i] = 2*t[i]
    map (2*) t

    -- imperative: accumulation
    -- for (x=0; x<length(t); x++) { sum += x }
    foldl' (+) 0 t

    -- imperative: many times the same thing
    -- for (x=0;x<10;x++) { something }
    repeat 10 something

    -- use the tab indice
    map f (zip t [0..])

