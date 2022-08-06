#!/usr/bin/env bash
set -euo pipefail

DOTFILES=$(cd "$(dirname "$0")"; pwd)
readonly DOTFILES
pushd "$PWD"
cd

# config
mkdir -p .config

# shell
touch .hushlogin
mkdir -p bin
mkdir -p src
ln -s -f "$DOTFILES/.inputrc" .
ln -s -f "$DOTFILES/.profile" .

# bash
ln -s -f "$DOTFILES/.bash_profile" .
ln -s -f "$DOTFILES/.bashrc" .

# zsh
ln -s -f "$DOTFILES/.zprofile" .
ln -s -f "$DOTFILES/.zshrc" .

# ssh
mkdir -p .ssh
mkdir -p .ssh/config.d
ln -s -f "$DOTFILES/.ssh/config" .ssh

# editorconfig
ln -s -f "$DOTFILES/.editorconfig" .

# git
ln -s -f "$DOTFILES/.gitconfig" .
ln -s -f "$DOTFILES/.gitignore" .
ln -s -f "$DOTFILES/.gitmessage" .

# zgen
if [ ! -d "${HOME}/.zgen" ]
then
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

# xcode
if [ "$(uname)" == "Darwin" ] && [ ! "$(xcode-select -p 1>/dev/null;echo $?)" ]
then
  sudo xcode-select --install
fi

# homebrew
if [ "$(uname)" == "Darwin" ]
then
  if ! command -v brew > /dev/null
  then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  brew analytics off
  ln -s -f "$DOTFILES/.Brewfile" .
  brew bundle --no-upgrade --global || true
fi

# osx
if [ "$(uname)" == "Darwin" ]
then
  sudo -v

  # Save to disk (not to iCloud) by default
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

  # Disable Notification Center and remove the menu bar icon
  launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

  # Set language and text formats
  # Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
  # `Inches`, `en_GB` with `en_US`, and `true` with `false`.
  defaults write NSGlobalDomain AppleLanguages -array "en" "au"
  defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
  defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
  defaults write NSGlobalDomain AppleMetricUnits -bool true

  # Save screenshots to the desktop
  defaults write com.apple.screencapture location -string "${HOME}/Desktop"

  # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
  defaults write com.apple.screencapture type -string "png"

  # Keep folders on top when sorting by name
  defaults write com.apple.finder _FXSortFoldersFirst -bool true

  # Disable the warning when changing a file extension
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  # Enable snap-to-grid for icons on the desktop and in other icon views
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

  # Increase grid spacing for icons on the desktop and in other icon views
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

  # Set the size of icons on the desktop and in other icon views
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 48" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 48" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 48" ~/Library/Preferences/com.apple.finder.plist

  # Use list view in all Finder windows by default
  # Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
  defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

  # Don’t automatically rearrange Spaces based on most recent use
  defaults write com.apple.dock mru-spaces -bool false

  # Automatically hide and show the Dock
  defaults write com.apple.dock autohide -bool true

  # Make Dock icons of hidden applications translucent
  defaults write com.apple.dock showhidden -bool true

  # Don’t show recent applications in Dock
  defaults write com.apple.dock show-recents -bool false

  # Top right screen corner → Desktop
  defaults write com.apple.dock wvous-tr-corner -int 4
  defaults write com.apple.dock wvous-tr-modifier -int 0
  # Bottom left screen corner → Start screen saver
  defaults write com.apple.dock wvous-bl-corner -int 5
  defaults write com.apple.dock wvous-bl-modifier -int 0

  # Privacy: don’t send search queries to Apple
  defaults write com.apple.Safari UniversalSearchEnabled -bool false
  defaults write com.apple.Safari SuppressSearchSuggestions -bool true

  # Show the full URL in the address bar (note: this still hides the scheme)
  defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

  # Set Safari’s home page to `about:blank` for faster loading
  defaults write com.apple.Safari HomePage -string "about:blank"

  # Enable Safari’s debug menu
  defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

  # Enable the Develop menu and the Web Inspector in Safari
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

  # Enable “Do Not Track”
  defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

  # Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
  defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

  # Display emails in threaded mode, sorted by date (oldest at the top)
  defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
  defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
  defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

  # Disable inline attachments (just show the icons)
  defaults write com.apple.mail DisableInlineAttachmentViewing -bool true


  # Only use UTF-8 in Terminal.app
  defaults write com.apple.terminal StringEncodings -array 4

  # Disable the annoying line marks
  defaults write com.apple.Terminal ShowLineMarks -int 0

  for app in "cfprefsd" \
    "Dock" \
    "Finder" \
    "Mail" \
    "Messages" \
    "Safari" \
    "SystemUIServer" \
    "Terminal"; do
    killall "${app}" &> /dev/null
  done
fi

popd
