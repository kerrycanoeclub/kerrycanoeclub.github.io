# kerrycanoeclub.com

Website for Kerry Canoe Club, built with Jekyll and published by GitHub Pages from the `master` branch.

## Run it locally

You need Ruby and Bundler installed. Then, from this folder:

```bash
bundle install
bundle exec jekyll serve
```

The site runs at http://127.0.0.1:4000.

`Gemfile` pins the `github-pages` gem so local builds match what GitHub Pages runs. Dependabot opens PRs to keep `Gemfile.lock` up to date.

See [CLAUDE.md](CLAUDE.md) for how the site is put together: where page content, homepage blocks, images and club documents live, and what to update when a document is replaced.
