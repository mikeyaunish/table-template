Red [Needs: 'View]
#include %table-template.red


file: %data/RV291.csv  ;%data/annual-enterprise-survey.red ;
view [  
	below 
	caption: h1 "Example Table" 
	tb: table 617x267 focus data file ; options [auto-index: #(true)] 
	
] 