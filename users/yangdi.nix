{ config, pkgs, unstable, ... }:

{
  # 使用 config 属性集包裹，防止 Home Manager 顶级选项与 NixOS 系统选项冲突
  config = {

    # 1. home 属性集
    home = {
      packages = with pkgs; [
        vim tmux git tree fastfetch alacritty home-manager
        ibus ibus-engines.libpinyin
        lftp
        cascadia-code wqy_zenhei noto-fonts-cjk-sans
      ];

      file = {
        ".vimrc".source = ./dotfiles/.vimrc;
        ".zshrc".source = ./dotfiles/.zshrc;
        ".tmux.conf".source = ./dotfiles/.tmux.conf;
        ".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty.toml;
      };

      sessionVariables = {
        GTK_IM_MODULE = "ibus";
        QT_IM_MODULE = "ibus";
        XMODIFIERS = "@im=ibus";
      };

      stateVersion = "25.05";
    };

    # 2. programs 属性集 (Home Manager 顶层)
    programs.zsh.enable = true;
    programs.tmux.enable = true;
    programs.alacritty.enable = true;

    # 3. fonts 属性集 (Home Manager 顶层)
    #fonts = {
    #  fontconfig = {
    #    enable = true;
    #    defaultFonts = {
    #      serif = [ "Noto Serif" "WenQuanYi Zen Hei" ];
    #      sansSerif = [ "Noto Sans" "WenQuanYi Zen Hei" ];
    #      monospace = [ "Cascadia Mono NF" "WenQuanYi Zen Hei" ];
    #    };
    #  };
    #};
  };
}
