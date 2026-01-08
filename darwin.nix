{ pkgs, ... }:

{
  # System packages (available to all users)
  environment.systemPackages = with pkgs; [
    git
    ripgrep
    fd
    jq
    bat
    tree
  ];

  # Homebrew integration for casks and Mac App Store apps
  # Nix can't install these directly, so we manage Homebrew declaratively
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";  # Remove unlisted packages
      autoUpdate = true;
    };

    taps = [];

    brews = [
      # CLI tools that aren't in nixpkgs or work better via Homebrew
    ];

    casks = [
      "1password"
      "1password-cli"
      "claude"
      "discord"
      "dropbox"
      "ghostty"
      "netnewswire"
      "obsidian"
      "visual-studio-code"
      "zed"
    ];

    masApps = {
      # "App Name" = App Store ID;
      # You can find IDs with: mas search "App Name"
      "Xcode" = 497799835;
      "Slack" = 803453959;
      "Things" = 904280696;
    };
  };

  # macOS system defaults (replaces your macos.sh)
  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;  # Don't rearrange spaces based on recent use
      show-recents = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      _FXShowPosixPathInTitle = true;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      "com.apple.swipescrolldirection" = false;  # Natural scrolling off
    };

    screencapture = {
      location = "~/Screenshots";
      type = "png";
    };
  };

  # Primary user for system defaults and homebrew
  system.primaryUser = "chrislloyd";

  # Determinate Nix manages the nix installation, so disable nix-darwin's management
  nix.enable = false;
  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads nix-darwin env
  programs.zsh.enable = true;

  # LaunchAgents
  launchd.user.agents.sweep-screenshots = {
    command = "/Users/chrislloyd/dotfiles/bin/sweep";
    serviceConfig = {
      StartCalendarInterval = [{ Hour = 9; Minute = 0; }];
      StandardOutPath = "/tmp/sweep-screenshots.log";
      StandardErrorPath = "/tmp/sweep-screenshots.err";
    };
  };

  # Used for backwards compatibility
  system.stateVersion = 5;
}
