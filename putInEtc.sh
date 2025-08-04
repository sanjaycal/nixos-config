sudo cp ./*.nix etc/nixos/
cd etc/nixos/
sudo nixos-rebuild boot --flake .
sudo nixos-rebuild switch --flake .
