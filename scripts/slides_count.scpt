tell application "Keynote"
  set n to 0
  set theSlides to slides of the front document
  repeat with theSlide in theSlides
    set n to n + 1
  end repeat
  do shell script "echo " & n
end tell
