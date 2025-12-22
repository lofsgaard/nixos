# NixOS Host Template

This template is used to bootstrap new NixOS hosts with nixos-anywhere.

## Files

- **configuration.nix** - Main system configuration
- **disko.nix** - Disk partitioning layout
- **hardware-configuration.nix** - Placeholder (will be generated)

## Usage

1. Create a new host from this template:
   ```bash
   ./scripts/bootstrap-host.sh <hostname> <ip-address>
   ```

2. Customize the configuration:
   - Edit `hosts/<hostname>/configuration.nix`
   - Verify disk device in `hosts/<hostname>/disko.nix`
   - Update timezone, SSH keys, etc.

3. Add to `flake.nix`:
   ```nix
   nixosConfigurations.<hostname> = nixpkgs.lib.nixosSystem {
     modules = [
       disko.nixosModules.disko
       ./hosts/<hostname>/configuration.nix
     ];
   };

   deploy.nodes.<hostname> = {
     hostname = "<hostname>.example.com";
     profiles.system = {
       sshUser = "fjs";
       user = "root";
       path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.<hostname>;
     };
   };
   ```

4. Bootstrap the host:
   ```bash
   nix run github:nix-community/nixos-anywhere -- --flake .#<hostname> root@<ip-address>
   ```

5. Fetch the generated hardware configuration:
   ```bash
   fetch-hardware-config <hostname>
   # Enter the hostname/IP when prompted
   ```

   This will:
   - SSH into the remote host
   - Run `nixos-generate-config --show-hardware-config`
   - Save the output to `hosts/<hostname>/hardware-configuration.nix`
   - Replace the placeholder with real hardware detection

6. Review and commit:
   ```bash
   git add hosts/<hostname>/hardware-configuration.nix
   git commit -m 'feat: add hardware config for <hostname>'
   ```

7. Manage with deploy-rs:
   ```bash
   deploy .#<hostname>
   ```

## Customization Points

- **hostname**: Set in `configuration.nix` (networking.hostName)
- **timezone**: Set in `configuration.nix` (time.timeZone)
- **SSH key**: Update in users.users.fjs.openssh.authorizedKeys.keys
- **disk device**: Verify/update in `disko.nix` (default: /dev/sda)
- **packages**: Add to environment.systemPackages

## Notes

- nixos-anywhere requires root SSH access on the target machine
- The target can be running any Linux distribution (or be blank)
- After bootstrap, root login is disabled and fjs has sudo access
