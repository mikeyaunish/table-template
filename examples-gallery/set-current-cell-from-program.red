Red [
	Title: "set-current-cell-from-program.red"
	Needs: View
	Comment: "Generated with Direct Code"
]

do setup: [

]

;Direct Code VID Code source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
set-current-cell-from-program-layout: [
	table-bg: panel 128.128.128 
		[
			origin 4x4
			tbl-1: table 200x200 
				data %set-current-cell-from-program.redtbl
		]
	return
	button-plain1: button "Change Current Cell to 'Frank'" 
		on-click [
			tbl-1/actors/set-data/refresh tbl-1 tbl-1/active/x tbl-1/active/y "Frank"
		]
]

;Direct Code Show Window source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
do show-window: [
	view set-current-cell-from-program-layout
]