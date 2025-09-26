# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix = {
    # Enable flakes and nix-command experimental features
    settings.experimental-features = [ "nix-command" "flakes" ];
    # Configure binary caches for faster package installation
    settings.substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
    # Trusted public keys for the binary caches
    settings.trusted-public-keys = [
      "mirrors.tuna.tsinghua.edu.cn-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nix-station"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    # Additional locale settings for Chinese environment
      inputMethod = {
        enable = true;
        type = "ibus";
        ibus.engines = with pkgs.ibus-engines; [
        libpinyin
        ];
      };
    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
    };
  };

  fonts = {
    # Install Chinese and international fonts
    packages = with pkgs; [
      wqy_zenhei
      wqy_microhei
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "grp:alt_shift_toggle";  # Toggle with Alt+Shift
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yangdi = { pkgs, unstable, ... }:{
    isNormalUser = true;
	description = "YangDi";
	extraGroups = [ "networkmanager" "wheel" ];
  };

  # Install firefox and zsh
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  services.flatpak.enable = true;

  home-manager = {
    useUserPackages = true;
    users.yangdi = { pkgs, unstable, ... }: {
      home.packages = with pkgs; [
        # Essential user tools (keep non-i3 tools)
        vim tmux git tree fastfetch alacritty
	    home-manager
        # Chinese Input Method (KEEP)
        ibus ibus-engines.libpinyin
        # Network tools
        lftp
        # Fonts (user-level fonts)
        cascadia-code wqy_zenhei noto-fonts-cjk-sans
      ];
      home.file.".vimrc".source = ./dotfiles/.vimrc;
      home.file.".zshrc".source = ./dotfiles/.zshrc;
      home.file.".tmux.conf".source = ./dotfiles/.tmux.conf;
      home.file.".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty.toml;
      # Enable programs managed by home-manager
      programs.zsh.enable = true;
      programs.tmux.enable = true;
      # Environment variables for IBus input method (KEEP)
      home.sessionVariables = {
        GTK_IM_MODULE = "ibus";
        QT_IM_MODULE = "ibus";
        XMODIFIERS = "@im=ibus";
      };
      fonts = {
        fontconfig = {
          enable = true;
          defaultFonts = {
            serif = [ "Noto Serif" "WenQuanYi Zen Hei" ];
            sansSerif = [ "Noto Sans" "WenQuanYi Zen Hei" ];
            monospace = [ "Cascadia Mono NF" "WenQuanYi Zen Hei" ];
          };
        };
      };
      programs.alacritty = {
        enable = true;
        #configFile = ./dotfiles/alacritty.toml;
      };
      home.stateVersion = "25.05";
    };
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.open = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.modesetting.enable = true;
  services.timesyncd.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
