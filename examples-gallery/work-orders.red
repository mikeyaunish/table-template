Red [
	Title: "work-orders.red"
	Needs: View
	Comment: "Generated with Direct Code"
]

do setup: [
	do %../table-template.red
	print-order: function [ row-data [block!] ] [ 
		print "=========================================="
		print [ "Work Order Ticket Number: " row-data/1 ]
		print [ "Work Order Creation Time: " row-data/8 ] 
		print [ "                  Status: " either row-data/10 [ "Done" ] [ "Incomplete" ] ]
		print "------------------------------------------"
		print [ "    Description: " row-data/2 ] 
		print [ "       Priority: " row-data/7 ] 
		print [ "Estimated Hours: " row-data/3 ]
		print [ "    Hourly Rate: " to-valid-money row-data/4 ]
		print   "                   ------"
		print [ "          Total: " row-data/5 ] 
	]	
]

;Direct Code VID Code source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
work-orders-layout: [
	title "Work Orders Example"
	style table-using-data-file: panel "panel1" 128.128.128
	table-using-data-file1: table-using-data-file [
    origin 2x2 table1: table 1040x300
    data %/E/red/direct-code/experiments/table-template/examples-gallery/work-orders.redtbl
]
	return
	button1: button "Print Work Orders Selected" 
		on-click [
			rows-selected: table1/actors/get-checked-rows table1 "orders-selected"
			foreach row rows-selected [ print-order row ]
		]
]

;Direct Code Show Window source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
do show-window: [
	view work-orders-layout
]