{ config, pkgs, ... }:

{
  home.username = "yangdi";
  home.homeDirectory = "/home/yangdi";
  home.stateVersion = "25.05";  # 与 NixOS 版本一致（25.05）

  home.file = {
    ".zshrc" = {
      source = ../dotfiles/.zshrc;
    };

    ".vimrc" = {
      source = ../dotfiles/.vimrc;
    };
    ".tmux.conf" = {
      source = ../dotfiles/.tmux.conf;
    };
  };

  home.packages = with pkgs; [
    fastfetch        # .zshrc 中需要启动时运行（如果你的 .zshrc 已加 fastfetch 命令）
    trash-cli        # .zshrc 中 alias rm='trash' 依赖此工具
    zsh              # 确保 Zsh 已安装（虽然系统可能有，但用户级安装更稳妥）
    tmux             # 确保 tmux 已安装
    vim              # 确保 vim 已安装
  ];

}

