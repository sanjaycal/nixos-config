# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./home.nix
    ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.grub = {
    enable=true;
    efiSupport=true;
    devices = ["nodev"];
  };
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.useOSProber = false;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  programs.neovim.enable = true;

  # Enable the GNOME Desktop Environment.
  #add gdm
  services.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  programs.hyprland = {
    enable = true;
    
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  #NVIDIA GPU Drivers
  boot.kernelParams = ["nvidia-drm.modeset=1"];

  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # 2. Update your NVIDIA block to include PRIME offloading
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      
      # REPLACE THESE with the Bus IDs you found in Step 1!
      intelBusId = "PCI:0:2:0"; 
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # 3. Explicitly enable XDG Portals for Pipewire Screen Sharing
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # Good fallback for generic apps
  };
  
  boot.blacklistedKernelModules = ["nouveau"];
  hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
  settings = {
    General = {
      Experimental = true; # Show battery charge of Bluetooth devices
    };
  };
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

  services.foundryvtt = {
    enable = false;
    hostName = "san";
    minifyStaticFiles = true;
    proxyPort = 443;
    proxySSL = true;
    upnp = false;
  };

  services.hermes-agent = {
    enable = true;
    settings.model.default = "anthropic/claude-sonnet-4";
    environmentFiles = [ "/home/san/.config/hermes/env"];
    addToSystemPackages = true;
  };

  services.tailscale.enable = true;
  programs.coolercontrol.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.san = {
    isNormalUser = true;
    description = "san";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [
    	discord
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.steam.enable = true;

  #the selection menu
  programs.uwsm.enable = true;
  programs.uwsm.waylandCompositors = {
  	hyprland = {
		prettyName = "Hyprland";
		comment = "Hyprland compositor managed by UWSM";
		binPath = "/run/current-system/sw/bin/Hyprland";
	};
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.segger-jlink.acceptLicense = true;
  nixpkgs.config.permittedInsecurePackages = [
    "segger-jlink-qt4-874"
  ];

  virtualisation.docker.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  vim
  wget
  kitty
  alacritty
  wofi
  google-chrome
  git
  #open-webui
  cargo
  python313
  uv
  libgcc
  nodejs_24
  waybar
  gnumake
  hyprshot
  blender
  yazi
  hyprnotify
  hyprpaper
  libnotify
  gcc
  curl
  zlib
  gh
  gitui
  iverilog
  atlauncher
  game-rs
  basilk
  helix
  gtkwave
  unzip
  wgpu-native
  wgpu-utils
  pkg-config
  alsa-oss
  btop-cuda
  nautilus
  pavucontrol
  obsidian
  rustup
  jan
  nodejs_24
  lutris
  obs-studio
  prismlauncher
  man-pages
  man-pages-posix
  gimp
  steam-run
  cmake
  #stlink
  tailscale
  ngrok
  coolercontrol.coolercontrol-gui
  docker
  opencode
  llama-cpp-vulkan
  inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
  playerctl
  ];

  services.udev.packages = [ pkgs.stlink pkgs.segger-jlink ];

  nix = {
    extraOptions = ''
      extra-experimental-features = nix-command flakes
    '';
    settings = {
      substituters = [
        "https://nix-cache.fossi-foundation.org"
	"https://openlane.cachix.org"
      ];
      trusted-public-keys = [
        "nix-cache.fossi-foundation.org:3+K59iFwXqKsL7BNu6Guy0v+uTlwsxYQxjspXzqLYQs="
	"openlane.cachix.org-1:qqdwh+QMNGmZAuyeQJTH9ErW57OWSvdtuwfBKdS254E="
      ];
    };
  };

  #services.ollama = {
  #	enable= true;
  #	acceleration = "cuda";
  #	models = "~/files/ollama";
  #};

  documentation.dev.enable = true;



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
