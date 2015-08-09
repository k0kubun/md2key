on run argv
	tell application "Keynote"
		activate
		set TEMPLATE_SLIDE_INDEX to 2
		tell the front document
			move slide TEMPLATE_SLIDE_INDEX to before slide TEMPLATE_SLIDE_INDEX
		end tell
	end tell
end run