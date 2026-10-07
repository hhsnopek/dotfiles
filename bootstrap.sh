#!/bin/bash
# Sets up a Mac from this repo with a single password prompt. Every step
# checks before it acts, so rerunning it is safe and finishes what an earlier
# run could not. Extra arguments go to `chezmoi init`.
#
# Written for bash 3.2: a fresh Mac runs this before Homebrew bash exists.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
account=my.1password.com

if [ ! -t 0 ]; then
	echo "bootstrap: run this in a terminal on the Mac; it needs your password and the desktop" >&2
	exit 1
fi

# One password prompt; the ticket is refreshed in the background so package
# installers, the login-shell change and system files reuse it.
sudo -v
while sudo -n true 2>/dev/null; do
	sleep 50
	kill -0 "$$" 2>/dev/null || exit 0
done &
keepalive=$!
trap 'kill "$keepalive" 2>/dev/null' EXIT

if [ ! -x /opt/homebrew/bin/brew ]; then
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

[ -d /Applications/1Password.app ] || brew install --cask 1password
command -v op >/dev/null || brew install --cask 1password-cli
command -v chezmoi >/dev/null || brew install chezmoi
command -v gh >/dev/null || brew install gh

# The setup scripts read keys and notes from 1Password through the desktop
# app, which only a person can sign in to. `vault list` rather than `whoami`:
# only a real request makes the app ask for Touch ID and open a session.
until error=$(op --account "$account" vault list 2>&1 >/dev/null); do
	open -a 1Password
	echo
	echo "1Password CLI: $error"
	echo "Sign in to 1Password, turn on Settings > Developer > Integrate with 1Password CLI, and approve the Touch ID prompt."
	read -r -p "Press Enter to check again, or type skip to continue without it: " answer
	[ "$answer" = skip ] && break
done

# --skip-ssh-key: setup puts this Mac's key on GitHub itself, and gh aborts the
# login when the key it offers to upload is already there.
# A failed sign-in must not stop the rest; the next run tries again.
if ! gh auth status --hostname github.com >/dev/null 2>&1; then
	gh auth login --hostname github.com --git-protocol ssh --skip-ssh-key --web --scopes admin:public_key ||
		echo "bootstrap: GitHub sign-in failed; continuing, rerun to retry" >&2
elif ! gh auth status --hostname github.com 2>&1 | grep -q admin:public_key; then
	gh auth refresh --hostname github.com --scopes admin:public_key ||
		echo "bootstrap: GitHub scope refresh failed; continuing, rerun to retry" >&2
fi

chezmoi init --apply --keep-going --source "$here" "$@"
