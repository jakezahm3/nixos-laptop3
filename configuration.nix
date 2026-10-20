# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.noctalia.nixosModules.default
    inputs.umbriel.nixosModules.default
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
    extraConfig = ''
      # Keep specific user environment variables when using sudo
      Defaults:root,%wheel env_keep += "PATH DISPLAY XAUTHORITY MY_CUSTOM_VAR"
    '';
  };
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    extra-substituters = ["https://noctalia.cachix.org"];
    extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
  };

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  services.mullvad-vpn = {
    enable = true;
    gui.enable = true;
  };

  services.networkd-dispatcher = {
    enable = true;
    rules."50-tailscale-optimizations" = {
      onState = ["routable"];
      script = ''
        ${pkgs.ethtool}/bin/ethtool -K eth0 rx-udp-gro-forwarding on rx-gro-list off
      '';
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true; # Optional: use GPG-agent for SSH keys
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  #networking.networkmanager.enable = true;

  # Set your time zone.
  time = {
    timeZone = "America/New_York";
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  #services.xserver.enable = true;

  environment.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
  };

  # Enable the KDE Plasma Desktop Environment.
  #services.displayManager.gdm.enable =  true;
  #services.desktopManager.budgie.enable = true;

  programs.umbriel.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  services.displayManager = {
    enable = true;
    defaultSession = "umbriel";
    autoLogin = {
      enable = true;
      user = "jzahm";
    };
    noctalia-greeter = {
      enable = true;
      passwordlessSyncUsers = ["jzahm"];
      settings = {
        keyboard.layout = "us";
        output = {
          transforms = "HDMI-A-1:none";
          width = 1920;
          height = 1080;
          name = {
            "HDMI-A-1" = {
              enable = true;
              refresh-rate = 50;
              scale = 1;
            };
            name."edp-1".enable = false;
            name."dp-1".enable = false;
          };
        };
        user.default = "jzahm";
        session.default = "umbriel";
        cursor.size = 24;
        cursorTheme = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
        };
        appearance = {
          scheme = "Synced";
          theme_mode = "dark";
          corner_radius_scale = 1.0;
        };
        clock = {
          enabled = true;
          position = "above-panel";
          time-format = "{:%I:%M:%S %p}";
          date_format = "%A, %X";
        };
      };
    };
  };

  # services.xserver = {
  #   desktopManager.xfce.enable = true;
  #   displayManager.startx.enable = true;
  #};
  # services.xserver.displayManager.lightdm = {
  #   enable = true;
  #   greeters.slick = {
  #     enable = true;
  #     extraConfig = "
  #     [Greeter]
  #     theme-name=Adwaita-dark
  #     icon-theme-name=Adwaita-dark
  #     font-name=Ubuntu 11
  #     cursor-theme-name=Adwaita-dark
  #     cursor-theme-size=24
  #     draw-user-backgrounds=false
  #     ";
  #   };
  #   background = /home/jzahm/.local/share/backgrounds/Nambung-National-Park-Australian-The-Desert-Pinakles-Milky-Way-Wallpaper-Hd-1920x1080.jpg;
  # };

  virtualisation.docker.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.pipewire.socketActivation = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    systemWide = true;
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire = {
      "98-crackling-fix" = {
        "context.properties" = {
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 1024;
          "default.clock.max-quantum" = 8192;
        };
      };
    };
    wireplumber = {
      enable = true;
    };
  };

  programs.bash = {
    enable = true;
    completion.enable = true;
    interactiveShellInit = ''
      # "check if parent process is not fish" && "make nested shells work properly"
      if grep -qv fish /proc/$PPID/comm && [[ $SHLVL == [12] ]]; then
          # set $SHELL for better integration with programs like nix shell, tmux, etc.
          SHELL=${pkgs.fish}/bin/fish exec fish
      fi
    '';
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    "jzahm" = {
      isNormalUser = true;
      linger = true;
      homeMode = "755";
      description = "Jacob Zahm";
      extraGroups = ["networkmanager" "wheel" "audio"];
      shell = pkgs.fish;
      packages = with pkgs; [
        kdePackages.kate
        thunderbird
      ];
    };
    "root".shell = pkgs.bash;
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.fish.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
    systemd.enable = true;
  };

  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;

  services.tailscale = {
    enable = true;
    # Only used to log in when the node isn't already authenticated.
    authKeyFile = config.sops.secrets.tailscale_key.path;
    extraUpFlags = ["--ssh" "--accept-routes" "--accept-dns"];
  };

  networking.nftables.enable = true;
  networking.useNetworkd = true;
  networking.firewall = {
    enable = true;
    # Always allow traffic from your Tailscale network
    trustedInterfaces = [config.services.tailscale.interfaceName];
    # Allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [config.services.tailscale.port];
  };

  # 2. Force tailscaled to use nftables (Critical for clean nftables-only systems)
  # This avoids the "iptables-compat" translation layer issues.
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  # 3. Optimization: Prevent systemd from waiting for network online
  # (Optional but recommended for faster boot with VPNs)
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.sessionVariables = {
    "SUDO_EDITOR" = "nvim";
  };

  services.qbittorrent = {
    enable = true;
    user = "jzahm";
  };

  environment.systemPackages = with pkgs; [
    flake-checker
    nixtract
    vim
    wget
    virtiofsd
    git
    qbittorrent
    virtiofsd
    xclip
    xwayland-satellite
    tmux
    wlroots
    wlr-randr
    htop
    thunar
    python314Packages.numpy
    onnxruntime
    python314Packages.pillow
    steam-run
    age
    rage
    ssh-to-age
    sops
    rops
    slurp
    tesseract
    grim
    libsecret
    thunar
    gvfs
    pavucontrol # PulseAudio Volume Control
    pamixer # Command-line mixer for PulseAudio
    bluez # Bluetooth support
    bluez-tools # Bluetooth tools
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka-term
  ];

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  services.nginx = {
    enable = true;
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
      thunar-media-tags-plugin
      thunar-vcs-plugin
      gvfs
      tumbler
      transmission_4-gtk
    ];
  };

  programs.nh = {
    enable = true;
    flake = "/home/jzahm/nixos";
    clean = {
      enable = true;
    };
  };

  sops = {
    useSystemdActivation = true;
    # Encrypted file, safe to commit. Edit with `sops secrets/secrets.yaml`.
    defaultSopsFile = ./secrets/secrets.yaml;
    # Decrypt with the host key. openssh is off, so sops-nix won't pick it up by default.
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    # Decrypted to /run/secrets/tailscale_key (root, 0400).
    secrets.tailscale_key = {};
  };

  services.transmission = {
    enable = true;
    user = "jzahm";
  };

  zramSwap.enable = true;
  services.zram-generator.enable = true;

  system.stateVersion = "26.05"; # Did you read the comment?
}
