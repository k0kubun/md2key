on run argv
  set slideTitle to item 1 of argv
  set slideBody  to item 2 of argv

  tell application "Keynote"
    tell the front document
      -- Workaround to select correct master slide. In spite of master slide can be selected by name,
      -- name property is not limited to be unique.
      -- So move the focus to second slide and force "make new slide" to use the exact master slide.
      set TEMPLATE_SLIDE_INDEX to 2
      move slide TEMPLATE_SLIDE_INDEX to before slide TEMPLATE_SLIDE_INDEX

      set newSlide to make new slide
      tell newSlide
        set object text of default title item to slideTitle
        set object text of default body item to slideBody
      end tell
    end tell
  end tell
end run
