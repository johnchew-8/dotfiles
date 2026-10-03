# Homebrew (machine-level)

Deployed by Tuckr to `~/.homebrew/`. Applies to every `brew` invocation on this machine - personal and work.

| File | Deployed to | Purpose |
|---|---|---|
| `brew.env` | `~/.homebrew/brew.env` | Homebrew settings, read by `brew` from any shell or launchd. Enables `HOMEBREW_VERIFY_ATTESTATIONS` (bottle provenance check via `gh`). |
| `.local/bin/brew-weekly` | `~/.local/bin/brew-weekly` | Runs `brew update`, `brew upgrade --formula`, then `brew vulns --fix-available`. |
| `launchd/brew-weekly.plist.in` (repo root) | `~/Library/LaunchAgents/local.dotfiles.brew-weekly.plist` | Schedule: Monday 10:00. Copied (not symlinked) by `make schedule`. |

`~/.homebrew/` also holds `trust.json` from `brew trust`. That file is machine state and is not tracked.

## Weekly upgrade

- Schedule: `make schedule` / `make unschedule` (macOS only).
- Log: `~/Library/Logs/brew-weekly.log` - one block per run, ending with `=== done (exit N) ===`. A non-zero exit means the update or upgrade failed. The `brew vulns` output lists known CVEs with a released fix that remain after the upgrade.
- Run it now: `brew-weekly`, then read the log.
- Check the job is loaded: `launchctl print gui/$(id -u)/local.dotfiles.brew-weekly`.
