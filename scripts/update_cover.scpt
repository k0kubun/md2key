on run argv
  set coverTitle to item 1 of argv
  set coverBody  to item 2 of argv

  tell application "Keynote"
    set COVER_SLIDE_INDEX to 1

    tell the front document
      tell slide COVER_SLIDE_INDEX
        set object text of default title item to coverTitle
        set object text of default body item to coverBody
      end tell
    end tell
  end tell
end run
