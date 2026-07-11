.PHONY: help install restow

help:
	@echo "--- tuckr dotfiles ---"
	@echo "  tuckr add \*         Deploy all groups"
	@echo "  tuckr rm \*          Remove all symlinks"
	@echo "  tuckr status         Show status"

install:
	tuckr add \*

restow:
	tuckr rm \*
	tuckr add \*
