Red [ 
	Needs: View
]
; Window flags: modal resize no-title no-border no-min no-max no-buttons popup

; Native OS:   Dir, File, Font
; In this lib: Notify, Alert, Confirm, Prompt, Color, Date(TBD)

;---------------------------------------------------------------------------

; General warning:  Yellow in black triangle with exclamation	239.202.64
; Information: i												
; Prohibition: Red stop/slash-circle (ul to lr)					177.34.54
; Mandatory Action: Exclamation in blue circle					30.81.133

iso-yellow: 239.202.64
iso-red: 	177.34.54
iso-blue: 	30.81.133

;iso-font-40: make font! [style: 'bold size: 40 name: "Times New Roman"]
iso-font-40: make font! [style: 'bold size: 40 name: "Symbol"]
iso-font-40i: make font! [style: [bold italic] size: 40 name: "Times New Roman"]
;iso-font-32: make font! [style: 'bold size: 32 name: "Symbol"]
iso-font-26: make font! [style: 'bold size: 26 name: "Symbol"]

svvs: system/view/vid/styles
svvs/iso-info: [
	template: [
		type: 'base size: 48x48 color: none
		draw: [font iso-font-40i pen iso-blue fill-pen iso-blue circle 24x24 23 pen white text 7x-7 "i"]
	]
]
svvs/iso-question: [
	template: [
		type: 'base size: 48x48 color: none
		draw: [font iso-font-40 pen iso-blue fill-pen iso-blue circle 24x24 23 pen white text 3x-11 "?"]
	]
]
;	svvs/iso-question: [
;		template: [
;			type: 'base size: 48x48 color: none
;			draw: [font iso-font-40 pen iso-yellow fill-pen iso-yellow circle 24x24 23 pen black text 3x-11 "?"]
;		]
;	]
svvs/iso-warning: [
	template: [
		type: 'base size: 48x48 color: none
		draw: [font iso-font-26 pen black fill-pen iso-yellow line-width 4 line-join round polygon 24x4 46x44 2x44 text 13x5 "!"]
	]
]
svvs/iso-action-required: [
	template: [
		type: 'base size: 48x48 color: none
		draw: [font iso-font-40 pen iso-blue fill-pen iso-blue circle 24x24 23 pen white text 7x-12 "!"]
	]
]
svvs/iso-prohibit: [
	template: [
		type: 'base size: 48x48 color: none
		draw: [pen iso-red fill-pen white line-width 5 circle 24x24 21 line-width 4 line 8x8 40x40]
	]
]
;view [iso-info iso-warning iso-action-required iso-prohibit]

;---------------------------------------------------------------------------

svvs/timer: [
	default-actor: on-time
	template: [
		type: 'base size: 0x0 color: none
	]
]

std-dialog-actors: object [
	res: none
	on-key: func [face event] [
		;print [mold event/key mold event/flags]
		;!! If control is down, keys are always uppercase chars, including
		;	the caret, so we don't really need to check for 'control in
		;	event/flags if that is by design. Nice for char-key mapping.
		switch event/key [
			#"^M" [res: true  unview]	; enter
			#"^[" [res: none  unview]	; escape
			#"^O" #"^Y"  [if find event/flags 'control [res: true  unview]]
			#"^C" [if find event/flags 'control [res: none  unview]]
			#"^N" [if find event/flags 'control [res: false unview]]
		]
	]
]
std-dialog-opts: compose [
	flags: [modal no-min no-max]
	actors: (std-dialog-actors)
]

;---------------------------------------------------------------------------

;	add-dialog-timeout: func [
;		"Return modified copy of spec, with timer added"
;		spec [block! object!]
;		time [time!]
;	][
;		either block? spec [
;			append copy spec reduce ['timer 'rate time [unview]]
;		][
;			spec: make spec []
;			append spec/pane make face! [
;				type: 'base offset: 0x0 size: 0x0 rate: time
;				actors: object [
;					on-time: func [face [object!] event [event!]][unview]
;				]
;			]
;		]
;	]

; To set the title for a dialog, use [title "xxx"] in the layout, or options/text.
; To set the offset for a dialog, use options/offset.
show-dialog: function [
	spec [block! object!]
	/options opts [block!] "[offset: flags: actors: menu: parent: text:]"
	/timeout time [time!]  "Hide after timeout; only block specs supported"
	/with    init [block! none!] "Code to run after layout, before showing; e.g., to center face"
][
	;if time [spec: add-dialog-timeout spec time]
	if block? spec [
		if time [spec: append copy spec reduce ['timer 'rate time [unview]]]
		spec: layout spec
	]
	face: :spec												; let them use 'face in init block
	if init [do bind/copy init 'face]
	view/options spec make std-dialog-opts any [opts []]
]

; The idea of allowing specs to be prebuilt objects/faces came from thinking
; about how notifcations are used in 2017. They are often shown in place of
; minimized or background apps, rather than as proper dialogs over a window.
; They are also often animated into existence, which is something to consider.
; No-title and no-border flags may be desirable.
set 'notify function [
	"Display a dialog with a short message for a period of time"
	spec "Message to display or layout/face spec"
	time [time!]
	/over ctr [object!] "Center over this face"
	/offset pos [pair!]
][
	spec: case [
		object? :spec [spec]
		block?  :spec [spec]
		'else [compose [across iso-info pad 10x0 text font-size 12 350x70 (form :spec)]]
	]

	opts: copy/deep std-dialog-opts
	; If we include a title and text, that's the first thing they may read, taking time.
	; "i" means information, but not good as title bar text by itself.
	; If we don't, they can still include it in the layout, but then we can't use no-title.
	; Default is "Red: untitled". Opts/text overrides 'title in layout specs.
	if all [block? spec  not find spec 'title][append opts [text: ""]]
	if pair? pos [append opts compose [offset: (pos)]]

	if ctr [init: [center-face/with face ctr]]				; 'face refers to the dialog

	show-dialog/options/timeout/with spec opts time init
]

; alert [ok] confirm [ok cancel] prompt [text box]
set 'alert function [
	"Display a dialog with a short message, until the user closes it"
	msg
	;/options opts [block!]  "[offset: flags: actors: menu: parent: text:]"
	/style   sty  [word!]   "Include standard image and title: [info warn stop action]"
	/over    ctr  [object!] "Center over this face"
	/offset  pos  [pair!]   "Top-left offset of window"
	/local img txt
][
	set [img txt] switch/default sty [
		info	[[iso-info "Information"]]
		warn    [[iso-warning "Warning"]]
		stop    [[iso-prohibit "Stop!"]]
		action  [[iso-action-required "Action required"]]
	][reduce [() "Information"]]							; paren == unset, for no image

	spec: compose [
		title (txt)
		across (get/any 'img) pad 10x0 text font-size 12 350x70 (form msg) return
		pad 300x0 button "OK" [res: true unview]
	]

	;opts: append copy std-dialog-opts opts ;any [opts [flags: [modal no-min no-max]]]
	opts: copy/deep std-dialog-opts
	if pair? pos [append opts compose [offset: (pos)]]
	
	if ctr [init: [center-face/with face ctr]]				; 'face refers to the dialog
	show-dialog/options/with spec opts init
	res
]

count-newlines: func [
    value
][
    length? split value #"^/"
]

chunk-string: func [
    {Divides a long string into defined length using the space character as the delimiter}
    value [string!] "Source string"
    length [integer!] "Limits line length"
    /line-separator separator [string! char!] "Changes the default separator from newline"
][
    if ((length? value) <= length) [
        return value
    ]
    newline-sep: either line-separator [
        separator
    ] [
        newline
    ]
    str-offset: 0
    last-fnd-offset: 0
    until [
        str-offset: str-offset + length
        read-pos: skip value str-offset
        if read-pos = "" [break]
        if any [
            (space-fnd: find/reverse read-pos " ")
            (space-fnd: find/reverse read-pos newline-sep)
            (none = find/reverse read-pos " ")
        ] [
            fnd-offset: either space-fnd [index? space-fnd] [0]
            either fnd-offset <= last-fnd-offset [
                insert (skip value ((index? read-pos) - 1)) newline-sep
                str-offset: index? read-pos
                last-fnd-offset: str-offset
            ] [
                remove/part (skip value (fnd-offset - 1)) 1
                insert (skip value (fnd-offset - 1)) newline-sep
                last-fnd-offset: fnd-offset
                str-offset: fnd-offset
            ]
        ]
        (read-pos = "")
    ]
    return value
]
	
set 'prompt function [
	"Display a dialog with a short message, and OK/Cancel buttons"
	;-- Modified by Mike Yaunish to accept the Enter Key 
	;-- implemented auto sizing of message text 
	;-- added /prefill and /win-title 
	
	msg "Message to display"
	/text "Include a text box for a simple, typed response"
	/prefill prefill-text "Text entry field prefilled value"
	/win-title title-text "The title that displays on the requester window"

][
	formatted-msg: chunk-string copy msg 51
	line-count: count-newlines formatted-msg
	msg-size: to-pair reduce [ 350 (line-count * 18) ]
	if not prefill [ prefill-text: copy "" ]
	if not win-title [ title-text: copy "User Input Required"]
	view/options compose/deep [
	    title (title-text)
		across
		base (msg-size) 240.240.240 top left font-size 10 (form formatted-msg) 
		return
		(
			either text [
			    compose [
			        f-fld: field (prefill-text)  350 [
		                res: true 
		                unview
			        ] 
			        return
			    ]
			]
			[]
		)
		pad 200x0
		button "  OK  " [res: true  unview]
		button "Cancel" [res: none  unview]
		(either text [[do [set-focus f-fld]]][])
	] std-dialog-opts
	either any [std-dialog-actors/res res][
		either text [f-fld/text][true]
	][none]
]
set 'confirm :prompt
set 'request-text func [
	"Display a simple text entry dialog with a short message."
	msg
][
	prompt/text msg	
]

;---------------------------------------------------------------------------

set 'request-list function [	;-- request-list:
	{Modified By: Mike Yaunish. Supports 'one-click'}
	msg
	data [block!]
	/size sz [pair!]
	/one-click {Allows one-click selection}
][
    sz: any [sz 200x150]
    picked: 0
    either one-click [
        actor-name: 'on-select 
        ok-status: 'hidden
    ][ 
        actor-name: 'on-dbl-click 
        ok-status: 'all-over ;-- bogus place holder
    ]
	view view-composed: compose/only/deep [
		across
		text font-size 12 200 (form msg) return 
		f-lst: text-list sz data (data)
		    on-select [ picked: event/picked ] 
		    (actor-name) [res: true picked: event/picked  unview] 
		return
		button "OK"     on-click [ res: true  unview] (ok-status)
		button "Cancel" on-click [ res: none  unview]
		do [ set-focus f-lst ]
	] std-dialog-opts
	if any [std-dialog-actors/res res] [pick f-lst/data picked ]
]	

;---------------------------------------------------------------------------

set 'get-custom-colors does [
	sort difference default-colors get-current-colors
]

set 'default-colors [ "aqua" "beige" "black" "blue" "brick" "brown" "coal" "coffee" "crimson" "cyan" "forest" "glass" "gold" "gray" "green" "ivory" "khaki" "leaf" "linen" "magenta" "maroon" "mint" "navy" "oldrab" "olive" "orange" "papaya" "pewter" "pink" "purple" "reblue" "rebolor" "red" "sienna" "silver" "sky" "snow" "tanned" "teal" "transparent" "violet" "water" "wheat" "white" "yello" "yellow" ]

set 'get-current-colors does [ next sort extract split replace/all lowercase trim fetch-help tuple! [some [#" " | #"^/"]] #" " #" " 2 ]

set 'request-color function [
	"Display a simple color picker"
	/title txt [string!]
	/over    ctr  [object!] "Center over this face"
	/offset  pos  [pair!]   "Top-left offset of window"
][
	sz: 530x350
	sample-sz: as-pair 60 sz/y
	palette: make image! sz
	draw palette compose [	; Credit to @honix for this
		pen off
		fill-pen linear red orange yellow green aqua blue purple
		box 0x0 (sz)
		fill-pen linear white transparent black 0x0 (as-pair 0 sz/y)
		box 0x0 (sz)
	]
	res: copy ""
	named-layout: create-color-layout default-colors
	custom-named-layout: create-color-layout/large-names get-custom-colors 
	bind named-layout 'res
	spec: compose/deep [
		title (any [txt "Select a Color"])
		; The mouse down check here is because the window may pop up directly
		; over the mouse, and get focus. Hence, it gets a mouse up event, even
		; though they didn't mouse down on the color palette.
		tab-pan: tab-panel [
			"Pallete" [ 
    				image palette all-over on-down [dn?: true] 
    				on-up [
    					if dn? [
    						res: pick palette to-pair event/offset
    						unview
    					]
    				]
    				on-over [
    					picked: pick palette to-pair event/offset
    					if not none? picked [
        					sample-box/color: to-tuple picked
        					sample-value/text: to-string picked	
    					]
				]
    			return
    			sample-box: base 200x40
    			sample-value: text 140x40 font-size 14  "" left middle
			]
			"Default Named Colors" [
				(named-layout)
			]
			"Other Named Colors"[
				(custom-named-layout)
			]
		]
	]
	opts: copy/deep std-dialog-opts
	if pair? pos [append opts compose [offset: (pos)]]
	
	if ctr [init: [center-face/with face ctr]]				; 'face refers to the dialog
	show-dialog/options/with spec opts init
	res
]

create-color-layout: function [
	color-list [block!]
	/large-names
] [
	
	either large-names [ 
		bas-size: 132x40
		txt-size: 132x36 
		row-width: 4
	][ 
		bas-size: 65x40 
		txt-size: 65x18 
		row-width: 8
	]
		
	color-layout: compose [ 
		style txt: base (txt-size) wrap center middle 222.222.184 on-down [ res: to-tuple get to-word face/text unview ]
		style bas: base (bas-size) on-down [ res: face/color unview ]
	]
	forskip color-list row-width [
		color-row: copy/part color-list row-width
		append color-layout [ space 2x0 ]
		foreach color-name color-row [ 
			append color-layout compose [ 
				bas (to-word color-name) 
			] 	
		]
		append color-layout [ return ]
		foreach color-name color-row [ 
			append color-layout compose [
				txt (color-name)
			]
		]
		append color-layout [ 
			space 2x10
			return 
		]
	]
	return color-layout
] 

request-list-enhanced: func [
	{Asks user to pick from a text data list. The list will automatically be sorted.V4}
	message [string!]
	data-block [block!]
	/size list-size [pair!]
	/offset win-offset
][
	results: copy ""
	sort data-block
	if not size [ list-size: 180x140 ]
	options-block: either offset [
		compose [ offset: (win-offset) ]
	][
		[]
	]
	picker-size: to-pair reduce [ (list-size/x - 23) 23 ]
	msg-size: to-pair reduce [ (list-size/x ) 23 ]
	spacer-size: to-pair reduce [ (list-size/x - 109 ) 23 ]
	view/flags/options [
		title "Select"
		on-close [ results: none ]
		style search-icon: base 23x23 220.220.220 
			draw [
				pen 0.0.0
				line-width 2 
				circle 9x9 6 
				line 14x14 21x21
			]				
		space 10x2
		msg-text: text message msg-size center font-size 11
		return 
		tlist: text-list list-size
			data data-block
			on-change [
				if face/selected <> 0 [
					target-selector: get to-word face/extra/selector
					target-selector/text: copy pick face/data face/selected 
				]
			]
			on-dbl-click [
				if tlist/selected <> 0[
					ds1/actors/select-this-item/selected "tlist"
					do-actor ds1 none 'enter
				]
			]				
			extra [ 
				selector: "ds1"
				last-selected: 0
			]
		return	
		search-icon1: search-icon	
		space 0x0
		ds1: request-list-picker picker-size focus with [ extra/data-source: "tlist" ]
			on-enter [
				results: either face/text = "" [ none ][ face/text]
				unview
			]
		space 10x10
		return 	
		box spacer-size
		button "OK" 35x23  on-click [
			ds1/actors/select-this-item/selected "tlist"
			do-actor ds1 none 'enter
		]
		
		button "Cancel" 50x23  on-click [
			results: none 
			unview
		]	
				
	]
	[ no-min no-max modal ] 	;-- flags
	options-block
	return results
]

request-col-names: func [
	msg [string!]
	field-block [block!]
	input-strings [block!]
	/title the-title [string!] {title of the layout window}
	/size the-size 
	/offset the-offset
][
	--req-result: none
	generate-panel: function [
		field-block [block!]
		input-strings [block!]
	][
		vid-panel: compose [
			style data-cell: text 249.249.249 center middle 
			style header-cell: text 220.220.220 center middle
			style input-cell: field 150x25 
				on-focus [ face/selected: as-pair 1 (length? face/text)]
				on-unfocus [ face/selected: none ]
				
			space 4x4
			header-cell "Column" 		  60x25 
			header-cell "Current Heading" 150x25
			header-cell "Permanent Column Name"      150x25 
			return 
		]
		item-count: 1
		foreach item field-block [
			append vid-panel compose/deep [
				data-cell (to-string item-count)  60x25 
				data-cell (item/2) 150x25
				input-cell (pick input-strings item-count) focus
				return 
			]
			item-count: item-count + 1
		]
		return vid-panel 
	]			
	
	the-layout: generate-panel field-block input-strings
	if not title [ the-title: "Generated Layout"]
	if not size [ the-size: 400x400 ]
	if not offset [ 
		screen-size: system/view/screens/1/size
		the-offset: to-pair reduce [ (screen-size/x / 3) ( screen-size/y / 3 )]
	]
	options-block: 	compose/deep ([ offset: (reduce the-offset) ] )
	view/options [
		title "User Input Required" 
		on-close [ --req-result: none ]
		
		style vsp-underlay: panel gray 
			extra [
				vsp-viewport-panel: ""
			] 
			on-key [
	         	if event/key = 'F12 [
		            do-actor ok-button none 'click
				]
	        ]			
			on-create [
				set 'move-vertical-scroll-panel func [vertical-scroll-panel [object!] /wheel wheel-data] [
					viewport-object: get to-word vertical-scroll-panel/extra/vsp-viewport-panel 
					max-percent: (1 - (viewport-object/size/y / vertical-scroll-panel/size/y)) 
					scroller-object: get to-word vertical-scroll-panel/extra/vsp-scroller 
					either wheel [
						scroller-object/data: max ((min max-percent scroller-object/data - (wheel-data / (max-percent * 11)))) 0
					] [
						scroller-object/data: max (min max-percent scroller-object/data) 0
					] 
					vertical-scroll-panel/offset/y: to integer! negate vertical-scroll-panel/size/y * scroller-object/data
				] 
				set 'modify-scroll-panel func [vertical-scroll-panel [object!] layout-block [block!]] [
					vertical-scroll-panel/pane: layout/only layout-block 
					vertical-scroll-panel/size: select layout layout-block 'size 
					scroller-object: get to-word vertical-scroll-panel/extra/vsp-scroller 
					viewport-object: get to-word vertical-scroll-panel/extra/vsp-viewport-panel 
					scroller-object/selected: (viewport-object/size/y / vertical-scroll-panel/size/y) 
					scroller-object/data: 0.0 
					move-vertical-scroll-panel vertical-scroll-panel
				] 
				vsp-viewport-panel-object: get to-word face/extra/vsp-viewport-panel 
				face/size: vsp-viewport-panel-object/size + 26x6
			]
		style vertical-scroll-panel: panel 
			extra [
				vsp-scroller: "" 
				vsp-viewport-panel: ""
			]
		style vsp-viewport-panel: panel 
			extra [
				vertical-scroll-panel: "" 
				vsp-scroller: ""
			] 
			on-wheel [
				move-vertical-scroll-panel/wheel (get to-word face/extra/vertical-scroll-panel) event/picked
			]
		style vsp-scroller: scroller 16x16 
			extra [
				vertical-scroll-panel: "" 
				vsp-viewport-panel: ""
			] 
			on-change [
				move-vertical-scroll-panel (get to-word face/extra/vertical-scroll-panel)
			] 
			on-create [
				vsp-viewport-panel-object: get to-word face/extra/vsp-viewport-panel 
				face/size: to-pair reduce [16 vsp-viewport-panel-object/size/y]
			] 
			on-created [
				vsp-viewport-panel-object: get to-word face/extra/vsp-viewport-panel 
				vertical-scroll-panel-object: get to-word face/extra/vertical-scroll-panel 
				face/selected: (vsp-viewport-panel-object/size/y / vertical-scroll-panel-object/size/y)
			] 
			on-wheel [
				move-vertical-scroll-panel/wheel (get to-word face/extra/vertical-scroll-panel) event/picked
			]
			
		msg-area: text 400x24 font-size 12 msg
		return 
		vvl-vsp-underlay: vsp-underlay 
			with [
				extra/vsp-viewport-panel: "vvl-vsp-viewport"
			] 
			[
				origin 3x3
				vvl-vsp-viewport: vsp-viewport-panel the-size 
					with [
						extra/vertical-scroll-panel: "vvl-vsp-panel" 
						extra/vsp-scroller: "vvl-vsp-scroller"
					] 
					[
						vvl-vsp-panel: vertical-scroll-panel
							[] 
							with [
								extra/vsp-scroller: "vvl-vsp-scroller" 
								extra/vsp-viewport-panel: "vvl-vsp-viewport"
							]
							on-create [
								modify-scroll-panel vvl-vsp-panel the-layout
								
							]
					]
				space 4x2
				vvl-vsp-scroller: vsp-scroller 
					with [
						extra/vertical-scroll-panel: "vvl-vsp-panel" 
						extra/vsp-viewport-panel: "vvl-vsp-viewport"
					]
				return
				dummy: base 0x0 on-created [
					foreach f vvl-vsp-panel/pane [ 
						if f/type = 'field [  
							first-field: f
							break
						]
					]
					set-focus first-field											
				]
			]
		space 10x10
		return
		ok-button: button "OK  (F12)" 
			on-click [
				fld-list: collect [ 
						foreach f vvl-vsp-panel/pane [ 
						if f/type = 'field [ keep f ]
					]
				]
				--req-result: collect [ 
					foreach fld fld-list [ keep fld/text ]
				]
				unview 					
			]
		button "Cancel" 
			on-click [
				--req-result: none
				unview	
			]					
	]
	options-block
	return --req-result		
]

request-message: func [
    message [string!] "Message to display"
    /size area-size "The size of the text area"
    /fixed-font
    /no-wait
][
    ret-val: copy ""
    if not size [area-size: 400x200]
    font-info: copy []
    if fixed-font [font-info: [font-name "Consolas"]]
    rre: layout compose [
        title "User Message..."
        area (area-size) message font-size 12 (font-info) wrap
        return
        button "OK" focus 100x24 [
            ret-val: true
            unview/only rre
        ]
        button "CANCEL" 100x24 [
            ret-val: false
            unview/only rre
        ]
    ]
    view/:no-wait/options rre [
        actors: make object! [
            on-key: func [face event] [
                if event/key = #"^[" [unview]
            ]
        ]
    ]
    return ret-val
]

request-multiline-text: function [
    "Get multiline text input from user"
    msg [string!]
    /size area-size [pair!]
    /preload prestr [string!]
    /submit submit-code
    /offset offset-value [pair! point2D!]
    /custom custom-data [block!] "consists of <button-string> + <code-block>"
    /modal {Makes the requester modal, disabling all previously opened windows}
][
    --multiline-result: copy ""
    area-size: any [area-size 500x200]
    options-block: either offset [
        reduce [to-set-word 'offset offset-value]
    ] [
        []
    ]
    flags-block: either modal [
        [modal]
    ] [
        []
    ]
    prestr: copy any [prestr ""]
    custom-button-code: either custom [
        custom-text: 1
        custom-code: 2
        bind custom-data/:custom-code '--multiline-area
        compose/deep [
            custom-button: button (custom-data/:custom-text)
            on-click [(custom-data/:custom-code)]
            return
        ]
    ] [
        []
    ]
    multiline-layout: layout compose [
        Title "User input required"
        on-close [--multiline-result: none]
        msg-area: text font-size 12 msg wrap (as-pair area-size/x 66 ) return
        (custom-button-code)
        --multiline-area: area area-size font-name "fixedsys" font-size 9 focus on-create [
            --multiline-area/text: copy prestr
            face/flags: none
        ]
        on-key [
            if all [(event/key = 'F5) submit] [
                --multiline-result: --multiline-area/text
                do bind submit-code '--multiline-result
            ]
            if event/key = #"^[" [
                --multiline-result: none
                unview
            ]
			if event/key = 'F12 [
	            --multiline-result: --multiline-area/text
	            unview
			]
        ]
        return
        button "     OK  (F12)" [
            --multiline-result: --multiline-area/text
            unview
        ]
        submit-button: button "   Submit Changes / (F5) " [
            --multiline-result: --multiline-area/text
            do bind submit-code '--multiline-result
        ]
        button "   CANCEL / (ESC Key)  " [
            --multiline-result: none
            unview
        ]
        do [
            --multiline-result: copy ""
            get-results: does [
                return --multiline-area/text
            ]
            if not submit [
                submit-button/visible?: false
            ]
        ]
    ]
    view/options/flags multiline-layout options-block flags-block
    return --multiline-result
]