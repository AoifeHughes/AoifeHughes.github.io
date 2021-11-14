---
title: "Computational Modelling with Apple Silicon"
date: 2021-11-14T15:15:29Z
draft: False
toc: false
images:
tags: 
  - Modelling
---

Ever since Apple Silicon was announced I was enthralled and curious. Even as reviews and benchmarks came pouring in after the original M1 Macbook Pro, Mini and Air released I was skeptical. Working in research we often find that tools we depend on are ancient by computer standards, even worse is that some of them are either difficult to build/update or are closed source (or worse still, written in PERL!).
Which highlights my major fear of Apple's new direction, I was initially terrified that almost all of my pipelines and tools would die in x86 and I would be forced to migrate to, ugh, Windows. This fear quickly subsided when a colleague in my office picked up a M1 Macbook and told me how easy it was for them to setup for data analysis/research. I then had the opportunity to test my curiosity about these new machines, I asked this friend of mine if he would run one of my example computational models. I was completely floored by the results of this request. 

The results alone (which I'll go into after describing the models and the tests) were enough for me to request from my supervisor that I get an upgrade to a M1 myself. 

## The Models 

I describe some examples of what I currently spend most of my time modelling in a previous [blog-post]({{< ref "/posts/narrow-escape" >}} "Narrow Escapes").

Basically, I use random walk models to establish transport times for molecules in and out of plant cells. 

These models aren't too hard to run, maybe 10 seconds computation time per one on an iMac Intel 27inch (for reference). The difficulty comes in the repetition of them. We need to run a few thousand simulations and average across them in order to get an accurate result. 

## Tests 

Using our Narrow Escape Simulator package ([https://github.com/AoifeHughes/NarrowEscapeSimulator](https://github.com/AoifeHughes/NarrowEscapeSimulator)) we ran 5 x repeats of 1000 simulations on a 2018 Intel i5 iMac 3.5Ghz and a MacBook M1 Pro.

## Results 

These results pretty much speak for themselves and need little elaboration:

![Results](/images/m1_tests.png)

To put a number to it, the M1 Pro is about 364% faster at calculating the narrow escape models than the Intel iMac.

## Why is this important to me?

Saving about 13 minutes might not seem like a big deal, but I run hundreds of these experiments with many configurations. Every variable change requires them to be re-run. Previously I relied heavily on high-performance computing to handle the volume of models I run, now I suspect I can do all of it locally, on a laptop no less.