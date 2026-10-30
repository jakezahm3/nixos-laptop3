{
  plugins.opencode = {
    enable = true;
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>oa";
      action = "<cmd>lua require('opencode').ask()<CR>";
      options.desc = "Opencode Ask";
    }
    {
      mode = "n";
      key = "<leader>os";
      action = "<cmd>lua require('opencode').select()<CR>";
      options.desc = "Opencode Select";
    }
    {
      mode = "v";
      key = "<leader>or";
      action = "<cmd>lua require('opencode').prompt('review')<CR>";
      options.desc = "Opencode Review Selection";
    }
    {
      mode = "v";
      key = "<leader>oe";
      action = "<cmd>lua require('opencode').prompt('explain')<CR>";
      options.desc = "Opencode Explain Selection";
    }
  ];
  extraConfigLua = ''
    local opencode_cmd = "opencode --port 12345"

    vim.g.opencode_opts = {
      port = 12345,
      server = {
        start = function()
          vim.cmd("terminal " .. opencode_cmd)
        end,
        stop = function() end,
        toggle = function() end,
      },
    }
  '';
}
