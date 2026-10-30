{lib, ...}: {
  imports = [./plugins];

  colorschemes.moonfly = {
    enable = true;
    settings = {
      Italics = true;
      NormalFloat = false;
      TerminalColors = true;
      Transparent = false;
      Undercurls = true;
      UnderlineMatchParen = false;
      VirtualTextColor = false;
      WinSeparator = 1;
    };
  };
}
