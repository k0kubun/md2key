tell application "Keynote"
	set TEMPLATE_SLIDE_INDEX to 2
	          tell the front document
            delete slide TEMPLATE_SLIDE_INDEX
          end tell
end tell