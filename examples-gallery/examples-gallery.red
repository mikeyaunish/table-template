Red [
	Title: "examples-gallery.red"
	Needs: View
	Comment: "Generated with Direct Code"
]

do setup: [
	do %../table-template.red 
	
	relative-filepath: function [
		{Returns a relative filepath}
		source-filepath [file!]
		parent-filepath [file!]
	][
		src: to-string clean-path source-filepath
		replace src (to-string parent-filepath) ""
		return to-file rejoin [ "./" src ]
	]
	
	to-relative-filename: function [
		filename [file!]
	][
		return relative-filepath filename system/options/path 
	]	
	
	view-source: function [ source [string!] ] [
		view [
			title "Red Source File Viewer" 
			area1: area 800x500 font-name "Consolas" font-size 10
				on-create [ area1/text: source ]
		]
	]	
]

;Direct Code VID Code source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
examples-gallery-layout: [
	title "Examples Gallery"
	style tab-panel-has-tab-position-saved: tab-panel
	    extra [
	    	save-filename: %""
	    	changed?: #(false)
	    ]
	    on-create [
			if exists? face/extra/save-filename [
				face/selected: load face/extra/save-filename
			]           	
	    ]
	    on-change [
	    	face/extra/changed?: #(true)
	    ]
		on-up [
			if face/extra/changed? [
				face/extra/changed?: #(false)
				if face/extra/save-filename <> %"" [
					save/all face/extra/save-filename face/selected 
				]        
			]
		]

	
	tab-panel-has-tab-position-saved1: tab-panel-has-tab-position-saved [
	    "Basic Examples" [
	    	text {To view an example table, click on the "Render Table" button} font-size 12
	    	return
			bg-panel1: panel 128.128.128 [ 
				origin 4x4		
				table1: table 900x300 data %table-sampler-basic.redtbl
					options [ auto-save: true ]
			]
			return
			group-box1: group-box "Rendering Area" [
				render-panel: panel 140.140.140 900x300
			]				    	
	    	
	    ]
	    "Intermediate Examples" [
	    	text {To view an example table, click on the "Render Table" button} font-size 12
	    	return
			bg-panel2: panel 128.128.128 [ 
				origin 4x4		
				table2: table 900x300 data %table-sampler-intermediate.redtbl
					options [ auto-save: true ]
			]
			return
			group-box1: group-box "Rendering Area" [
				render-panel2: panel 140.140.140 900x300
			]
	    ]
	    "Advanced Examples" [
	    	text {To view an example table, click on the "Run Example" button} font-size 12
	    	return 
			bg-panel3: panel 128.128.128 
				[
					origin 2x2
					table3: table 900x250 
						data %examples-gallery.redtbl 
						options [ auto-save: yes ]
				]	    	
	    ]
	] with [extra/save-filename: %vid-tab-panel-has-tab-position-saved1-tab-panel-selected.data]
]

;Direct Code Show Window source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
do show-window: [
	view examples-gallery-layout
]