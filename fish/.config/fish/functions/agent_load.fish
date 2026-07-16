# --- Persistent ssh-agent for WSL ---

function agent_load
  # Skip if not in git repository.
  git rev-parse --is-inside-work-tree >/dev/null 2>&1
  or return
  set -l sock $HOME/.ssh/agent.sock

  # Reuse the existing agent if its socket is alive
  if test -S $sock
    set -gx SSH_AUTH_SOCK $sock
    ssh-add -l >/dev/null 2>&1
    and return
    # Remove stale socket from previous session
    rm -f $sock
  end

  ssh-agent -a $sock >/dev/null
  set -gx SSH_AUTH_SOCK $sock
  ssh-add
end
