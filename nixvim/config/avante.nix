{
  plugins = {
    avante = {
      enable = true;
      settings = {
        diff = {
          autojump = true;
          debug = false;
          list_opener = "copen";
        };
        highlights = {
          diff = {
            current = "DiffText";
            incoming = "DiffAdd";
          };
        };
        hints = {
          enabled = true;
        };
        mappings = {
          diff = {
            both = "cb";
            next = "]x";
            none = "c0";
            ours = "co";
            prev = "[x";
            theirs = "ct";
          };
        };
        provider = "claude";
        providers = {
          claude = {
            endpoint = "https://api.anthropic.com";
            extra_request_body = {
              max_tokens = 4096;
              temperature = 0;
            };
            model = "claude-3-5-sonnet-20240620";
          };
        };
        windows = {
          sidebar_header = {
            align = "center";
            rounded = true;
          };
          width = 30;
          wrap = true;
        };
      };
    };
  };
}
