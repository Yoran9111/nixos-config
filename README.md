🏰 NixOS Configuration with Flakes

This repository contains a NixOS configuration with Flakes for reproducible system setup.

📂 Structure

🗂 nixos-config
├── flake.nix                    # Flake configuration (entry point)
├── flake.lock                   # Lockfile (auto-generated)
├── configuration.nix            # System configuration
├── hardware-configuration.nix   # Auto-generated hardware config
├── README.md                    # Documentation

🚀 Installation & Usage

1️⃣ Clone the Repository

git clone https://github.com/yourusername/nixos-config.git
cd nixos-config

2️⃣ Apply the Configuration

sudo nixos-rebuild switch --flake .#nixos

3️⃣ Enable Flakes (if needed)

If you get an error about Flakes being disabled, enable them:

sudo mkdir -p /etc/nix
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
sudo systemctl restart nix-daemon.service

4️⃣ Update Your Configuration

To update packages and system settings:

nix flake update
sudo nixos-rebuild switch --flake .#nixos

5️⃣ Debugging

Check logs: journalctl -xe

Check running services: systemctl list-units --type=service

Test nginx config: nginx -t

👉 Additional Information

Enabling Flakes on NixOS

If you haven't enabled flakes, ensure that the following is added to your system configuration:

nix = {
  package = pkgs.nixVersions.stable;
  extraOptions = "experimental-features = nix-command flakes";
};

Then rebuild your system with:

sudo nixos-rebuild switch

Common Issues & Fixes

1️⃣ Permission Denied When Modifying /etc/nix/nix.conf

Run sudo chmod u+w /etc/nix/nix.conf to make it writable.

Alternatively, modify it within configuration.nix as shown above.

2️⃣ Flake Lockfile Not Updating

Run nix flake update manually.

Ensure Git is properly initialized in your repo.

3️⃣ Nginx Not Working?

Check nginx -t for configuration errors.

Restart the service with sudo systemctl restart nginx.

4️⃣ Missing Packages After Rebuild?

Make sure they are listed under environment.systemPackages.

Run nix-store --verify --check-contents to troubleshoot package issues.
