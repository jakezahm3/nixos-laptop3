{
  plugins.wtf = {
    enable = true;
  };
  keymaps = [
    {
      key = "<leader>wa";
      mode = [
        "n"
      ];
      action = "<cmd>Wtf<CR>";
      options.desc = "Explain diagnostic";
    }
    {
      key = "<leader>ws";
      mode = [
        "n"
      ];
      action = "<cmd>WtfSearch google<CR>";
      options.desc = "Search diagnostic online";
    }
    {
      key = "<leader>wh";
      mode = [
        "n"
      ];
      action = "<cmd>WtfHistory<CR>";
      options.desc = "History";
    }
    {
      key = "<leader>wg";
      mode = [
        "n"
      ];
      action = "<cmd>WtfGrepHistory<CR>";
      options.desc = "Grep history";
    }
  ];
}
