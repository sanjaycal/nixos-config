{ pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "san";
  home.homeDirectory = "/home/san/";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new major version is released.
  # It's recommended to update this whenever you update Home Manager.
  #
  # See https://nix-community.github.io/home-manager/release-notes.html
  home.stateVersion = "25.05"; # Or "24.05" or whatever version you're using

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Add packages that you want to be available to your user.
  home.packages = [
    pkgs.htop
    pkgs.neofetch
    pkgs.ripgrep
    pkgs.fd
    pkgs.neovim
    pkgs.iverilog
    pkgs.gitui
  ];

  # Basic configuration for git
  programs.git = {
    enable = true;
    userName = "sanjaycal";
    userEmail = "sanjay.calgary@gmail.com";
  };
  
}
