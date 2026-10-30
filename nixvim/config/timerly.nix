{
  plugins.timerly = {
    enable = true;
    autoLoad = true;
    settings = {
      minutes = [
        5
        10
        15
        20
        25
        30
      ];
    };
  };
  keymaps = [
    {
      key = "<leader>ut";
      mode = [ "n" ];
      action = "<cmd>TimerlyToggle<CR>";
      options.desc = "Timer";
    }
  ];
}
