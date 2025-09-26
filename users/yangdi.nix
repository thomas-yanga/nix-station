{ config, pkgs, unstable, ... }:

{
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
}
