Red [
	Title: "table-CRUD-actors.red"
	Needs: View
	Comment: "Generated with Direct Code"
]

do setup: [
	do %../table-template.red
]

;Direct Code VID Code source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
table-CRUD-actors-layout: [
	title "table template CRUD Actors"
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
        on-key [
            if event/key = #"^K" [
                do face/text
            ]
            if all [ 
            	event/key = #"^O" 
            	find event/flags 'control 
            ][
                editor face/extra/save-filename
            ]
        ]
        rate 00:00:00.25 
        on-time [
            if not face/extra/has-focus? [
                current-data: read face/extra/save-filename
                if current-data <> face/text [
                    face/text: current-data
                    do face/text 
                ]
            ]
        ] 
        on-focus [face/extra/has-focus?: true] 
        on-unfocus [
            write face/extra/save-filename face/text
            face/extra/has-focus?: false
        ]
	style ffc-run-button: button
	style text-for-inline-label: text "Label Text:" 230.230.230 font-color 0.0.0 right middle
	style table-using-data-file: panel "panel1" 128.128.128
	space 2x2
	t1: text font-size 12 "table1" 504x23 164.200.255 center underline
	return
	bg-panel: panel 128.128.128
		[
			origin 2x2
			table1: table 500x200 
				data %table-actors.redtbl
		]
	return 
	return 
	t2: text font-size 12 "table1 CRUD actors" 704x23 164.200.255 center underline
	return 
	table-using-data-file1: table-using-data-file [
    	origin 2x2 
    	table3: table 700x300 options [auto-save: true]
    		data %table-actors-actions.redtbl
]
]

;Direct Code Show Window source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
do show-window: [
	view table-CRUD-actors-layout
]