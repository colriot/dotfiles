#!/usr/bin/env bash

# More info about Defaults: https://pawelgrzybek.com/change-macos-user-preferences-via-command-line/
# Flow
# 1. `defaults read > before`  Save a state before a change.
# 2.                           Make a change through GUI.
# 3. `defaults read > after`   Save a state after a change.
# 4. `diff before after`       Find the difference.

# Key Modifiers:
# None:  0
# Shift: 131072
# Ctrl:  262144
# Opt:   524288
# Cmd:  1048576


# System Preferences > Keyboard > Keyboard
defaults write NSGlobalDomain KeyRepeat -int 1 # normal minimum is 2 (30 ms)
# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

# System Preferences > Keyboard > Keyboard
defaults write NSGlobalDomain InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)

# Use F1, F2, etc. keys by default on external keyboard
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# System Preferences > Keyboard > Shortcuts
# Enable Input Source switch on `Cmd + Space`
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "{enabled = 1; value = { parameters = (32, 49, 1048576); type = 'standard'; }; }"
# Disable Spotlight search on `Cmd + Space` and `Opt + Cmd + Space`
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "{enabled = 0; value = { parameters = (32, 49, 1048576); type = 'standard'; }; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "{enabled = 0; value = { parameters = (32, 49, 1572864); type = 'standard'; }; }"


# Trackpad

# System Preferences > Trackpad > Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# System Preferences > Accessibility > Pointer Control > Trackpad Options...
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# System Preferences > Accessibility > Zoom > Use scroll gesture with modifier keys to zoom (Control)
# Ctrl:  262144
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.AppleMultitouchTrackpad HIDScrollZoomModifierMask -int 262144
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad HIDScrollZoomModifierMask -int 262144

# Finder > Preferences > Advanced

# Finder > Preferences > Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Keep Folders sorted on top
defaults write com.apple.finder _FXSortFoldersFirst --bool true

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder > View > As Columns
# Four-letter codes for the view modes: `icnv`, `Nlsv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Finder > View > Show Path Bar
defaults write com.apple.finder ShowPathbar -bool true

# System Preferences > General > Show scroll bars > Always
# defaults write com.apple.Terminal AppleShowScrollBars -string Always


# Show the ~/Library folder
chflags nohidden ~/Library

# System Preferences > Dock

# Position on screen: right
defaults write com.apple.dock orientation right

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Make Hidden App Icons Translucent in the Dock
# ?????
defaults write com.apple.dock showhidden -bool YES

# System Preferences > Mission Control > Hot Corners...

# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
#
# Modifiers:
# None:  0
# Shift: 131072
# Ctrl:  262144
# Opt:   524288
# Cmd:  1048576

# TopRight hot corner → Show Desktop
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0
# BottomRight hot corner → Lock Screen
defaults write com.apple.dock wvous-br-corner -int 13
defaults write com.apple.dock wvous-br-modifier -int 0


# Enable Continuous Spellchecking and Disabled Auto-correct
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

# iTerm2 hide from Dock
# defaults write /Applications/iTerm.app/Contents/Info LSUIElement true 

# defaults write /Applications/iTerm\ Dropdown\ Console.app/Contents/Info CFBundleName "iTerm Dropdown Console"


# Remove apps I don't use from the dock.
for shortcut_label in "Launchpad" "Safari" "Messages" "Mail" \
     "Maps" "FaceTime" "Calendar" "Contacts" "TV" "Music" \
     "Podcasts" "News" "App Store" "System Preferences"; do
    dockutil --remove "${shortcut_label}" --allhomes
done

# Kill affected apps
for app in "Dock" "Finder"; do
  killall "${app}" > /dev/null 2>&1
done

# Done
echo "Done. Note that some of these changes require a logout/restart to take effect."
