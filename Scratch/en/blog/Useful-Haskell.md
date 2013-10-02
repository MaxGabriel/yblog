---
kind:           article
published:      2013-09-30
image: /Scratch/img/blog/Useful-Haskell/main.png
title: Useful Haskell
author: Yann Esposito
authoruri: yannesposito.com
tags: programming
theme: scientific
---
blogimage("main.png","Main image")

<div class="intro">

%tldr


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

☞ Just a warning. Haskell is full of syntactical sugar.
In order to talk only about principle I removed most of them.
Be assured most of the syntax horror you will encounter in this section
could be done using a far nicer syntax.

### Definitions

Assign a value to some symbol.
Each value has some type.

    b = True
    c = 'a'

Associated to each expression/symbol there is a type.
The `::` means "is of type".

    True :: Bool
    'a'  :: Char

So what is precisely a type in Haskell?
The simplest type in Haskell can be created that way.

    data Null = NullConstr
    x = NullConstr :: Null

On the first line I declared a data type.
On the second line I instanced a variable to a value of the type.
There are the following basic type you can use:

    Bool, Char, Int, Float, Double, Integer

And you can compose them to create more complex types.

    data Str = StrConstr [Char]
    hello = StrConstr ['H','e','l','l','o'] :: Str

    data CharOrInt = C Char | I Int
    letter_x = C 'x'    :: CharOrInt
    integer_5 = I '5'   :: CharOrInt


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

