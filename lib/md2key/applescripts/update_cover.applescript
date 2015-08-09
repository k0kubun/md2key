-- First argument - title
-- Second argument - sub
on run argv
  tell application "Keynote"
    set COVER_SLIDE_INDEX to 1

    tell the front document
      tell slide COVER_SLIDE_INDEX
        set object text of default title item to first item of argv
        set object text of default body item to second item of argv
      end tell
    end tell
  end tell
end run
