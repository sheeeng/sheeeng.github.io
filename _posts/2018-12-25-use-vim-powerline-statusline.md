---
layout: post
title:  "Use VIM Powerline Status"
date:   2018-12-25 21:30
categories:
---

- Install [Powerline][powerline-installation].

```bash
pip3 install powerline-status
```

- Enable [Powerline in Vim][enable-vim-statusline].

Append below lines in `~/.vimrc` file.

```python
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup
```

- Start a new terminal session.

[powerline-installation]: https://powerline.readthedocs.io/en/latest/installation.html

[enable-vim-statusline]: https://powerline.readthedocs.io/en/latest/usage/other.html#vim-statusline
