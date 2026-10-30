{
  plugins.treesj = {
    enable = true;
    autoLoad = true;
    # Defaults map <space>m/j/s; <leader>s is the Search group
    settings.use_default_keymaps = false;
  };
  keymaps = [
    {
      key = "<leader>m";
      mode = [
        "n"
      ];
      action = "<cmd>TSJToggle<CR>";
      options.desc = "Toggle split/join node";
    }
    {
      key = "<leader>cs";
      mode = [
        "n"
      ];
      action = "<cmd>TSJSplit<CR>";
      options.desc = "Split node";
    }
    {
      key = "<leader>j";
      mode = [
        "n"
      ];
      action = "<cmd>TSJJoin<CR>";
      options.desc = "Join node";
    }
  ];
}
