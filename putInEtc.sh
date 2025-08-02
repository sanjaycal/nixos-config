sudo cp ./*.nix etc/nixos/
cd etc/nixos/
sudo nixos-rebuild switch --flake .
