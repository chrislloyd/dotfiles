{ pkgs, lib, ... }:

{
  home.stateVersion = "24.05";
  home.username = "chrislloyd";
  home.homeDirectory = "/Users/chrislloyd";

  # --
  # Packages

  home.packages = with pkgs; [
    htop
    wget
    shellcheck
    imagemagick
    graphviz
    rename
  ];

  # --
  # Environment variables

  home.sessionVariables = {
    EDITOR = "code -w";
    OBSIDIAN_VAULT_ID = "69f2a33bbeb12d4b";
    NVM_DIR = "$HOME/.nvm";
    DENO_INSTALL_ROOT = "$HOME/.deno";

    # Homebrew compiler flags
    CPATH = "/opt/homebrew/include";
    LDFLAGS = "-L/opt/homebrew/lib";
    CPPFLAGS = "-I/opt/homebrew/include";
    LIBRARY_PATH = "/opt/homebrew/lib";
  };

  home.sessionPath = [
    "$HOME/dotfiles/bin"
    "$HOME/.local/bin"
    "$HOME/.deno/bin"
    "$HOME/Library/Python/3.12/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  # --
  # Zsh

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;

    history = {
      size = 5000;
      save = 5000;
      ignoreDups = true;
      expireDuplicatesFirst = true;
      share = true;
      extended = true;
    };

    historySubstringSearch.enable = true;

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
    };

    initContent = lib.mkMerge [
      # Early init (before compinit)
      (lib.mkOrder 500 ''
        setopt CORRECT
        setopt EXTENDED_GLOB
        setopt MAILWARN
        setopt PROMPT_SUBST
        setopt interactive_comments
      '')

      # Main init (high priority to run after other configs)
      (lib.mkOrder 2000 ''
        # Prompt
        PS1='%F{240}%2~%f %(?.%F{240}.%F{red})%#%f '

        # Quick jump to code directory
        s() {
          cd ~/code/"$1" || return
        }

        # Quick jump to Desktop
        d() {
          cd ~/Desktop/"$1" || return
        }

        # Jump to Obsidian vault
        vault() {
          _path=$(jq ".vaults.\"$OBSIDIAN_VAULT_ID\".path" --raw-output < "$HOME/Library/Application Support/obsidian/obsidian.json")
          cd "$_path" || return
        }

        # nvm
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

        # cargo
        [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

        # bun
        [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

        # ghcup
        [ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"
      '')
    ];
  };

  # --
  # Bash

  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" "ignorespace" ];
    historySize = 1000;
    historyFileSize = 2000;

    shellOptions = [
      "cdspell"
      "extglob"
      "histappend"
      "hostcomplete"
      "interactive_comments"
      "no_empty_cmd_completion"
      "checkwinsize"
    ];

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
    };

    initExtra = ''
      # Prompt
      PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '

      # Color support
      if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'
      fi

      # Functions
      s() {
        cd ~/code/"$1" || return
      }

      d() {
        cd ~/Desktop/"$1" || return
      }

      vault() {
        _path=$(jq ".vaults.\"$OBSIDIAN_VAULT_ID\".path" --raw-output < "$HOME/Library/Application Support/obsidian/obsidian.json")
        cd "$_path" || return
      }

      # cargo
      [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

      # nvm
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

      # ghcup
      [ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"
    '';
  };

  # --
  # Readline

  programs.readline = {
    enable = true;
    variables = {
      bell-style = "none";
      completion-query-items = 200;
      mark-symlinked-directories = true;
      match-hidden-files = false;
      skip-completed-text = true;
      visible-stats = true;
      input-meta = true;
      output-meta = true;
      convert-meta = false;
    };
    bindings = {
      "\\C-d" = "possible-completions";
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";
      "\\e[1;5D" = "backward-word";
      "\\e[1;5C" = "forward-word";
    };
  };

  # --
  # Git

  programs.git = {
    enable = true;

    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPGNaRxppN+ku/wiAlyojRGYEEagsZT3uFMyPF1ivpgk";
      signByDefault = true;
    };

    ignores = [
      ".DS_Store"
      ".#*"
      "\\#*\\#"
      "*~*"
      ".jj"
      ".claude"
    ];

    settings = {
      user.name = "Chris Lloyd";
      # user.email = "your@email.com";  # Set this!

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      rebase.autoStash = true;

      gpg = {
        format = "ssh";
        ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      };

      core = {
        editor = "code -w";
      };

      alias = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        lg = "log --oneline --graph --decorate";
      };
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  # --
  # SSH

  programs.ssh = {
    enable = true;
    includes = [ "config.d/*" ];
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
      extraOptions = {
        UseKeychain = "yes";
        IdentityAgent = "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
      };
    };
  };

  # --
  # Atuin shell history

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      style = "compact";
      inline_height = 10;
    };
  };

  # --
  # Other tools

  programs.bat = {
    enable = true;
    config = {
      theme = "GitHub";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # --
  # Emacs

  programs.emacs = {
    enable = true;
    extraConfig = builtins.readFile ./config/emacs/init.el;
  };

  # --
  # Dotfiles

  home.file = {
    # Editorconfig
    ".editorconfig".text = ''
      root = true

      [*]
      indent_style = space
      tab_width = 2

      [*.gitconfig]
      tab_width = 8
    '';

    # SSH config.d directory
    ".ssh/config.d/.keep".text = "";

    # Allowed signers for git signature verification
    ".ssh/allowed_signers".text = "chris@chrislloyd.net ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPGNaRxppN+ku/wiAlyojRGYEEagsZT3uFMyPF1ivpgk";

    # Custom scripts
    ".local/bin" = {
      source = ./bin;
      recursive = true;
    };

    # Zed editor
    ".config/zed/settings.json".source = ./config/zed/settings.json;

    # Claude Code
    ".claude/CLAUDE.md".source = ./config/claude/CLAUDE.md;
  };
}
