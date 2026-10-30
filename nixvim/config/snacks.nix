{
  pkgs,
  lib,
  config,
  ...
}:
let
  # Normal-mode mapping that opens a Snacks picker source
  picker = key: source: desc: {
    inherit key;
    mode = [ "n" ];
    action = "<cmd>lua Snacks.picker.${source}()<CR>";
    options = {
      silent = true;
      inherit desc;
    };
  };
in
{
  plugins.snacks = {
    enable = true;
    autoLoad = true;
    settings = {
      dashboard = {
        enabled = false;
      };
    };
  };

  # Snacks toggles show their current on/off state in which-key
  extraConfigLua = ''
    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
    Snacks.toggle.line_number():map("<leader>ul")
    Snacks.toggle.diagnostics():map("<leader>ud")
    Snacks.toggle.inlay_hints():map("<leader>uh")
    Snacks.toggle.treesitter():map("<leader>uT")
  '';

  keymaps = [
    {
      key = "<leader>e";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.explorer()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "File explorer";
      };
    }

    # Find
    (picker "<leader>ff" "files" "Files")
    (picker "<leader>fb" "buffers" "Buffers")
    (picker "<leader>fr" "recent" "Recent files")
    (picker "<leader>fg" "git_files" "Git files")
    {
      key = "<leader>fc";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.picker.files({ cwd = vim.fn.expand('~/nixos') })<CR>";
      options = {
        silent = true;
        desc = "NixOS config files";
      };
    }

    # Search
    (picker "<leader>?" "grep" "Grep")
    (picker "<leader>sg" "grep" "Grep")
    {
      key = "<leader>sw";
      mode = [
        "n"
        "x"
      ];
      action = "<cmd>lua Snacks.picker.grep_word()<CR>";
      options = {
        silent = true;
        desc = "Grep word or selection";
      };
    }
    (picker "<leader>sb" "lines" "Buffer lines")
    (picker "<leader>sB" "grep_buffers" "Grep open buffers")
    (picker "<leader>sh" "help" "Help pages")
    (picker "<leader>sk" "keymaps" "Keymaps")
    (picker "<leader>:" "command_history" "Command history")
    (picker "<leader>sc" "command_history" "Command history")
    (picker "<leader>sC" "commands" "Commands")
    (picker "<leader>sd" "diagnostics" "Diagnostics")
    (picker "<leader>sD" "diagnostics_buffer" "Buffer diagnostics")
    (picker "<leader>ss" "lsp_symbols" "LSP symbols")
    (picker "<leader>sS" "lsp_workspace_symbols" "LSP workspace symbols")
    (picker "<leader>sn" "notifications" "Notification history")
    (picker "<leader>sr" "resume" "Resume last picker")
    (picker "<leader>sm" "marks" "Marks")
    (picker "<leader>sj" "jumps" "Jumplist")
    (picker "<leader>s\"" "registers" "Registers")
    (picker "<leader>su" "undo" "Undo history")
    (picker "<leader>sq" "qflist" "Quickfix list")
    (picker "<leader>sM" "man" "Man pages")
    (picker "<leader>sH" "highlights" "Highlight groups")
    (picker "<leader>si" "icons" "Icons")

    # Git
    (picker "<leader>gl" "git_log" "Log")
    (picker "<leader>gf" "git_log_file" "File history")
    (picker "<leader>gb" "git_branches" "Branches")
    (picker "<leader>gs" "git_status" "Status")
    (picker "<leader>gd" "git_diff" "Diff (hunks)")
    (picker "<leader>gS" "git_stash" "Stash")
    {
      key = "<leader>gB";
      mode = [
        "n"
        "x"
      ];
      action = "<cmd>lua Snacks.gitbrowse()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "Open in browser";
      };
    }

    # UI
    (picker "<leader>uC" "colorschemes" "Colorschemes")

    # LSP
    (picker "gd" "lsp_definitions" "Goto definition")
    (picker "gD" "lsp_declarations" "Goto declaration")
    (picker "gr" "lsp_references" "References")
    (picker "gI" "lsp_implementations" "Goto implementation")
    (picker "gy" "lsp_type_definitions" "Goto type definition")
    (picker "<leader>ci" "lsp_config" "LSP servers")
    {
      key = "<leader>cR";
      mode = [ "n" ];
      action = "<cmd>lua Snacks.rename.rename_file()<CR>";
      options = {
        silent = true;
        desc = "Rename file (LSP-aware)";
      };
    }
  ];
}
