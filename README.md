# Dotfiles . . .
> Here lies all my dotfiles that I use on all my machines, cheers ☕️

Macs and an Ubuntu laptop, all managed with [chezmoi]. No secrets live here: anything private comes out of [1Password] at setup time, and [gitleaks] stops any commit or push that holds one.

## Getting Started
*NOTE*: Run the bootstrap in a terminal on the Mac itself. It asks for your password once, and the steps that need the desktop wait for the next local run.

### Install Requirements
- macOS, or Ubuntu with [chezmoi]

That's it. The bootstrap installs [Homebrew], [1Password], [chezmoi] and [gh] when they're missing.

### Installation
```bash
git clone https://github.com/hhsnopek/dotfiles.git ~/dev/hhsnopek/dotfiles
~/dev/hhsnopek/dotfiles/bootstrap.sh
```

On a fresh Mac, `git` first offers to install Apple's developer tools; accept, then rerun the clone. Partway through, the bootstrap waits for you to sign in to 1Password and turn on Settings → Developer → Integrate with 1Password CLI, then signs gh in to GitHub. Then chezmoi asks about the Tailscale build, commit signing, the Private and Work setup notes, and this machine's SSH key. Rerun the bootstrap whenever something was skipped; every step checks before it acts.

On Ubuntu:
```bash
sudo snap install chezmoi --classic
chezmoi init --apply --source ~/dev/hhsnopek/dotfiles hhsnopek/dotfiles
```

### After the First Run
1. Approve what macOS asks for: Karabiner-Elements' driver and Input Monitoring, the "Wi-Fi networks" profile under Device Management, and Firefox as the default browser. Authorize the new SSH key for SSO on GitHub, then rerun the bootstrap.
2. Sign in to Slack, Tailscale, gcloud (`gcloud auth login --update-adc`), Claude Code and its `/mcp` servers, and Firefox Sync, then tick Enable synchronization in Multi-Account Containers. Activate CleanShot with the `CleanShot X licence` item in 1Password.
3. Log out and back in, so the keyboard and shortcut settings take effect.

## What's Inside
| Script | macOS | Linux |
|---|---|---|
| `05-ssh-key` (before files) | This machine's SSH key from 1Password, since git sends GitHub clones over SSH | Same, when chosen |
| `10-packages` | `brew bundle` from `~/.config/homebrew/Brewfile` | apt packages, Neovim release under `~/.local`, neovim-remote |
| `11-cleanshot` | CleanShot X pinned to the 4.x build the licence covers, from CleanShot's own server with a checksum | |
| `12-utc-clock` | The UTC menu bar clock, built from its pinned source tag | |
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

Secrets come from the `dotfiles` vault in 1Password while the scripts run: this machine's SSH key, the GPG signing key, the Wi-Fi passwords, the f.lux location, the database service files on work machines, and the Private and Work setup notes.

Caps Lock is Escape on macOS through [Karabiner-Elements]. Per-machine tweaks go in `~/.bashrc.local` and `~/.tmux.local.conf`, which this repo never touches.

[chezmoi]: https://www.chezmoi.io
[1Password]: https://1password.com
[gitleaks]: https://github.com/gitleaks/gitleaks
[Homebrew]: https://brew.sh
[gh]: https://cli.github.com
[Karabiner-Elements]: https://karabiner-elements.pqrs.org
