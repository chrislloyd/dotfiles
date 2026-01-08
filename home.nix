{ pkgs, username, email, ... }:

{
  home.stateVersion = "24.05";
  home.username = username;
  home.homeDirectory = "/Users/${username}";

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
    EDITOR = "zed -w";
    OBSIDIAN_VAULT_ID = "69f2a33bbeb12d4b";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  # Shared across all shells
  home.shellAliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    d = "cd ~/Desktop";
  };

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

    initContent = ''
      setopt CORRECT
      setopt EXTENDED_GLOB
      setopt MAILWARN
      setopt PROMPT_SUBST
      setopt interactive_comments

      PS1='%F{240}%2~%f %(?.%F{240}.%F{red})%#%f '
      source ~/.config/shell/functions.sh
    '';
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

    initExtra = ''
      PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '

      if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'
      fi

      source ~/.config/shell/functions.sh
    '';
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
      user.email = email;

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      rebase.autoStash = true;

      gpg = {
        format = "ssh";
        ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      };

      core.editor = "zed -w";

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
    ".editorconfig".source = ./config/editorconfig;
    ".ssh/config.d/.keep".text = "";
    ".ssh/allowed_signers".text = "chris@chrislloyd.net ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPGNaRxppN+ku/wiAlyojRGYEEagsZT3uFMyPF1ivpgk";

    ".local/bin" = {
      source = ./bin;
      recursive = true;
    };

    ".config/zed/settings.json".source = ./config/zed/settings.json;
    ".config/shell/functions.sh".source = ./config/shell/functions.sh;
    ".claude/CLAUDE.md".source = ./config/claude/CLAUDE.md;
  };
}
