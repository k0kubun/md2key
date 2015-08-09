on run argv
  set slidesCount to item 1 of argv as number

  tell application "Keynote"
    tell the front document
      set i to slidesCount

      repeat with s in slides
        if i > 2 then
          delete slide i
        end if

        set i to i - 1
      end repeat
    end tell
  end tell
end run
