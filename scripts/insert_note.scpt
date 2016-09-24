on run argv
  set lastIndex     to item 1 of argv as number
  set theNote    to item 2 of argv

  tell application "Keynote"
    tell the front document
      tell slide lastIndex
        set presenter notes to theNote
      end tell
    end tell
  end tell
end run
