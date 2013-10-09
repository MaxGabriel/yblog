---
kind:           article
published:      2013-10-10
image: /Scratch/img/blog/Useful-Haskell/main.png
title: Useful Haskell
author: Yann Esposito
authoruri: yannesposito.com
tags: programming
theme: scientific
---
blogimage("main.png","Main image")

<div class="intro">


%tlal Apprendre Haskell était vraiment horrible pour moi.
Voici une liste de choses que j'aurai adoré avoir pour débuter.

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


## I learn Haskell in 5 minutes

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


Lists:

    []      ⇒ empty list
    [1,2,3] ⇔ 1:2:3:[] ⇔ 1:[2,3]
    [1..]   ⇒ 1:2:3:... infinite list (YES)

Function declaration:

     fact x = if x<2 then 1 else x * fact (x-1)

Which could be invoked like this:

     >>> fact 32
     263130836933693530167218012160000000

There is no "fact(32)" but "fact 32".
This is a very important syntax design.

The computation is all about reduction rules.

    fact 3
    let x = 3 in if x<2 then 1 else x * fact (x-1)
    3 * fact (3-1)
    3 * (let x = 3-1 in if x<2 then 1 else x * fact (x-1))
    3 * (if 2<1 then 1 else 2 * fact (2-1))
    3 * (2*(let x = 2-1 in if x<2 then 1 else x * fact (x-1)))
    3 * (2*(if 1<2 then 1 else x*fact(x-1)))
    3 * (2*1)
    3 * 2
    6

Many things are to note.
First the reduction was non-strict.
The evaluation is lazy.
For example:

    fact (3-1)

    -- reduced to
    (let x = 3-1 in if x<2 then 1 else x*fact (x-1))

    {-hi-}-- did not reduced to{-/hi-}
    fact 2

Explication with the AST (Abstract Syntax Tree)

> **Lazy evaluation**  
> Start reduction by the higher non evaluated node.
> 
> blogimage("AST-lazy.png","AST")
> 
> reduces to
> 
> blogimage("AST-lazy-reduced.png","AST reduced non strictly")


> **Strict**  
> Start reduction ky the deepest non fully evaluated node.
> 
> blogimage("AST-strict.png","AST")
> 
> reduces to
> 
> blogimage("AST-strict-reduced.png","AST reduced strictly")

Lazy evaluation make it easier not to reach ⊥ (I mean infinite loop).

Typically `head [1..1000000000]` returns `1` almost instantaneously in Haskell.
While if strictly evaluated would take a _lot_ of memory and time.
Also we could do `head [1..]` and it returns `1`.


So in Haskell you define functions and they are reduced to produce computation.
There are a _lot_ of syntactical sugar in Haskell to help you write less code.
But in the end, it will be translated that way.

That was the functions part. But there is the other at least as important part.
The types.

### Types

In Haskell, types are extremely important. And also hard to figure out.

    >>> :t fact
    fact :: (Num a, Ord a) => a -> a

The heck does this mean? Before the `=>`, it means that the type `a`
belongs to the _type classes_ `Num` and `Ord`.
The `a -> a` part means `fact` is a function from `a` to `a`.

Every types in the type class `Ord` could be used with `(<)`.
And Every types in the type class `Num` could be used with `(*)` and `(-)`.

The type classes are a kind of interface declaration for types.
For example there is an _instance_ of `Num` for `Int`, `Integer`, `Float`...
