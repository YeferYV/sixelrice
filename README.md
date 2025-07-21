<div align="center">
    <p>
        appimages generated from <a href="https://github.com/yeferyv/retronvim">retronvim</a>
        to preview/play/open images/videos/text inside the terminal using
        <a href="https://github.com/sxyazi/yazi">yazi</a>/
        <a href="https://github.com/mpv-player/mpv">mpv-sixel</a>/
        <a href="https://github.com/neovim/neovim">neovim</a>/
        <a href="https://github.com/zsh-users/zsh">zsh</a>/
        <a href="https://github.com/zsh-users/zsh">wezterm</a>/
        <a href="https://github.com/zsh-users/zsh">kanata</a>
        <br>
    </p>
</div>

**Install appimages from github releases**

  ```bash
  curl  -s https://api.github.com/repos/yeferyv/sixelrice/releases/latest | grep -oE "https.*yazi.appimage" | xargs -I {} curl -LO {}
  chmod +x yazi.appimage

  curl  -s https://api.github.com/repos/yeferyv/sixelrice/releases/latest | grep -oE "https.*nvim.appimage" | xargs -I {} curl -LO {}
  chmod +x nvim.appimage

  curl  -s https://api.github.com/repos/yeferyv/sixelrice/releases/latest | grep -oE "https.*zsh.appimage" | xargs -I {} curl -LO {}
  chmod +x zsh.appimage

  curl  -s https://api.github.com/repos/yeferyv/sixelrice/releases/latest | grep -oE "https.*wezterm.appimage" | xargs -I {} curl -LO {}
  chmod +x wezterm.appimage

  curl  -s https://api.github.com/repos/yeferyv/sixelrice/releases/latest | grep -oE "https.*mpv.appimage" | xargs -I {} curl -LO {}
  chmod +x mpv.appimage

  curl  -s https://api.github.com/repos/yeferyv/sixelrice/releases/latest | grep -oE "https.*kanata.appimage" | xargs -I {} curl -LO {}
  chmod +x kanata.appimage
  ```

- `export APPIMAGE_EXTRACT_AND_RUN=1` to run `zsh.appimage` it's also required if you are inside docker
- `sudo ./kanata.appimage & disown` to run `kanata` in the background
- `yazi.appimage` contains `bat`, `fzf`, `lazygit`, `ripgrep` and `7zip`
- `nvim.appimage` contains [mini.nvim](https://github.com/echasnovski/mini.nvim) and [snacks.nvim](https://github.com/folke/snacks.nvim)
- `zsh.appimage` contains `starship`, `eza`, `zsh-autosugggestions` and `fast-syntax-highlighting`
- `wezterm.appimage` contains `yazi.appimage`, `nvim.appimage`, `zsh.appimage` and [pixi](https://github.com/prefix-dev/pixi)
- `wezterm.appimage` searches `~/.vscode/extensions/yeferyv.retronvim*/bin/env/bin` for binaries and fallbacks to `appimages`
- `mpv.appimage` contains [mpv-gallery-view](https://github.com/occivink/mpv-gallery-view)
