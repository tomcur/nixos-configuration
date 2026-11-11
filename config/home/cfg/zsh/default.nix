{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.direnv
    pkgs.zoxide
  ];

  # The zsh configuration shared between machines. This deliberately doesn't
  # manage the zsh dotfiles themselves (`~/.zshrc` etc.), as on some machines
  # those are managed by other tools. Instead, `~/.zshrc` should source this
  # file. On NixOS machines Home Manager writes that `~/.zshrc` (see
  # `config/home/common.nix`).
  xdg.configFile."zsh/hm.zsh".text = ''
    source "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"

    # Completion.
    typeset -U path fpath
    for profile in ''${(z)NIX_PROFILES} "${config.home.profileDirectory}"; do
      fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
    done
    unset profile
    autoload -U compinit && compinit

    # History. System-wide zsh configuration may enable sharing and ignoring
    # duplicates, so explicitly disable those.
    HISTFILE="$HOME/.zsh_history"
    HISTSIZE=40000
    SAVEHIST=40000
    setopt HIST_IGNORE_SPACE
    unsetopt HIST_IGNORE_DUPS SHARE_HISTORY

    # Use vi keybindings.
    bindkey -v

    alias vi=nvim
    alias ns='nix-shell --command zsh'

    ${builtins.readFile ./prompt.zsh}

    # Nix sets `SHELL` to its own `bash` inside dev/build shells. One we've
    # opened `zsh`, re-set the environment variable so we stay inside `zsh`.
    # This takes it just from `PATH`, which probably should be fine (pointing
    # to `pkgs.zsh` would mean we can't use `PATH` to choose which `zsh` we
    # get).
    export SHELL=zsh

    # Direnv
    eval "$(direnv hook zsh)"

    nd() { nix develop "$@" --command zsh; }

    # Make a nix shell environment.
    nixify() {
      if [ ! -e ./.envrc ]; then
        echo "use nix" > .envrc
        direnv allow
      fi
      if [ ! -e shell.nix ]; then
        cat > shell.nix <<'EOF'
    with import <nixpkgs> {};
    pkgs.mkShell {
      buildInputs = [
        bashInteractive
      ];
    }
    EOF
        ''${EDITOR:-nvim} shell.nix
      fi
    }

    eval "$(zoxide init zsh)"

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    if [ -d "$HOME/.conda" ]; then
      __conda_setup="$("$HOME/.conda/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
      if [ $? -eq 0 ]; then
          eval "$__conda_setup"
      else
          if [ -f "$HOME/.conda/etc/profile.d/conda.sh" ]; then
              . "$HOME/.conda/etc/profile.d/conda.sh"
          else
              export PATH="$HOME/.conda/bin:$PATH"
          fi
      fi
      unset __conda_setup
    fi
    # <<< conda initialize <<<

    ZSH_AUTOSUGGEST_USE_ASYNC=1
    source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # Load zsh-syntax-highlighting after all custom widgets have been created.
    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  '';
}
