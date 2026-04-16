Red [
	Title: "programmed-coloring.red"
	Needs: View
	Comment: "Generated with Direct Code"
]

do setup: [
	do %../table-template.red 
	over-priced: $100.00
]

;Direct Code VID Code source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
programmed-coloring-layout: [
	title "Programmable Cell Coloring"
	tbl-bg: panel 128.128.128 [
		origin 4x4
		table1: table 400x200 data %programmed-coloring.redtbl
	]
	return
	t1: text "over-priced limit:" 230.230.230 font-color 0.0.0 right middle
	field1: field  
		on-enter [
			over-priced: to-money face/text
			table1/actors/refresh-view table1
		]
		on-create [
			face/text: to-string over-priced
		]
	text1: text "<- Change value to see coloring" middle
	
]

;Direct Code Show Window source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
do show-window: [
	view programmed-coloring-layout
]