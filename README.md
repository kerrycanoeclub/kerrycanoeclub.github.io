# kerrycanoeclub.com

## Local development

Read here for more info.
[https://help.github.com/en/github/working-with-github-pages/testing-your-github-pages-site-locally-with-jekyll](https://help.github.com/en/github/working-with-github-pages/testing-your-github-pages-site-locally-with-jekyll)

### Basics of install and run

Must have ruby, gems and bundler installed on your system.

Check with:
```
$ ruby -v
# ruby 2.7.0p0 (2019-12-25 revision 647ee6f091) [x86_64-linux-gnu]

$ gem -v
# 3.1.2

$ bundle -v
# Bundler version 2.1.4
```

Then you can run the following from the root folder to install dependencies:

    $ bundle install

And build the project locally:

    $ bundle exec jekyll serve

The github pages site should then be running on `# Server address: http://127.0.0.1:4000/`

### Github-pages GEM

Regularly update the `github-pages` gem on your computer.

In Terminal run
- If you installed Bundler, run `$ bundle update github-pages`
- If you don't have Bundler installed, run `$ gem update github-pages`




