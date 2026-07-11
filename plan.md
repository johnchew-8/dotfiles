## Phase 1 — Unstow and use conventional per-app dotfiles pattern:

- XDG config: `app/.config/app` sturcture
- XDG Home: `app/.app.conf`
- **Ensure compatibility** with [Tuckr expected dotfiles directory structure](https://github.com/RaphGL/Tuckr#getting-started)

## Phase 2 — Tuckr migration:

- `tuckr` is already installed
- No need for configuration, use simple commands like:
  - `tuckr add`, `tuckr status`, `tuckr rm`
  - Don't overcomplicate with Tuckr secrets feature
  - KISS: Version control dotfiles.
