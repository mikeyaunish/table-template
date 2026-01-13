Red [
	Title: "table-internals.red"
	Needs: View
	Comment: "Generated with Direct Code"
]

do setup: [
	block-to-table: func [s [block!] /local series heading blk keep-blk ndx][
	    series: copy s
	    heading: first copy/part series 1
	    return collect [
	        foreach blk (skip series 1) [
	            keep-blk: copy []
	            repeat ndx (length? heading) [
	                append keep-blk reduce [
	                    heading/:ndx
	                    case [
	                        none? blk/:ndx ["none"]
	                        blk/:ndx = false ["false"]
	                        true [blk/:ndx]
	                    ]
	                ]
	            ]
	            keep/only keep-blk
	        ]
	    ]
	]	
]

;Direct Code VID Code source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
table-internals-layout: [
	Title "Table Template Internals"
	style button-plain: button
	style group-box-plain: group-box "group-box1"
	space 2x2
	heading: text " table-template Internals" 268x34 115.201.25.0 center 
		font-size 16
	return
	group-box-plain3: group-box-plain "Overlay Libraries and Configuration" 
		[
			button-plain5: button-plain "vid-lib" 112x24 
				on-click [
					?? table-obj/vid-lib
				]
			button-plain6: button-plain "code-lib" 112x24 
				on-click [
					?? table-obj/code-lib
				]
			return
			button-plain7: button-plain "overlay-config" 239x26 
				on-click [
					?? table-obj/overlay-config
				]
		]
	return
	group-box-plain4: group-box-plain "Overlays" 
		[
			button-plain11: button-plain "vid-overlays" 239x26 
				on-click [
					?? table-obj/vid-overlays
				]
			return
			button-plain10: button-plain "code-overlays" 239x26 
				on-click [
					?? table-obj/code-overlays
				]
		]
	return
	group-box-plain2: group-box-plain "Virtual Configurations" 
		[
			button-plain8: button-plain "virtual-cols" 155x24 
				on-click [
					?? table-obj/virtual-cols
				]
			button-plain9: button-plain "vid-state" 71x24 
				on-click [
					vid-state: to-block table-obj/vid-state
					sort/skip vid-state 2
					?? vid-state
				]
		]
	return
	group-box-plain5: group-box-plain "Table Configuration" 
		[
			button-plain3: button-plain "table-state" 239x26
			 
				on-click [
					print [
						"table-state:"
						mold table-obj/actors/get-table-state table-obj
					]
				]
			return
			button-plain4: button-plain "table-details" 239x26 
				on-click [
					table-details table-obj
				]
		]
	return
	group-box-plain1: group-box-plain "Table Data" 275x100 
		[
			button-plain1: button-plain 239x26 "Formatted" 
				on-click [
					print-table/name (block-to-table copy/deep table-obj/table-data) "table-obj/table-data"
				]
			return
			button-plain2: button-plain 239x26 "Raw" 
				on-click [
					?? table-obj/table-data
				]
		]
]

;Direct Code Show Window source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
do show-window: [
	view/options table-internals-layout [offset: 953x0]
]