Red [
	Title: "fill-column-with-10-percent.red"
	Needs: View
	Comment: "Generated with Direct Code"
]

do setup: [
	do %../table-template.red
]

;Direct Code VID Code source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
fill-column-with-10-percent-layout: [
	title "Setting Discounts with a button"
	bg-panel: panel gray [ 
		table1: table 500x200 data %fill-column-with-10-percent.redtbl
	]
	return
	button1: button "Set Discount to 10%" 
		on-click [
			foreach row table1/row-index [
				if row <> table1/frozen/y [ ;-- ignore the frozen header
					table1/actors/set-data table1 "discount" row 10%
				]
			]
			table1/actors/refresh-view table1 
		]
]

;Direct Code Show Window source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
do show-window: [
	view fill-column-with-10-percent-layout
]