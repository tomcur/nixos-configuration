if [ "$TERM" != dumb ]; then
  autoload -Uz add-zsh-hook

  setprompt() {
    setopt noxtrace localoptions
    local prompt_newline
    local p_user p_host
    local base_prompt_count base_prompt_path_count prompt_length space_left
    local base_prompt path_prompt cont_prompt

    prompt_newline=$'\n%{\r%}'
    p_user='%(!.%F{red}%n%f.%F{yellow}%n%f)'

    if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then 
      p_host='%F{cyan}%M%f'
    else
      p_host='%F{yellow}%M%f'
    fi

    if [[ -n "$IN_NIX_SHELL" ]]; then
      p_nix_shell=' (nix)'
    else
      p_nix_shell=''
    fi

    # Base prompt without colors.
    base_prompt_count=$(print -P "%n@%M")
    # Base prompt with path without colors.
    base_prompt_path_count=$(print -P "%n@%M %~ >")

    # Length of expanded base prompt with path.
    prompt_length=${#base_prompt_path_count}

    base_prompt="${p_user}%F{yellow}@%f${p_host}${p_nix_shell}"
    cont_prompt=""
    if [[ $prompt_length -lt 40 ]]; then
      path_prompt="%B%~%b"
      cont_prompt="$base_prompt $path_prompt"
    else
      # Truncate path if neccesary. Ensure to keep distance
      # to right margin of shell window.
      # Place a newline after the path.
      space_left=$(( $COLUMNS - $#base_prompt_count - 1 ))
      path_prompt="%B%F{white}%${space_left}<...<%~%<<%f%b$prompt_newline"
    fi

    PS1="$base_prompt $path_prompt %B%F{white}%#%f%b "
    PS2="$cont_prompt %B%F{white}%_>%f%b "
    PS3="$cont_prompt %B%F{white}?#%f%b "
    PS4=" %B%F{white}+%f%b "
  }
  add-zsh-hook precmd setprompt
fi
