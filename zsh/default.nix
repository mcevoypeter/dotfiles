{ ... }: {
  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    syntaxHighlighting.enable = true;

    history = {
      path = "$HOME/.zsh_history";
      size = 10000;
      save = 10000;
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      av  = "action-validator";
      cat = "bat";
      gad = "git add";
      gap = "git apply";
      gbi = "git bisect";
      gbr = "git branch";
      gch = "git checkout";
      gce = "git clean";
      gcm = "git commit";
      gcn = "git clone";
      gcp = "git cherry-pick";
      gdi = "git diff";
      gfe = "git fetch";
      ggr = "git_grep";
      gin = "git init";
      glo = "git log --abbrev-commit";
      gmb = "git merge-base";
      gme = "git merge";
      gmv = "git mv";
      gps = "git push";
      gpl = "git pull";
      grb = "git rebase";
      gre = "git revert";
      grf = "git reflog";
      grl = "git rev-list";
      grp = "git rev-parse";
      grm = "git rm";
      gro = "git remote";
      grs = "git reset";
      grt = "git restore";
      gsh = "git show";
      gss = "git stash";
      gst = "git status --short";
      gsu = "git submodule";
      gsw = "git switch";
      gta = "git tag";
      gwo = "git worktree";
      ls  = "eza";
      pr  = "gh pr create --template PULL_REQUEST_TEMPLATE.md --title";
    };

    initContent = ''
      function fzf_cmd() {
        fzf --multi "$@"
      }

      function git_grep() {
        git grep -e "$1" -n $(git rev-list --all --abbrev-commit)
      }

      function zle_env_var() {
        local env_var=$(printenv \
          | awk -F '=' '{ print $1 }' \
          | fzf_cmd)
        [[ -n "$env_var" ]] && zle -U "\$$env_var"
      }

      function zle_git_ref() {
        local branch_icon='\\ue725'
        local branches=$(git branch \
          | tr -d '*' \
          | awk '{ print $1 }' \
          | sed "s|^|$branch_icon |")
        local tag_icon='\\uf412'
        local tags=$(git tag | sed "s|^|$tag_icon |")
        local ref=$(echo $branches $tags | fzf_cmd)
        [[ -n "$ref" ]] && zle -U $(awk '{ print $2 }' <<< "$ref")
      }

      function zle_git_commit() {
        local sha=$(git --no-pager log --abbrev-commit --pretty=oneline \
          | fzf_cmd --no-sort \
          | awk '{ print $1 }')
        [[ -n "$sha" ]] && zle -U "$sha"
      }

      function zle_history() {
        local cmd=$(history 1 \
          | fzf_cmd --no-sort --scheme=history --tac \
          | awk '!($1="")' ORS=' &&' \
          | sed 's|^ *||' \
          | sed 's|&&$||')
        [[ -n "$cmd" ]] && zle -U "$cmd"
      }

      function zle_jobs() {
        local job_num=$(jobs | fzf_cmd | awk '{ print $1 }' | tr -d '[]')
        [[ -n "$job_num" ]] && zle -U "%$job_num"
      }

      function zle_ls() {
        fzf_preview="[ -d {} ] \
          && eza --all --long {} \
          || bat --color=always --line-range=0:200 {} --style=numbers"
        local entry=$(fd . . --hidden --no-ignore-vcs \
          | fzf_cmd --preview="$fzf_preview" --scheme=path \
          | awk 1 ORS=' ')
        [[ -n "$entry" ]] && zle -U "$entry"
      }

      function zle_ps() {
        local pid=$(procs \
          | fzf_cmd --header-lines=2 --no-sort --tac \
          | awk '{print $1}' ORS=' ')
        [[ -n "$pid" ]] && zle -U "$pid"
      }

      eval "$(pyenv init -)"

      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey -M viins '^V' edit-command-line
      bindkey -M vicmd '^V' edit-command-line
      bindkey -M viins '\t' expand-or-complete
      bindkey -M viins '^A' beginning-of-line
      bindkey -M viins '^E' end-of-line
      bindkey -M viins '^W' backward-kill-word
      bindkey -M viins '^U' kill-whole-line
      bindkey -M viins '^?' backward-delete-char
      bindkey -M viins '^H' backward-delete-char
      zle -N zle_env_var
      bindkey -M viins '^K' zle_env_var
      zle -N zle_git_ref
      bindkey -M viins '^B' zle_git_ref
      zle -N zle_git_commit
      bindkey -M viins '^G' zle_git_commit
      zle -N zle_history
      bindkey -M viins '^R' zle_history
      zle -N zle_jobs
      bindkey -M viins '^J' zle_jobs
      zle -N zle_ls
      bindkey -M viins '^F' zle_ls
      zle -N zle_ps
      bindkey -M viins '^P' zle_ps

      setopt HIST_FIND_NO_DUPS
      setopt HIST_REDUCE_BLANKS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_VERIFY
      setopt INC_APPEND_HISTORY

      autoload -Uz vcs_info
      precmd_vcs_info() { vcs_info }
      precmd_functions+=( precmd_vcs_info )
      local git_branch='(%F{red}%b%f)'
      zstyle ':vcs_info:git:*' formats "$git_branch"
      zstyle ':vcs_info:*' enable git
      setopt prompt_subst
      local user='%B%n%b'
      local host=""
      if [[ -n "$SSH_CONNECTION" || -n "$SSH_CLIENT" ]]; then
        host='%F{red}ssh%f<%B%F{red}%m%f%b%>'
      else
        host='%B%F{magenta}%m%f%b'
      fi
      local dir='%B%F{cyan}%3~%f%b'
      PROMPT="$user@$host:$dir \$vcs_info_msg_0_
%(?.%F{green}.%F{red})%#%f "
      RPROMPT=
    '';
    profileExtra = ''
      export PYENV_ROOT="$HOME/.pyenv"

      case $(uname -s) in
        "Darwin")
          export ANDROID_HOME="$HOME/Library/Android/sdk"
          export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
          export PATH="/opt/homebrew/bin:$PATH"
          export PATH="$PATH:$ANDROID_HOME/emulator"
          export PATH="$PATH:$ANDROID_HOME/platform-tools"
          ;;
        "Linux")
          export PATH="$PYENV_ROOT/bin:$PATH"
          export QT_QPA_PLATFORM=xcb
          export XDG_CURRENT_DESKTOP="sway"
          ;;
      esac

      export GOPATH="$(go env GOPATH)"
      export PATH="$GOPATH/bin:$NVM_BIN:$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

      export EDITOR=$(which nvim)
      export FZF_DEFAULT_COMMAND="fd --hidden --no-ignore"
      export FZF_DEFAULT_OPTS="--cycle --keep-right --multi"
      export GIT_AUTHOR_EMAIL="git@mcevoypeter.com"
      export GIT_AUTHOR_NAME="Peter McEvoy"
      export GIT_COMMITTER_EMAIL="git@mcevoypeter.com"
      export GIT_COMMITTER_NAME="Peter McEvoy"
      export GNUPGHOME="$HOME/.gnupg/trezor"
      export KEYTIMEOUT=1

      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

      export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"
      export TERM="tmux-256color"

      source $HOME/.elan/env
      export PATH="$HOME/.verus/verus:$PATH"
      export PATH="$HOME/.verus/verusfmt:$PATH"
    '';
  };
}
