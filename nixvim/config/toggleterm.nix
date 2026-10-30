{ pkgs, ... }:
{
  plugins.toggleterm = {
    enable = true;
    settings = {
      direction = "float";
      float_opts = {
        border = "curved";
        height = 30;
        width = 130;
      };
      open_mapping = "[[<c-t>]]";
      autochdir = true;
      auto_scroll = true;
      close_on_exit = true;
      insert_mappings = true;
      shell = "nu";
    };
  };
  keymaps = [
    {
      key = "<C-t>";
      mode = [
        "n"
        "t"
      ];
      action = "<cmd>ToggleTerm<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "Toggle terminal";
      };
    }
    {
      key = "<leader>tf";
      mode = [ "n" ];
      action = "<cmd>ToggleTerm direction=float<CR>";
      options.desc = "Floating terminal";
    }
    {
      key = "<leader>th";
      mode = [ "n" ];
      action = "<cmd>ToggleTerm size=15 direction=horizontal<CR>";
      options.desc = "Horizontal terminal";
    }
    {
      key = "<leader>tv";
      mode = [ "n" ];
      action = "<cmd>ToggleTerm size=80 direction=vertical<CR>";
      options.desc = "Vertical terminal";
    }
  ];
}

