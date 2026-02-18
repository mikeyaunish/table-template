Red [
	Title: "capturing-data-changes.red"
	Needs: View
	Comment: "Generated with Direct Code"
]

do setup: [
	do %../table-template.red
]

;Direct Code VID Code source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
capturing-data-changes-layout: [
	title "'on-change data monitoring"
	table1: table 550x200 data [
	       ["Change" "Any" "of" "this" "data" ]
	       ["to" "see" "what" "happens" "now."]
	] 
	on-change [	
	  print rejoin [	
		" on-change state = " mold face/change-state 
		" at = " mold face/active 
		" cell value = " mold table1/actors/get-data table1 face/active/x face/active/y  
	  ]
	]
]

;Direct Code Show Window source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
do show-window: [
	view capturing-data-changes-layout
]