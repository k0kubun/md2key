-- First argument - slides count
on run argv
  set slidesCount to item 1 of argv as number

  tell application "Keynote"
    set theSlides to slides of the front document

    set i to slidesCount
    repeat with s in theSlides
      if i > 2 then
        delete slide i of the front document
      end if

      set i to i - 1
    end repeat
  end tell
end run
