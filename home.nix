{
  config,
  inputs,
  pkgs,
  ...
}: let
  # Noctalia data directory matching noctalia.pluginDataDir()
  noctaliaDataDir = "${config.xdg.dataHome}/noctalia/plugins/custom-clock";

  # Inline Python rendering script block
  clockRenderScript =
    pkgs.writers.writePython3Bin "time-img-render" {
      libraries = []; # Standard library modules used only (time, subprocess, os)
    }
    ''
      import time
      import subprocess
      import os

      # Ensure output directory target exists prior to image generation
      output_dir = "${noctaliaDataDir}"
      os.makedirs(output_dir, exist_ok=True)
      output_file = f"{output_dir}/clock.png"

      t = time.localtime()
      hour = t.tm_hour % 12 or 12
      minute = t.tm_min
      day = t.tm_mday
      month = t.tm_mon
      year = t.tm_year

      command = f"""magick -size 300x110 canvas:transparent -draw 'rectangle 0,0 300,110' -pointsize 128 -font '7-Segment' -fill '#FF2400' -draw 'text 0,104 "{hour:02d}"' -fill white -pointsize 84 -draw 'text 116,104 ":{minute:02d}"' -fill '#FF2400' -stroke '#FF2400' -strokewidth 5 -draw 'line 220,0 220,110' -strokewidth 0 -stroke none -fill white -pointsize 32 -draw 'text 230, 30 "{day:02d}"' -draw 'text 230, 64 "{time.strftime("%b", t).upper()}"' -draw 'text 230, 100 "{year}"' {output_file}"""  # noqa: E501
      subprocess.run(command, shell=True)
    '';

  # Dotfiles are symlinked to the working copy, so edits apply without a
  # rebuild. This must be a string: a path literal like ./dot-files would be
  # copied into the Nix store and the links would point at that frozen copy.
  flakeDir = "${config.home.homeDirectory}/nixos";
  dots = "${flakeDir}/dot-files";
  live = f: config.lib.file.mkOutOfStoreSymlink "${dots}/${f}";
in {
  imports = [
    #inputs.nix4nvchad.homeManagerModules.default
    inputs.noctalia.homeModules.default
    inputs.umbriel.homeModules.default
  ];

  xdg.configFile = {
    "nvim".source = live "nvim";
    "ghostty/config.ghostty".source = live "config.ghostty";
    "kitty/kitty.conf".source = live "kitty.conf";
    "helix/config.toml".source = live "config.toml";
    "helix/languages.toml".source = live "languages.toml";
    "bacon/prefs.toml".source = live "prefs.toml";
    "zellij/config.kdl".source = live "config.kdl";
    "sway/config".source = live "sway-config";
    "greeter.toml".source = live "greeter.toml";
    "noctalia/user-templates.toml".source = live "user-templates.toml";
    "noctalia/noctalia-full-config.toml".source = live "noctalia-full-config.toml";
  };

  xdg.dataFile = {
    "noctalia/plugins/custom-clock/init.luau".source = live "init.luau";
    "noctalia/plugins/custom-clock/plugin.toml".source = live "plugin.toml";
    "noctalia/plugins/custom-clock/translations/en.json".source = live "en.json";
  };

  xdg.portal.xdgOpenUsePortal = true;

  home.file.".mcp.json".source = live "mcp-nixos.json";

  xdg.enable = true;
  xdg.autostart.enable = true;
  xdg.localBinInPath = true;

  # Configure Systemd User Units
  systemd.user.services."time-img" = {
    Unit = {
      Description = "Render clock PNG every minute for Noctalia bar widget";
    };
    Service = {
      Type = "oneshot";
      Environment = "PATH=${pkgs.lib.makeBinPath [pkgs.imagemagick]}";
      ExecStart = "${clockRenderScript}/bin/time-img-render";
    };
  };

  systemd.user.timers."time-img" = {
    Unit = {
      Description = "Timer to trigger clock face PNG generation";
    };
    Timer = {
      OnCalendar = "*:*:00";
      AccuracySec = "1s";
    };
    Install = {
      WantedBy = ["timers.target"];
    };
  };

  home.username = "jzahm";
  home.homeDirectory = "/home/jzahm";
  home.stateVersion = "26.05";

  programs.noctalia = {
    enable = true;
    settings = ./dot-files/noctalia.toml;
  };

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        trim_trailing_whitespace = true;
        insert_final_newline = true;
        indent_style = "space";
        indent_size = 2;
      };

      "*.md" = {
        trim_trailing_whitespace = false;
      };

      "*.{py,sh}" = {
        indent_size = 4;
      };
    };
  };

  home.packages = [
    pkgs.python314Packages.pillow
    pkgs.cargo
    pkgs.rustc
    pkgs.virt-viewer
    pkgs.woeusb-ng
    pkgs.mullvad-compass
    pkgs.mullvad-browser
    pkgs.libreoffice
    pkgs.remmina
    pkgs.babelfish
    pkgs.ethtool
    pkgs.go
    pkgs.talhelper
    pkgs.gnumake
    pkgs.nmap
    pkgs.qemu
    pkgs.yazi
    pkgs.fish
    pkgs.nodejs
    pkgs.tealdeer
    pkgs.ghostty
    pkgs.python3
    pkgs.wl-clipboard
    pkgs.claude-code
    pkgs.kitty
    pkgs.neovide
    pkgs.eyedropper
    pkgs.toolhive
    pkgs.dnsutils
    pkgs.lua-language-server
    pkgs.dhcpdump
    pkgs.nixd
    pkgs.gcc
    pkgs.traceroute
    pkgs.speedtest-rs
    pkgs.stylua
    pkgs.nixfmt
    pkgs.tinymist
    pkgs.prettypst
    pkgs.gimp
    pkgs.imagemagick
    pkgs.ghostscript
    pkgs.rust-analyzer
    pkgs.rustc
    pkgs.tectonic
    pkgs.mermaid-cli
    pkgs.rustfmt
    pkgs.alejandra
    pkgs.prettierd
    pkgs.beautysh
    pkgs.taplo
    pkgs.black
    pkgs.terraform-lsp
    pkgs.zathura
    pkgs.bibtex-tidy
    pkgs.xdotool
    pkgs.texliveFull
    pkgs.pstree
    pkgs.pyright
    pkgs.black
    pkgs.nil
    pkgs.micro-full
    pkgs.ripgrep
    pkgs.sad
    pkgs.awscli2
    pkgs.jq
    pkgs.kdePackages.kcalc
    pkgs.nix-search-tv
    pkgs.fzf
    pkgs.pywalfox-native
    pkgs.tmuxp
    pkgs.yt-dlp
    pkgs.psst
    pkgs.speedtest-cli
    (pkgs.mailspring.overrideAttrs (oldAttrs: {
      postFixup =
        (oldAttrs.postFixup or "")
        + ''
          wrapProgram $out/bin/mailspring \
            --add-flags "--password-store=\"gnome-libsecret\""
        '';
    }))
  ];

  i18n.glibcLocales = pkgs.glibcLocales.override {
    allLocales = false;
    locales = ["en_US.UTF-8/UTF-8"];
  };

  programs.umbriel = {
    enable = true;
    settings = ./dot-files/umbriel.toml;
  };

  programs = {
    qalculate.enable = true;
    poetry.enable = true;
    stylua.enable = true;
    joplin-desktop.enable = true;
    mcp.enable = true;
    vivaldi.enable = true;
    aerc.enable = true;
    amp.enable = true;
    antigravity.enable = true;
    nix-your-shell.enable = true;
    chawan.enable = true;
    claude-code.enable = true;
    eww.enable = true;
    eza.enable = true;
    fresh-editor.enable = true;
    freetube.enable = true;
    foliate.enable = true;
    gram.enable = true;
    gitui.enable = true;
    gallery-dl.enable = true;
    havoc.enable = true;
    inori.enable = true;
    kiro.enable = true;
    lapce.enable = true;
    lesspipe.enable = true;
    npm.enable = true;
    positron.enable = true;
    posting.enable= true;
    radio-active.enable = true;
    rio.enable = true;
    rmpc.enable = true;
    rtorrent.enable = true;
    sagemath.enable = true;
    vivid.enable = true;
    nix-index.enable = true;
    nyxt.enable = true;
    neomutt.enable = true;
    numbat.enable = true;
    nushell.enable = true;
    ncspot.enable = true;
    onedrive.enable = true;
    pandoc.enable = true;
  };

  services = {
    librespot.enable = true;
  };

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets.spotify_pw = {};
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "jakezahm3";
        email = "jakezahm3@gmail.com";
      };
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
    ignores = ["**/.claude/settings.local.json"];
  };

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    systemd.enable = true;
    enableBashIntegration = true;
    installBatSyntax = true;
    installVimSyntax = true;
    settings = {
      font-size = 14;
      font-family = "IosevkaTerm Nerd Font";
      theme = "noctalia";
    };
  };

  # Also registers gh as git's credential helper for github.com, using the
  # current store path on every rebuild (`gh auth setup-git` hardcodes one
  # that breaks after GC).
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      aliases.co = "pr checkout";
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      # Evaluates and builds as jzahm, then uses sudo only to activate.
      nrs = "nixos-rebuild switch --sudo --flake ${flakeDir}#nixos";
      gp = "git add -A && sleep 1 && git commit -m (uuidgen)";
      se = "sudo -E";
      snv = "sudo -E nvim";
    };
    interactiveShellInit = ''
      set -gx EDITOR "nvim"
      set -gx VISUAL "nvim"
      if test -f ${flakeDir}/mcp/.secrets
        source ${flakeDir}/mcp/.secrets
      end
    '';
  };

  nix.assumeXdg = true;

  # programs.nvchad = {
  #   enable = true;
  #   # ~/.config/nvim is linked from dot-files/nvim above; don't let
  #   # nix4nvchad delete and re-copy it on every switch.
  #   hm-activation = false;
  #   neovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
  #     withNodeJs = true;
  #     withPython3 = true;
  #   };
  #   extraPackages = with pkgs; [
  #     ripgrep
  #     lua-language-server
  #     stylua
  #     bash-language-server
  #     ast-grep
  #     yaml-language-server
  #     prettierd
  #     spectral-language-server
  #     vscode-langservers-extracted
  #     git
  #     curl
  #     shfmt
  #     jq
  #     uv
  #     google-java-format
  #     python3
  #     python3Packages.pynvim
  #     neovim-node-client
  #     fish-lsp
  #     texlab
  #     tex-fmt
  #     swaybg
  #     luau-lsp
  #   ];
  # };

  programs.flake-edit.enable = true;

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      vim = "nvim";
    };
    initExtra = ''
      export PATH="/home/jzahm/.nix-profile/bin/aws_completer:/home/jzahm/.local/bin:$PATH"
    '';
  };

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      mpris
      modernz
      sponsorblock
      visualizer
      webtorrent-mpv-hook
      mpv-osc-modern
      mpv-gallery-view
      mpv-cheatsheet-ng
      acompressor
      autodeint
      autosubsync-mpv
    ];
  };

  programs.brave-origin.enable = true;
  programs.fzf.enable = true;
  programs.ripgrep-all.enable = true;

  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        username = "zahm@crystal.harvard.edu";
        password = config.sops.secrets.spotify_pw.path;
      };
    };
  };

  services.ssh-agent.enable = true;
  services.podman = {
    enable = true;
  };

  services.mpris-proxy.enable = true;

  services.wl-clip-persist = {
    enable = true;
    clipboardType = "both";
    extraOptions = [
      "--write-timeout"
      "1000"
      "--ignore-event-on-error"
      "--all-mime-type-regex"
      "'(?i)^(?!image/).+'"
      "--selection-size-limit"
      "1048576"
    ];
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    NIXPKGS_ALLOW_UNFREE = "1";
  };
}
