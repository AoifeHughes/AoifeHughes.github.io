# Aoife Hughes — personal website

Static site for [AoifeHughes.github.io](https://aoifehughes.github.io), built
with [Hugo](https://gohugo.io) and the
[Terminal](https://github.com/panr/hugo-theme-terminal) theme (v4.2.6, MIT),
vendored classically under `themes/terminal/`.

## Layout

- `content/english/` — sections: `about/`, `contact/`, `teaching/`
  (`teaching/slides/` is the deck hub, type `teaching-slides`), `research/`,
  `pages/` (privacy policy via permalinks)
- `config.toml` — single-file site config (title, menu, params, permalinks)
- `data/teaching_slides.yaml` — deck table rendered on the slides hub
- `layouts/` — site overrides: `index.html` (homepage banner + feature
  cards), `_default/list.html` (section pages with h1 + cover),
  `teaching-slides/list.html` (deck table),
  `partials/extended_footer.html` (About / Privacy Policy links)
- `static/` — served verbatim: `slides/` (see submodule below),
  `images/`, `figures/`, `subfiles/`, standalone pages (`mmo-simulator/`,
  `demo.html`, `genetic.html`, `mapmate.html`, `pyescape.html`),
  `terminal.css` (colour scheme: "Studio" — background `#F7F4FF`,
  foreground `#403352`, accent `#6F49AB`, from
  <https://panr.github.io/terminal-css/>)
- `public/` — committed build output, served read-only by the Terrasen
  `html-host` container (see `docs/html-host.md` in the containers repo)

## Building

Requires **Hugo extended** (the theme's floor is 0.90; CI pins 0.144.0)
— no Node, no Go, no Hugo modules.

```bash
git submodule update --init static/slides   # private repo; needs SSH access
hugo --gc --minify --forceSyncStatic
```

Output lands in `public/`. Serve locally with `hugo server` if desired.

## Deploying

`.github/workflows/gh-pages.yml` builds on push to `main` with Hugo
`0.144.0` extended and deploys `public/` to GitHub Pages. The workflow
checks out submodules with a read-only deploy key for the private
`AoifeHughes/slides` repo, so the teaching decks are copied into the
public site — keep that in mind when adding decks.

## Theme notes

Colour scheme overrides go in `static/terminal.css` (loaded after the
theme bundle); extra head/footer markup in
`layouts/partials/extended_head.html` / `extended_footer.html`. The theme's
`autoCover` is off by default; page covers are set via front-matter
`cover:` keys.
