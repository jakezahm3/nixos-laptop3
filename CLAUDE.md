# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A NixOS flake (`nixosConfigurations.nixos`) with [Home Manager](https://github.com/nix-community/home-manager) wired in as a NixOS module for user `jzahm`. There is no application code to build or test.

- `flake.nix` — inputs (`nixpkgs`, `home-manager`, `nix4nvchad`, `noctalia`, `umbriel`, `hyprland`, `sops-nix`, …) and the system output.
- `configuration.nix` / `hardware-configuration.nix` — system config. Sets `home-manager.backupFileExtension = "FUCK"` with `overwriteBackup`, so files Home Manager collides with are moved to `<file>.FUCK`.
- `home.nix` — the Home Manager module: packages, shells, desktop bits (noctalia, umbriel, clock timer), and dotfile links.
- `dot-files/` — the dotfiles themselves, including the full Neovim config in `dot-files/nvim/`.

## Common commands

- Apply: `nrs` (fish alias for `nixos-rebuild switch --sudo --flake ~/nixos#nixos`; builds as `jzahm`, uses sudo only to activate)
- Build without activating: `nix build ~/nixos#nixosConfigurations.nixos.config.system.build.toplevel --out-link <dir>/result`
- Format: `alejandra *.nix`
- Update inputs: `nix flake update` (or `nix flake update <input>`)

The flake lives in `~/nixos` (owned by `jzahm`); `/etc/nixos` is a symlink to it. Use plain `git`, no sudo; `gp` stages everything and commits. Because `nrs` evaluates the flake from git, a new file that Nix reads via a path literal (e.g. `./dot-files/foo.toml`) must be `git add`ed before rebuilding.

## Dotfiles

Most dotfiles are linked live with the `live` helper in `home.nix` (`config.lib.file.mkOutOfStoreSymlink` on the string path `~/nixos/dot-files/...`), so edits take effect without a rebuild. To add one, add an entry to `xdg.configFile` (`~/.config`), `xdg.dataFile` (`~/.local/share`), or `home.file` (`~`). Do not use a path literal there: it would copy the file into the store and freeze it.

Exceptions: `dot-files/noctalia.toml` and `dot-files/umbriel.toml` are passed to their modules' `settings` options as path literals, so changes to them need a rebuild.

## Neovim

- `nix4nvchad` only provides the wrapped `nvim` binary and puts `programs.nvchad.extraPackages` (LSP servers, formatters, tools) on its `PATH`. `hm-activation = false`, so it does not write to `~/.config/nvim`. Don't use its `extraConfig` / `chadrcConfig` / `extraPlugins` options.
- `dot-files/nvim/` is a plain NvChad starter layout linked as `~/.config/nvim`:
  - `init.lua` — lazy.nvim bootstrap, then `require "extraConfig"` last
  - `lua/plugins/init.lua` — plugin specs
  - `lua/configs/lspconfig.lua` — LSP servers (`vim.lsp.config` / `vim.lsp.enable`)
  - `lua/configs/conform.lua` — formatters per filetype
  - `lua/extraConfig.lua` — options, keymaps, autocmds, highlights
  - `lua/chadrc.lua` — NvChad theme/UI
- New LSP servers or formatters: add the package to `programs.nvchad.extraPackages`, then wire it into `lspconfig.lua` or `conform.lua`. Don't install them from Mason.
- The Python and Node provider host programs are set by the `wrapNeovim` wrapper. Don't set `vim.g.python3_host_prog` in Lua.

## Notes

- `home.stateVersion` pins Home Manager compatibility behavior, not the installed release; don't change it casually.
