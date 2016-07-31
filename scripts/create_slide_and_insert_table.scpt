on run argv
  set slideTitle    to item 1 of argv
  set templateIndex to item 2 of argv as number
  set rowCount      to item 3 of argv as number
  set columnCount   to item 4 of argv as number

  set headerRowCount   to 1
  set headerColumnCount to 0
  set footerRowCount to 0

  tell application "Keynote"
    set thisDocument to the front document
    tell thisDocument
      -- Workaround to select correct master slide. In spite of master slide can be selected by name,
      -- name property is not limited to be unique.
      -- So move the focus to second slide and force "make new slide" to use the exact master slide.
      move slide templateIndex to before slide templateIndex

      set newSlide to make new slide
      tell newSlide
        set base slide to master slide "Title - Top" of thisDocument
        set object text of default title item to slideTitle
        set newTable to make new table with properties {column count:columnCount, row count:rowCount, footer row count:footerRowCount,header column count:headerColumnCount,header row count:headerRowCount}
      end tell
    end tell
  end tell
end run
