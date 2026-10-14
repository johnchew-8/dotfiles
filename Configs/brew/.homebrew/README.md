# Homebrew (machine-level)

Deployed by Tuckr to `~/.homebrew/`. Applies to every `brew` invocation on this machine - personal and work.

| File                                       | Deployed to                                               | Purpose                                                                                                                                 |
| ------------------------------------------ | --------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `brew.env`                                 | `~/.homebrew/brew.env`                                    | Homebrew settings, read by `brew` from any shell or launchd. Enables `HOMEBREW_VERIFY_ATTESTATIONS` (bottle provenance check via `gh`). |

