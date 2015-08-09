-- First argument - slides count
-- Second argument - POSIX path
on run argv
	tell application "Keynote"
		tell the front document
			set TEMPLATE_SLIDE_INDEX to 2

			set slideNumber to first item of argv as number
			set theSlide to slide slideNumber
			set theImage to second item of argv as POSIX file
			set docWidth to its width
			set docHeight to its height

			tell slide TEMPLATE_SLIDE_INDEX
				set imgFile to make new image with properties {file:theImage, width:docWidth / 3}
				tell imgFile
					set imgWidth to its width
					set imgHeight to its width
				end tell
			end tell

			tell theSlide
				make new image with properties {file:theImage, width:imgWidth, position:{docWidth - imgWidth - 60, docHeight / 2 - imgHeight / 2}}
			end tell
		end tell
	end tell
end run
