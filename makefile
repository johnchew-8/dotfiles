.PHONY: help install restow install-work restow-work

help:
	@echo "--- tuckr dotfiles ---"
	@echo "  tuckr add \*         Deploy all groups"
	@echo "  tuckr rm \*          Remove all symlinks"
	@echo "  tuckr status         Show status"
	@echo "  make install         Deploy default profile"
	@echo "  make restow          Redeploy default profile"
	@echo "  make install-work    Deploy work profile (tuckr -p work)"
	@echo "  make restow-work     Redeploy work profile"

install:
	tuckr add \* -e eza
	tuckr add eza --only-files

restow:
	tuckr rm \*
	tuckr add \* -e eza
	tuckr add eza --only-files

install-work:
	tuckr -p work add \* -e eza
	tuckr -p work add eza --only-files

restow-work:
	tuckr -p work rm \*
	tuckr -p work add \* -e eza
	tuckr -p work add eza --only-files

