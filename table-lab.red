Red [
	Title: "table-lab.red"
	Needs: View
	Comment: "Generated with Direct Code"
]

do setup: [
	if ( not system/view/vid/styles/table ) [ 
		do %table-template.red 
	]
	table-lab-current-path: current-path: system/options/path
	
	relative-filepath: function [
		source-filepath [file!]
		parent-filepath [file!]
	][
		src: to-string clean-path source-filepath
		replace src (to-string parent-filepath) ""
		return to-file rejoin [ "./" src ]
	]	
]

;Direct Code VID Code source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
table-lab-layout: [
	Title "Table Lab"
	style text-for-inline-label: text "Label Text:" 230.230.230 
		font-color 0.0.0 right middle
	style field-has-contents-saved: Field 80x23 
		extra [
			save-filename: %""
		] 
		on-create [
			if exists? face/extra/save-filename [
				face/text: read clean-path face/extra/save-filename
			]
		] 
		on-change [
			if face/extra/save-filename <> %"" [
				rel-filepath: relative-filepath to-file face/text table-lab-current-path
				write face/extra/save-filename to-string rel-filepath
			]
		]
	style button-plain: button
	style field-coder: Field 900x26 0.9.0.0 bold font-name "Consolas" font-size 13 font-color 0.255.0
        extra [
            save-filename:  %"" 
            has-focus?: #(false) 
        ] 
        on-create [
			either exists? face/extra/save-filename [
				face/text: read face/extra/save-filename
			][
				write face/extra/save-filename {print "Hello, World"}
			]			
        ] 
        on-change [
            if face/extra/save-filename <> %"" [
                write face/extra/save-filename face/text
            ]
        ]
        on-enter [
            do face/text 
        ]
        on-focus [face/extra/has-focus?: true] 
        on-unfocus [
            write face/extra/save-filename face/text
            face/extra/has-focus?: false
        ]
	style ffc-run-button: button
	space 1x2
	label1: text-for-inline-label "Data Filename:"
	data-filename: field-has-contents-saved 500x23 
		with [
			extra/save-filename: %vid-data-filename-field.txt
		]
	req-btn: button "..." 23x23 
		on-click [
			table1/actors/open-table table1
			data-filename/text: to-string relative-filepath to-file table1/data table-lab-current-path
		]
	load-blk-btn: button "Load Red Data Block"
		on-click [
			if req-res: request-multiline-text/size "Enter a fully formed Red block below, to be used to for your table data." 1200x400
				[
					result: load req-res 
					if block? result [
						data-filename/text: copy ""
						table1/data: none
						table1/actors/init/with table1 result
					]
				]
		]
	return
	save-btn: button "Save" 
		on-click [
			table1/actors/save-table table1
			if all [
				table1/data
				table1/data > %""
			] [
				data-filename/text: to-string table1/data
			]
		]
	save-btn1: button "Save As" 
		on-click [
			table1/actors/save-table-as table1
			if all [
				table1/data
				table1/data > %""
			] [
				data-filename/text: to-string relative-filepath table1/data table-lab-current-path
			]			
			
		]
	new-btn: button "New Table" 
		on-click [
			data-filename/text: copy ""
			table1/data: none
			table1/actors/init/with table1 [
				["id"] [1]
			]
		]
	add-col-btn: button "Add Column" 
		on-click [
			table1/actors/append-col table1
		]
	add-row-btn: button "Add Row" 
		on-click [
			table1/actors/append-row table1
		]
	pad 20x0
	button-plain1: button-plain "Table Config." font-color 55.176.64.0 bold 
		on-click [
			print-table-config table1
		]
	clip-btn: button "Show Clipboard" font-color 55.176.64.0 bold 
		on-click [
			print mold read-clipboard
		]
		clip-btn1: button "Table Internals" font-color 55.176.64.0 bold 
		on-click [do %table-internals.red]
	return
	table-backdrop: panel 128.128.128 
		[
			table1: table 900x295 
				on-create [
					if data-filename/text [
						if exists? to-file data-filename/text [
							face/data: to-file data-filename/text
						]
					]
				]
		]
	return 
	at 10x400 field-coder1: field-coder 885x26 with [extra/save-filename: rejoin [ table-lab-current-path %vid-field-coder.red] ] 
	space 0x0
	at 896x400 run-button1: ffc-run-button "RUN" 36x25 on-click [
	    do field-coder1/text
	]
	space 10x10
	return
]

;Direct Code Show Window source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
do show-window: [
	view/flags/options table-lab-layout [resize] [
		offset: 0x0
		actors: object [
			on-resizing: func [ face event ][
				table1/size: face/size - as-pair 40 124 
				table-backdrop/size: table1/size + 20x20 
				table1/actors/resize table1
				field-coder1/offset: as-pair 10 (face/size/y - 36)
				run-button1/offset: as-pair 896 (face/size/y - 36)
			]
			on-resize: func [face event][
				face/actors/on-resizing face event
			]			
		]	
	]
]