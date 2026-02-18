Red [
	Title: "fetch-daily-prices.red"
	Needs: View
	Comment: "Generated with Direct Code"
]

do setup: [
	do %../table-template.red
	get-google-csv: function [ file-num [integer!]][
		day-files: [ ;-- dummy data from google csv file
			1 "1iWTzE6YLpXqeqIpHfUQDrToTY4DqWLQo"
			2 "1dz6tOy1paJhkjYYXzaLyvSw36ToPDKcn"
			3 "1_ElV_wRHNVYQ83uptfIqX8I3uuJHI4Ao"
			4 "115MSA-qMXA6ximaEqxzun9SBaS9f75x_"
			5 "1U7mh-r2zqNHGObizPrRpFoxJhRJQTSt1"
		]
		return read (to-url rejoin [ "https://drive.google.com/uc?id=" select day-files file-num "&export=download" ])
	]	
]

;Direct Code VID Code source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
fetch-daily-prices-layout: [
	title "Fetch Daily Prices"
	bg-panel: panel 128.128.128 [ 
		origin 4x4
		table1: table 400x250 data %fetch-daily-prices.redtbl
	]
	return
	button1: button "Fetch and Append Data From Internet" 
		on-click [
			last-day: to-integer table1/actors/get-data table1 1 (last table1/row-index)
			next-day: either last-day = 5 [ 1 ] [ last-day + 1]
			table1/actors/append-row table1
			table1/actors/set-data/row/refresh table1 1 (last table1/row-index) (first load-csv get-google-csv next-day)
		]
	button2: button "Save Table"
		on-click [
			table1/actors/save-table table1
		]
]

;Direct Code Show Window source marker - DO NOT MODIFY THIS LINE OR THE NEXT LINE!
do show-window: [
	view fetch-daily-prices-layout
]