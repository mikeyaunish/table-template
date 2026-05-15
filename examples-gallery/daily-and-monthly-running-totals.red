Red [
	Title: "daily-and-monthly-running-totals.red"
	Needs: View
	Comment: "Generated with Direct Code"
]

do setup: [

]

;Direct Code VID Code source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
daily-and-monthly-running-totals-layout: [
	style table-using-data-file: panel "panel1" 128.128.128
	table-using-data-file1: table-using-data-file [
    origin 2x2 table2: table 365x505
    data %./daily-and-monthly-running-totals.redtbl
]
]

;Direct Code Show Window source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
do show-window: [
	view daily-and-monthly-running-totals-layout
]