---
title: "Narrow Escape Visualization"
date: 2021-10-28T13:45:50+01:00
draft: False
comments: false
images:
---

The [Narrow Escape Problem](https://en.wikipedia.org/wiki/Narrow_escape_problem "NEP") is a bio physics problem which attempts to estimate how long it takes for a particle moving under Brownian motion to escape from a container with solid walls, where part of the wall is open.

Recently [we published a software library](https://joss.theoj.org/papers/10.21105/joss.02072) for building narrow escape simulations. We also used this to discuss its use in determining the [escape time for small molecules from plant cells](https://ieeexplore.ieee.org/document/9440948). 

I've recently been working with [plotly](https://plotly.com) to create interactive plots. With plotly I put together a little example of our simulation software which, I think, nicely explains the concept.

Below you can see our container cell in silvery-gray, a blue dot represents the part of the container which is free to escape through. By moving the slider you can see the random-walk path that the particle takes until it finally reaches the blue escape point.

(I also wrote this as I wanted an excuse to test out my new blog and how it handles these plotly graphs!)

{{< rawhtml >}}
    <iframe src="/subfiles/NEP.html" style="height: 700px; width: 100%;"></iframe>
{{< /rawhtml >}}
