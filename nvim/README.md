# [Neovim]

## Installation

```console copy
git clone --recurse-submodules --jobs 8 git@github.com:mcevoypeter/nvim.git ~/.config/nvim
cd pack/plugins/start
ls | xargs -I {} nvim -U NONE -c "helptags {}/doc" -c q
```

[Neovim]: https://neovim.io
