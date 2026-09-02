.PHONY: help cli-tools deploy restow deploy-work restow-work

help:
	@echo "--- tuckr dotfiles ---"
	@echo "  tuckr add \*         Deploy all groups"
	@echo "  tuckr rm \*          Remove all symlinks"
	@echo "  tuckr status         Show status"
	@echo "  make deploy          Deploy default profile"
	@echo "  make restow          Redeploy default profile"
	@echo "  make deploy-work     Deploy work profile (tuckr -p work)"
	@echo "  make restow-work     Redeploy work profile"
	@echo "  make cli-tools       Install cli tool packages with Homebrew bundle"

cli-tools:
	@for p in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew; do \
	  if [ -x "$$p/bin/brew" ]; then \
	    "$$p/bin/brew" bundle install --no-lock && exit 0; \
	  fi; \
	done; \
	echo "brew not found — install from https://brew.sh first" >&2; exit 1

deploy:
	tuckr add \* -e eza
	tuckr add eza --only-files

restow:
	tuckr rm \*
	tuckr add \* -e eza
	tuckr add eza --only-files

deploy-work:
	tuckr -p work add \* -e eza
	tuckr -p work add eza --only-files

restow-work:
	tuckr -p work rm \*
	tuckr -p work add \* -e eza
	tuckr -p work add eza --only-files

