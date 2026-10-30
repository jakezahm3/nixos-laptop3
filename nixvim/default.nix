{lib, ...}: {
  imports = [./plugins];

  colorschemes.base16 = {
    enable = true;
    colorscheme = "tokyo-night-terminal-dark";
  };
}
