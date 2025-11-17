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

  curl  -s https://api.github.com/repos/yeferyv/sixelrice/releases/latest | grep -oE "https.*mpris.so" | xargs -I {} curl -LO {}
  chmod +x mpris.so

  curl  -s https://api.github.com/repos/yeferyv/sixelrice/releases/latest | grep -oE "https.*kanata.appimage" | xargs -I {} curl -LO {}
  chmod +x kanata.appimage
  ```

- `export APPIMAGE_EXTRACT_AND_RUN=1` required if you are inside docker or use `--appimage-extract-and-run` (e.g. `zsh.appimage --appimage-extract-and-run`)
- `export APPIMAGE_EXTRACT_AND_RUN=1` required if you are inside WSL or download `sudo apt install libfuse2` or `sudo pacman -S fuse2`
- `export APPIMAGE_EXTRACT_AND_RUN=1` makes `appimages` to have slow startup
- `nohup sudo ./kanata.appimage` to run `kanata` in the background and `LeftCtrl + Space + Escape` to stop kanata
- `yazi.appimage` contains `bat`, `fzf`, `lazygit`, `ripgrep` and `7zip`
- `nvim.appimage` contains [mini.nvim](https://github.com/echasnovski/mini.nvim), [snacks.nvim](https://github.com/folke/snacks.nvim) and [supermaven-nvim](https://github.com/supermaven-inc/supermaven-nvim)
- `zsh.appimage` contains `starship`, `eza`, `zsh-autosugggestions`, `fast-syntax-highlighting` and [pixi](https://github.com/prefix-dev/pixi)
- `zsh.appimage`: search pixi packages on `https://prefix.dev` e.g. to install git `pixi global install git`
- you can place `nvim.appimage` as `~/.local/bin/nvim`, `yazi.appimage` as `~/.local/bin/yazi` and `zsh.appimage` as `~/.local/bin/zsh` to be found by `zsh.appimage`
- don't place `zsh.appimage` as `~/.pixi/bin/zsh` since `~/.pixi/bin/zsh` is called first rather than `/tmp/appimage*/.pixi/envs/default/bin/zsh`
- `wezterm.appimage` contains `yazi.appimage`, `nvim.appimage` and `zsh.appimage`
- `wezterm.appimage` searches `~/.vscode/extensions/yeferyv.retronvim*/bin/env/bin` for binaries and fallbacks to `appimages`
- `mpv.appimage` with [mpv-gallery-view](https://github.com/occivink/mpv-gallery-view) and a compatible (precompiled) [mpris.so](https://github.com/hoyon/mpv-mpris) (for playerctl)
- copy `mpris.so` to `$MPV_HOME/scripts/` or to `/etc/mpv/scripts/`
