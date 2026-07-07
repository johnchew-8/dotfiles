.PHONY: help install stow stow-home stow-config unstow-home unstow-config restow update-submodules

.DEFAULT_GOAL := help

help: 
	@echo "--- Available targets ---"
	@echo "  help              Show this message"
	@echo "  install           First-time setup: submodules + stow"
	@echo "  stow              Deploy all dotfiles (config + home)"
	@echo "  stow-config       Deploy ~/.config/ dotfiles only"
	@echo "  stow-home         Deploy ~/ dotfiles only"
	@echo "  unstow-config     Remove ~/.config/ symlinks"
	@echo "  unstow-home       Remove ~/ symlinks"	
	@echo "  restow            unstow, then stow"
	@echo "  update-submodules Refresh git submodules"

install: update-submodules stow
	@echo ""
	@echo "Done. Follow per-tool setup in README"
	# other plugin init stuff

stow:
	stow-config stow-home

stow-config:
	@echo "--- Stowing dot-config ---"
	stow -d dot-config -t ~/.config .

stow-home:
	@echo "--- Stowing home dotfiles ---"
	stow .

unstow-config:
	@echo "--- Unstowing dot-config ---"
	stow -d dot-config -t ~/.config -D

unstow-home:
	@echo "--- Unstowing home dotfiles ---"
	stow -D .

restow:
	unstow-config unstow-home stow

update-submodules:
	@echo "--- Updating git submodules ---"
	git submodule update --init --recursive
	git submodule foreach --recursive 'git pull -ff-only 2>/dev/null || true'
