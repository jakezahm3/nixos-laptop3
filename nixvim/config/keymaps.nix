{ pkgs, ... }:
{
  keymaps = [
    {
      key = "<leader>p";
      mode = [ "n" ];
      action = "<cmd>YankyRingHistory<CR>";
      options.desc = "Yank history";
    }
    {
      key = "<leader>qq";
      mode = [ "n" ];
      action = "<cmd>qa<CR>";
      options.desc = "Quit all";
    }
    {
      key = "<leader>qQ";
      mode = [ "n" ];
      action = "<cmd>qa!<CR>";
      options.desc = "Quit all without saving";
    }
    {
      key = "<leader>qw";
      mode = [ "n" ];
      action = "<cmd>wqa<CR>";
      options.desc = "Save all and quit";
    }
    {
      key = "<leader>F";
      mode = [ "n" "v" ];
      action.__raw = ''
        function()
          require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 500 })
        end
      '';
      options.desc = "Format file or range (in visual mode)";
    }
  ];
}
