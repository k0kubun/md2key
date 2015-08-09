on run argv
  set lastIndex to item 1 of argv as number
  set theImage  to item 2 of argv as POSIX file

  tell application "Keynote"
    tell the front document
      set docWidth to its width
      set docHeight to its height

      tell slide lastIndex
        make new image with properties { opacity: 80, file: theImage, width: docWidth - 180, position: { 90, 240 } }
      end tell
    end tell
  end tell
end run
