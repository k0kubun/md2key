on run argv
  set lastIndex to item 1 of argv as number
  set theImage  to item 2 of argv as POSIX file

  tell application "Keynote"
    tell the front document
      set TEMPLATE_SLIDE_INDEX to 2

      set theSlide to slide lastIndex
      set docWidth to its width
      set docHeight to its height

      -- Create temporary slide to fix the image size
      tell slide TEMPLATE_SLIDE_INDEX
        set imgFile to make new image with properties { file: theImage, width: docWidth / 3 }
        tell imgFile
          set imgWidth to its width
          set imgHeight to its width
        end tell
      end tell

      tell theSlide
        make new image with properties { file: theImage, width: imgWidth, position: { docWidth - imgWidth - 60, docHeight / 2 - imgHeight / 2 } }
      end tell
    end tell
  end tell
end run
