-- First argument - slides count
on run argv
	tell application "Keynote"
		set theSlides to slides of the front document
		set n to first item of argv as number

		repeat with theSlide in theSlides
			if n > 2 then
				delete slide n of the front document
			end if

			set n to n - 1
		end repeat
	end tell
end run
