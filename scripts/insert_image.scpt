on run argv
  set lastIndex     to item 1 of argv as number
  set theImage      to item 2 of argv as POSIX file
  set templateIndex to item 3 of argv as number

  tell application "Keynote"
    tell the front document
      set docWidth to its width
      set docHeight to its height

      -- Create temporary slide to fix the image size
      tell slide templateIndex
        set imgFile to make new image with properties { file: theImage, width: docWidth / 3 }
        tell imgFile
          set imgWidth to its width
          set imgHeight to its width
        end tell
      end tell

      tell slide lastIndex
        make new image with properties { file: theImage, width: imgWidth, position: { docWidth - imgWidth - 60, docHeight / 2 - imgHeight / 2 } }
      end tell
    end tell
  end tell
end run
