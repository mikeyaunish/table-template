Red [
	Title: "vid-object-address.red"
	Needs: View
	Comment: "Generated with Direct Code"
]

do setup: [
	do %../table-template.red
]

;Direct Code VID Code source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
vid-object-address-layout: [
	title "VID Object Addresses"
	table1: table 500x200 data %vid-object-address.redtbl
]

;Direct Code Show Window source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
do show-window: [
	view vid-object-address-layout
]