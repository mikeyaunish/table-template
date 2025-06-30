# Changelog

All notable changes to this project will be documented in this file.
Changes that deviate from the initial project are documented in reverse chronological order below. 

### 29-JUN-2025 Modification: 86
- @kavina computers starts adding features
- Added enhanced cell types of: checkbox, radio, dropdown, slider and rating
- Add auto colors of: add-negative-rule, add-negative-rule, add-positive-rule, add-zero-rule,
	add-high-rule, add-error-rule, add-custom-range
- Add read-only column	
	

### 21-June-2025
- Change data input to replicate standard spreadsheet behavior
- Add on-table-tab-handler to deal with spreadsheet tabbing behavior


### 16-June-2025
- Add scroller-width to set-freeze-point
- Change init of tbl-editor to #(none)

### 6-June-2025
- Add ability for table to be styled. Add init to template to properly initialize variables to work with styles. Need style functionality so the table-template will work properly with Direct Code.

### 31-May-2025
- Add `auto-save` to options to allow data to be saved automatically as it is entered. This is for data changes only. Any formatting changes must still be saved manually.

Example Usage
```
view [
    table 717x517 data %company-table-data.red options [auto-save: #(true)]
]
```
NOTE: This option will only work when the `data` specified is a file. It will not work when the `data` is just a Red block of data. 