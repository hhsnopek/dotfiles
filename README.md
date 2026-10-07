# dotfiles

Shell, editor, terminal and app setup for every machine I use: Macs and an Ubuntu laptop. Managed with [chezmoi](https://www.chezmoi.io); the files under `home/` map onto `$HOME`.

No secrets live here. Anything private is read from 1Password or created per machine, and gitleaks blocks commits and pushes that contain one.

## New Mac

1. Clone this repo and run the bootstrap. macOS offers to install its developer tools the first time `git` runs; accept, then rerun the clone.

   ```bash
   git clone https://github.com/hhsnopek/dotfiles.git ~/dev/hhsnopek/dotfiles
   ~/dev/hhsnopek/dotfiles/bootstrap.sh
   ```

   The bootstrap asks for your password once, installs Homebrew, 1Password, chezmoi and gh when missing, waits for you to sign in to 1Password and turn on Settings → Developer → Integrate with 1Password CLI, signs gh in to GitHub, then applies this repo. chezmoi asks about the Tailscale build, commit signing, the Private and Work setup notes, and which SSH key item belongs to this machine.

   Every step checks before it acts, so rerun the bootstrap whenever something was skipped or failed. Steps that need `sudo` or the desktop fail on purpose over SSH and finish on the next local run.

2. Approve what macOS asks for: Karabiner-Elements' driver and Input Monitoring, the "Wi-Fi networks" profile under Device Management, and Firefox as the default browser. On GitHub, authorize the new SSH key for SSO, then rerun the bootstrap.
3. Sign in to the apps that need it: Slack, Tailscale, gcloud (`gcloud auth login --update-adc`), Claude Code and its `/mcp` servers, and Firefox Sync, then tick Enable synchronization in Multi-Account Containers' options. Activate CleanShot with the licence key from the `CleanShot X licence` item in 1Password.
4. Log out and back in, so the keyboard and shortcut settings take effect.

Secrets come from the `dotfiles` vault in 1Password while the scripts run: this machine's SSH key, the GPG signing key, the Wi-Fi passwords, the f.lux location, the database service files on work machines, and the Private and Work setup notes. Nothing private is written into this repo.

## Ubuntu

```bash
sudo snap install chezmoi --classic
chezmoi init --apply --source ~/dev/hhsnopek/dotfiles hhsnopek/dotfiles
```

## What runs

| Script | macOS | Linux |
|---|---|---|
| `05-ssh-key` (before files) | This machine's SSH key from 1Password, since git sends GitHub clones over SSH | Same, when chosen |
| `10-packages` | `brew bundle` from `~/.config/homebrew/Brewfile` | apt packages, Neovim release under `~/.local`, neovim-remote |
| `11-cleanshot` | CleanShot X pinned to the 4.x build the licence covers, from CleanShot's own server with a checksum | |
| `20-toolchains` | Node through `n`, npm globals, rustup and cross, Claude Code | |
| `25-1password` | GPG key, f.lux location, database service files on work machines | GPG key, when chosen |
| `26-github-key` | Adds this machine's SSH key to GitHub, opens the SSO page | Same |
| `27-wifi` | Wi-Fi networks tagged `wifi` in 1Password, as a profile to approve | |
| `28-private-setup`, `29-work-setup` | The 1Password notes of the same names, when chosen | Same |
| `30-macos-settings` | Dock, Finder, trackpad, keyboard shortcuts, menu-bar app settings | |
| `31-desktop` | Menu-bar apps at login, Firefox as default browser, display scaling, per-app notification settings, no desktop widgets | |
| `35-firefox` | `user.js` with the prefs Firefox Sync skips | Same |
| `40-system` | Homebrew bash as the login shell, optional Tailscale SSH | Caps Lock as Escape |
| `50-repos` | Commit hook, fzf-git.sh | Commit hook, fzf-git.sh |

Caps Lock is Escape on macOS through Karabiner-Elements.

Per-machine settings go in `~/.bashrc.local` and `~/.tmux.local.conf`, which this repo never touches.
