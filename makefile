.PHONY: help cli-tools bootstrap deploy restow deploy-work restow-work

help:
	@echo "--- tuckr dotfiles ---"
	@echo "  tuckr add \*         Deploy all groups"
	@echo "  tuckr rm \*          Remove all symlinks"
	@echo "  tuckr status         Show status"
	@echo "  make deps            Install Homebrew packages (Brewfile, + Brewfile.macos on macOS)"
	@echo "  make deploy          Deploy default profile"
	@echo "  make restow          Redeploy default profile"
	@echo "  make bootstrap       deps then deploy (fresh machine)"
	@echo "  make deploy-work     Deploy work profile (~/.dotfiles_work)"
	@echo "  make restow-work     Redeploy work profile"
	@echo "  make cli-tools       Install cli tool packages with Homebrew bundle"
	@echo "  make bootstrap       Install cli tools then deploy (fresh machine)"

deps:
	@for p in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew; do \
	  if [ -x "$$p/bin/brew" ]; then \
	    "$$p/bin/brew" bundle install --file Brewfile || exit $$?; \
	    if [ "$$(uname -s)" = Darwin ]; then \
	      "$$p/bin/brew" bundle install --file Brewfile.macos || exit $$?; \
	    fi; \
	    exit 0; \
	  fi; \
	done; \
	echo "brew not found — install from https://brew.sh first" >&2; exit 1

bootstrap: deps deploy

# eza and brew link files only: their target dirs must stay real directories
deploy:
	tuckr add \* -e eza,brew
	tuckr add eza brew --only-files

restow:
	tuckr rm \*
	tuckr add \* -e eza,brew
	tuckr add eza brew --only-files

deploy-work:
	tuckr -p work add \* -e eza
	tuckr -p work add eza --only-files

restow-work:
	tuckr -p work rm \*
	tuckr -p work add \* -e eza
	tuckr -p work add eza --only-files

