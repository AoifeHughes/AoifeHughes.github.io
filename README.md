# AoifeHughes.github.io

Aoife Hughes' personal website — a Hugo site using the
[hugoplate](https://github.com/zeon-studio/hugoplate) theme (MIT,
© Zeon Studio).

## Layout

- `content/english/` — site content, organised by section: `about/`,
  `contact/`, `teaching/` (with `teaching/slides/`), `research/`, and
  `pages/privacy-policy.md`.
- `data/` — `theme.json` (colours and fonts), `social.json` (social
  links), `teaching_slides.yaml`.
- `static/slides` — git submodule of the private `AoifeHughes/slides`
  repo. Fresh clones need `git submodule update --init static/slides`
  (and access to that repo) before building.
- `themes/hugoplate` — the vendored theme.
- `public/` — built site output (committed to this repo).

## Building

Requires the **extended** version of Hugo **≥ 0.141** (this repo's CI
pins 0.144.0) and a Go toolchain — the site is a Go module and Hugo's
module loader needs `go` (the verified build used hugo v0.144.0-extended
and go1.23.4).

Build from the repo root (output goes to `public/`):

    hugo --minify --forceSyncStatic

Dev server:

    hugo server

## Deployment

- GitHub Pages: `.github/workflows/gh-pages.yml` builds on push to
  `main` and deploys `public/` to GitHub Pages (the workflow sets
  `--baseURL` itself).
- Home lab: the site is also served read-only by the `html-host` nginx
  container (see the containers repo doc `docs/html-host.md`).
