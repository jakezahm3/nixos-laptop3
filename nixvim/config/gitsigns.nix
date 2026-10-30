_: {
  plugins.gitsigns = {
    enable = true;
    settings = {
      signs = {
        add = {
          text = " ";
        };
        change = {
          text = " ";
        };
        delete = {
          text = " ";
        };
        untracked = {
          text = "";
        };
        topdelete = {
          text = "󱂥 ";
        };
        changedelete = {
          text = "󱂧 ";
        };
      };
    };
  };
  keymaps = [
    {
      key = "]h";
      mode = [ "n" ];
      action = "<cmd>Gitsigns nav_hunk next<CR>";
      options.desc = "Next hunk";
    }
    {
      key = "[h";
      mode = [ "n" ];
      action = "<cmd>Gitsigns nav_hunk prev<CR>";
      options.desc = "Previous hunk";
    }
    {
      key = "<leader>ghs";
      mode = [ "n" ];
      action = "<cmd>Gitsigns stage_hunk<CR>";
      options.desc = "Stage hunk";
    }
    {
      # `:` (not <cmd>) so the visual range is passed through
      key = "<leader>ghs";
      mode = [ "v" ];
      action = ":Gitsigns stage_hunk<CR>";
      options.desc = "Stage selected lines";
    }
    {
      key = "<leader>ghr";
      mode = [ "n" ];
      action = "<cmd>Gitsigns reset_hunk<CR>";
      options.desc = "Reset hunk";
    }
    {
      key = "<leader>ghr";
      mode = [ "v" ];
      action = ":Gitsigns reset_hunk<CR>";
      options.desc = "Reset selected lines";
    }
    {
      key = "<leader>ghS";
      mode = [ "n" ];
      action = "<cmd>Gitsigns stage_buffer<CR>";
      options.desc = "Stage buffer";
    }
    {
      key = "<leader>ghR";
      mode = [ "n" ];
      action = "<cmd>Gitsigns reset_buffer<CR>";
      options.desc = "Reset buffer";
    }
    {
      key = "<leader>ghp";
      mode = [ "n" ];
      action = "<cmd>Gitsigns preview_hunk_inline<CR>";
      options.desc = "Preview hunk inline";
    }
    {
      key = "<leader>ghb";
      mode = [ "n" ];
      action.__raw = ''
        function()
          require("gitsigns").blame_line({ full = true })
        end
      '';
      options.desc = "Blame line";
    }
    {
      key = "<leader>ghB";
      mode = [ "n" ];
      action = "<cmd>Gitsigns blame<CR>";
      options.desc = "Blame buffer";
    }
    {
      key = "<leader>ghd";
      mode = [ "n" ];
      action = "<cmd>Gitsigns diffthis<CR>";
      options.desc = "Diff against index";
    }
    {
      key = "<leader>ght";
      mode = [ "n" ];
      action = "<cmd>Gitsigns toggle_current_line_blame<CR>";
      options.desc = "Toggle inline blame";
    }
    {
      key = "ih";
      mode = [
        "o"
        "x"
      ];
      action = ":<C-U>Gitsigns select_hunk<CR>";
      options.desc = "Inside hunk";
    }
  ];
}
