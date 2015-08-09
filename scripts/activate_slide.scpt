on run argv
  set slideIndex to item 1 of argv as number

  tell application "Keynote"
    -- This can't be removed because using Cmd-v to paste.
    activate

    tell the front document
      -- Workaround to focus on specified slide.
      move slide slideIndex to before slide slideIndex
    end tell
  end tell
end run
