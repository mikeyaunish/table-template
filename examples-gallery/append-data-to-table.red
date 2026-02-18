Red [
	Title: "append-data-to-table.red"
	Needs: View
	Comment: "Generated with Direct Code"
]

do setup: [
	do %../table-template.red
]

;Direct Code VID Code source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
append-data-to-table-layout: [
	bg-panel: panel 128.128.128
		[
			origin 2x2
			table1: table 500x200 
				data %append-data-to-table.redtbl
		]
	return
	button1: button "Append Data To Table" 
		on-click [
			table1/actors/append-row table1
			table1/actors/set-data/row/refresh table1 1 (last table1/row-index) reduce [ "Paul" "Brooker" (random 100) "Blue" ]
		]
]

;Direct Code Show Window source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
do show-window: [
	view append-data-to-table-layout
]