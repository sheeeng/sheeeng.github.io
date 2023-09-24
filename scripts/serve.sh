#!/usr/bin/env bash

# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -o pipefail
set -o errexit # set -e
set -o nounset # set -u
set -o xtrace  # set -x

# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
shopt -s inherit_errexit

bundle exec jekyll serve
