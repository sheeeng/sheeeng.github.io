# Notes

## Prerequisites

- [Jekyll](https://jekyllrb.com/docs/installation/)

### [macOS](https://jekyllrb.com/docs/installation/macos/)

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install chruby ruby-install xz
ruby-install ruby 3.1.3

echo "source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh" >> ~/.zshrc
echo "source $(brew --prefix)/opt/chruby/share/chruby/auto.sh" >> ~/.zshrc
echo "chruby ruby-3.1.3" >> ~/.zshrc # run 'chruby' to see actual version

# Quit and relaunch Terminal, then check that everything is working.
ruby --version

gem install jekyll
```

## Serve Locally

- [Testing your GitHub Pages site locally with Jekyll](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/testing-your-github-pages-site-locally-with-jekyll).

```shell
bundle install
bundle add webrick
bundle add github-pages
bundle update github-pages
bundle exec jekyll serve
```
