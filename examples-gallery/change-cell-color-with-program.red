Red [
	Title: "change-cell-color-with-program.red"
	Needs: View
	Comment: "Generated with Direct Code"
]

do setup: [

]

;Direct Code VID Code source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
change-cell-color-with-program-layout: [
	title "Change Cell Color"
	tbl-bg: panel 128.128.128
		[
			origin 2x2
			ccc-tbl: table 300x200 
				data %change-cell-color-with-program.redtbl
				extra [ green-value: $40000 ]
		]
	return
	button1: button "Green value $60,000" [ 
		ccc-tbl/extra/green-value: 60000
		ccc-tbl/actors/refresh-view ccc-tbl
	]
	button1: button "Green value $20,000" [ 
		ccc-tbl/extra/green-value: 20000
		ccc-tbl/actors/refresh-view ccc-tbl
	]	
]

;Direct Code Show Window source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
do show-window: [
	view change-cell-color-with-program-layout
]