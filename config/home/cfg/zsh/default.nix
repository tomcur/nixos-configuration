{ ... }:
{
  home.file.".zshrc".text = ''
    # home manager
    source "/etc/profiles/per-user/thomas/etc/profile.d/hm-session-vars.sh"

    # Direnv
    eval "$(direnv hook zsh)"

    alias nm='neomutt -f "  new"'

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
        ${EDITOR:-nvim} shell.nix
      fi
    }

    eval "$(zoxide init zsh)"

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/home/thomas/.conda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/home/thomas/.conda/etc/profile.d/conda.sh" ]; then
            . "/home/thomas/.conda/etc/profile.d/conda.sh"
        else
            export PATH="/home/thomas/.conda/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
  '';
}
