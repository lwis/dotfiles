if test "$(uname)" = "Darwin"
then
    # Sets reasonable OS X defaults.
    #
    # Or, in other words, set shit how I like in OS X.
    #
    # The original idea (and a couple settings) were grabbed from:
    #   https://github.com/mathiasbynens/dotfiles/blob/master/.osx
    #
    # Run ./set-defaults.sh and you'll be good to go.

    # Disable mouse acceleration.
    defaults write .GlobalPreferences com.apple.mouse.scaling -1

    # Disable press-and-hold for keys in favor of key repeat.
    defaults write -g ApplePressAndHoldEnabled -bool false

    # Use AirDrop over every interface. srsly this should be a default.
    defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

    # Always open everything in Finder's list view. This is important.
    defaults write com.apple.Finder FXPreferredViewStyle Nlsv

    # Show the ~/Library folder.
    chflags nohidden ~/Library

    # Set a blazingly fast keyboard repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 1
    defaults write NSGlobalDomain InitialKeyRepeat -int 10

    # Set the Finder prefs for showing a few different volumes on the Desktop.
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

    # Hide Safari's bookmark bar.
    defaults write com.apple.Safari ShowFavoritesBar -bool false

    # Use plain text mode for new TextEdit documents
    defaults write com.apple.TextEdit RichText -int 0
    # Open and save files as UTF-8 in TextEdit
    defaults write com.apple.TextEdit PlainTextEncoding -int 4
    defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

    # Enable the debug menu in Disk Utility
    defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
    defaults write com.apple.DiskUtility advanced-image-options -bool true

    # Prevent Time Machine from prompting to use new hard drives as backup volume
    defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

    ###############################################################################
    # Photos                                                                      #
    ###############################################################################

    # Prevent Photos from opening automatically when devices are plugged in
    defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

    ###############################################################################
    # Mac App Store                                                               #
    ###############################################################################

    # Enable the automatic update check
    defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

    # Check for software updates daily, not just once per week
    defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

    # Download newly available updates in background
    defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
fi
