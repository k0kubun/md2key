on run argv
  tell application "Keynote"
    activate

    tell the front document
      set n to 0
      repeat with s in slides
        set n to n + 1
      end repeat

      move slide n to before slide n
    end tell
  end tell
end run
