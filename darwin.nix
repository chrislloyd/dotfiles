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
      "caffeine"
      "claude"
      "discord"
      "dropbox"
      "ghostty"
      "godot"
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

    menuExtraClock = {
      ShowAMPM = true;
      ShowDayOfWeek = true;
      ShowDate = 0;  # 0 = never, 1 = always, 2 = when space allows
    };

    CustomUserPreferences = {
      "com.apple.Safari" = {
        IncludeInternalDebugMenu = 1;
        IncludeDevelopMenu = 1;
        WebKitDeveloperExtrasEnabledPreferenceKey = 1;
        "WebKitPreferences.developerExtrasEnabled" = 1;
        ShowFullURLInSmartSearchField = 1;
        ShowOverlayStatusBar = 0;
        "ShowFavoritesBar-v2" = 0;
        AutoFillCreditCardData = 0;
        AutoFillFromAddressBook = 0;
        AutoFillFromiCloudKeychain = 0;
        AutoFillMiscellaneousForms = 0;
      };

      "com.apple.finder" = {
        FXPreferredViewStyle = "clmv";  # column view
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
      };

      # Hot corners. Codes: 4=desktop, 5=screen saver start, 14=quick note
      "com.apple.dock" = {
        "wvous-tr-corner" = 4;
        "wvous-tr-modifier" = 0;
        "wvous-bl-corner" = 5;
        "wvous-bl-modifier" = 0;
        "wvous-br-corner" = 14;
        "wvous-br-modifier" = 0;
      };
    };
  };

  # Primary user for system defaults and homebrew
  system.primaryUser = username;

  # Determinate Nix manages the nix installation, so disable nix-darwin's management
  nix.enable = false;
  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads nix-darwin env
  programs.zsh.enable = true;

  # TouchID for sudo — makes `rebuild` painless, also survives system updates
  security.pam.services.sudo_local.touchIdAuth = true;

  # LaunchAgents
  launchd.user.agents.sweep-screenshots = {
    command = "/Users/${username}/.local/bin/sweep";
    serviceConfig = {
      StartCalendarInterval = [{ Hour = 9; Minute = 0; }];
      StandardOutPath = "/tmp/sweep-screenshots.log";
      StandardErrorPath = "/tmp/sweep-screenshots.err";
    };
  };

  launchd.user.agents.ingest-notes = {
    command = "/Users/${username}/.local/bin/ingest-notes";
    serviceConfig = {
      WatchPaths = [
        "/Users/${username}/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes/📥 Inbox.md"
      ];
      StandardOutPath = "/tmp/ingest-notes.log";
      StandardErrorPath = "/tmp/ingest-notes.err";
    };
  };

  # Auto-rebuild when dotfiles change. Runs as root via launchd daemon so no sudo prompt.
  launchd.daemons.dotfiles-autorebuild = {
    command = "/run/current-system/sw/bin/darwin-rebuild switch --flake /Users/${username}/dotfiles#$(hostname -s)";
    serviceConfig = {
      WatchPaths = [
        "/Users/${username}/dotfiles/flake.nix"
        "/Users/${username}/dotfiles/flake.lock"
        "/Users/${username}/dotfiles/darwin.nix"
        "/Users/${username}/dotfiles/home.nix"
      ];
      ThrottleInterval = 30;
      StandardOutPath = "/tmp/dotfiles-autorebuild.log";
      StandardErrorPath = "/tmp/dotfiles-autorebuild.err";
    };
  };

  launchd.user.agents.journal-canvas = {
    command = "/Users/${username}/.local/bin/journal-canvas";
    serviceConfig = {
      WatchPaths = [
        "/Users/${username}/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes/Journal"
      ];
      StandardOutPath = "/tmp/journal-canvas.log";
      StandardErrorPath = "/tmp/journal-canvas.err";
    };
  };

  # Used for backwards compatibility
  system.stateVersion = 5;
}
