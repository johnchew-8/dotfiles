if test -f ~/.config/fish/config.local.fish
  source ~/.config/fish/config.local.fish
end

# Do not greet
set -g fish_greeting

if not set -q PNPM_HOME
  set -gx PNPM_HOME "$HOME/.local/share/pnpm"
end

# User-local toolchain binaries.
# fish_add_path is idempotent - ignores missing directories and avoids duplicates.
fish_add_path --global --move \
  "$HOME/.local/bin" \
  "$HOME/.cargo/bin" \
  "$HOME/.pixi/bin" \
  "$HOME/.bun/bin" \
  "$HOME/.local/share/fzf/bin" \
  "$HOME/go/bin" \
  "$PNPM_HOME/bin"

# Preserve scrollback buffer on clear
alias clear="clear -x"

# Interactive expansion
abbr -a gs "git status"

if status is-interactive
  bind \t forward-path-component

  # Wipe the entire command line clean instantly using Ctrl + K
  bind \ck 'backward-kill-line; kill-line'

  # Alt + Backspace: deletes word-by-word
  bind \e\x7f backward-kill-word
  
  #fzf bindings wo Alt
  # fzf_configure_bindings is provided by fzf.fish (Fisher) - guard so a
  # fresh machine without plugins doesn't error on startup
  if functions -q fzf_configure_bindings
    fzf_configure_bindings --directory=\ct --git_log=\cl --processes=\ck
  end
  
  # Update zellij tab name with current process name or pwd
  if type -q zellij
    function zellij_tab_name_update_pre --on-event fish_preexec
      if set -q ZELLIJ
        set -l cmd_line (string split " " -- $argv)
        set -l process_name $cmd_line[1]

        if test -n "$process_name"
          command nohup zellij action rename-tab $process_name >/dev/null 2>&1 &
        end
      end
    end

    function zellij_tab_name_update_post --on-event fish_postexec
      if set -q ZELLIJ
        command nohup zellij action rename-tab (prompt_pwd) >/dev/null 2>&1 &
      end
    end
  end
  
  # Persist ssh agent in git repo for WSL session. 
  agent_load
  function _ssh_autoload_on_pwd --on-variable PWD
    agent_load
  end
end

# Bind bat preview to the CTRL+T file finder in fzf
set -gx FZF_DEFAULT_OPTS "
  --layout=reverse
  --height=50%
  --border=none
  --cycle
  --info=inline
"

set -gx fzf_fd_opts --hidden --exclude .git --exclude node_modules --exclude target

set -gx fzf_history_time_format "%d/%m %H:%M"
