{ username, ... }:

{
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
      minimize-to-application = true;
      mru-spaces = false;
      show-recents = false;
      tilesize = 48;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
    };

    loginwindow.GuestEnabled = false;

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
      "com.apple.swipescrolldirection" = false;
    };

    screencapture = {
      location = "~/Screenshots";
      type = "png";
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
    };
  };

  # Primary user for system defaults and homebrew
  system.primaryUser = username;

  # Determinate Nix manages the nix installation, so disable nix-darwin's management
  nix.enable = false;
  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads nix-darwin env
  programs.zsh.enable = true;

  # LaunchAgents
  launchd.user.agents.sweep-screenshots = {
    command = "/Users/${username}/.local/bin/sweep";
    serviceConfig = {
      StartCalendarInterval = [{ Hour = 9; Minute = 0; }];
      StandardOutPath = "/tmp/sweep-screenshots.log";
      StandardErrorPath = "/tmp/sweep-screenshots.err";
    };
  };

  # Used for backwards compatibility
  system.stateVersion = 5;
}
