# Changelog

### 15-APR-2026 Ver:0.117 - Ver:0.120
-[/docs/documentation-changelog-15-Apr-2026.adoc](https://github.com/mikeyaunish/table-template/blob/main/docs/documentation-changelog-15-Apr-2026.adoc)

### 13-FEB-2026 Version: 0.113

- Major improvements and updates see:
-[/docs/table-template-documentation.adoc](https://github.com/mikeyaunish/table-template/blob/main/docs/table-template-documentation.adoc)
-[/docs/table-template-changes.adoc](https://github.com/mikeyaunish/table-template/blob/main/docs/table-template-changes.adoc)
-[/docs/documentation-changelog-11-Feb-2026.adoc](https://github.com/mikeyaunish/table-template/blob/main/docs/documentation-changelog-11-Feb-2026.adoc)
- Change logs will now be in the /docs/ folder

### 4-AUG-2025 Version: 0.093

- Add 'change-state' flag to be used with 'on-change' to determine 'before and 'after changes.

### 4-AUG-2025 Version: 0.092

- Add ability to use on-click and on-change
- on-change happens on a double-click of a cell

### 23-JUL-2025 Version: 0.091

- Add version and identifier numbers
- Fix tab handling

### 19-JUL-2025 Modification: 90

- Fix which cell delete key acts on

### 18-JUL-2025 Modification: 89

- Rewrite set-usable and in-view functions to support more accurate cursor movements

### 14-JUL-2025 Modification: 88

- Fix scrolling off end of table when columns larger than view
- Add Ctrl+Space = Select Column and Shift+Space = Select Row

### 11-JUL-2025 Modification: 87

- Removed features added in Mod. 86 (to be added back later)
- Modify cursoring at edges to display properly

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