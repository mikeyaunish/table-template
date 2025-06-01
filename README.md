# Customized Version of table-template 
This repository is a fork of table-template work done by Toomasv. The original project can be found at (https://github.com/toomasv/table-template). 

The modifications allow the template to work with Red Verion 0.6.6 and onward.  


**Changes include:** 
- Update map and construction syntax in program and in the documentation below
- Move all template fields from the actors block into the template block
- Move the actors/data field to the newly created 'table-data field
- Create `usable-grid` and `max-usable` fields to support more precise scrolling at the end of the sheet. 
- Cleanup of various old comments. 

This version of table-template should work almost exactly as the original did.(Take into account that the new 'table-data field is now contained within the style itself ) All of the original documentation is below, with some minor changes to reflect this version.

Any changes made to the template (after 30-May-2025) are now documented in the [CHANGE-LOG.md](CHANGE-LOG.md) file. 

# table-template
Template for table style

To enable table style:
```
#include %table-template.red
```
After that the table style can be used in layout, as e.g.
```
view [table]
```
This will create an empty table with default size of 317x217 and grid 3x8. Default cell size is 100x25. Both vertical and horizontal scrollers are always included. Scrollers are 17 points thick.

Specifying size for table will fill the extra space with additional cells.
```
view [table 717x517]
```
This will create an empty table with 7x20 grid.

Grid size of table can be specified separately, e.g. following will create empty table with 10 columns and 50 rows, but in previous boundaries.
```
view [table 717x517 data 10x50 options [auto-col: #(true)]]
```
When instead of grid size a block is presented as data, this block is interpreted as table. Block should consist of row blocks of equal size. E.g.
```
view [table 717x517 data [["" A B][1 First Row][2 Second Row]]]
```
Values are formed to be presented in table.

Instead of giving data directly as block, file name or url may be specified, to be loaded as table, e.g.
```
view [
    table 717x515 
    data https://support.staffbase.com/hc/en-us/article_attachments/360009197011/username-password-recovery-code.csv 
    options [delimiter: #";"]
]
```
Non-standard delimiter (standard is comma) can currently be specified for urls only.

If you have set up sqlite, data source may be specified as sql query, e.g.
The 'chinook.db' can be found here (https://www.sqlitetutorial.net/wp-content/uploads/2018/03/chinook.zip)
```
sql-query: func [sql][
    out: copy ""
    call/output rejoin [{sqlite3 -csv -header C:\Users\Toomas\sqlite\chinook.db "} sql {"}]  out
    load/as out 'csv
]
view [
    table 717x517 with [
        data: sql-query "select TrackId, Name, Title, Composer from tracks inner join albums on tracks.AlbumID = albums.AlbumId"
    ]
]
```

## Features

**Auto-headers**
It is possible to add automatcally indexed column (and/or row) to you tabel by specifying corresponding option. When `auto-col` is set to `true` an extra column will be created, automatically enumerated. By this the original order of rows can be restored whenever necessary:
```
view [table 717x517 data 10x50 options [auto-col: #(true)]]
```
Both row and column headers can be specified in this manner:
```
view [table 717x517 data 10x50 options [auto-col: #(true) auto-row: #(true)]]
```
Auto-generated header refer to the position of given row/col in original data. Index row/col itself has index 0.

Another way to auto-generate indexes is by option `sheet`:
```
view [table options [sheet: #(true)]]
```
This way both column and row headers will always be generated. But they are different, referenig to actual visual order of rows/cols, not to their order in original data. Therefore also when sorting (see below) headers generated with `sheet` option will not change, but headers generated with `auto-col` and `auto-row` will be reordered.

**Row and column sizes** can be changed by dragging on cell border. If holding down control while dragging, sizes of all following rows/columns will be changed too. If ctrl-dragging on first row/column, default size is changed.

**Scrolling** will move the whole grid together with selection. **Wheeling** will sroll table vertically by 3 rows, with ctrl-down by page. Shift-wheel scrolls table horizontally.

Navigation by keys moves **selection**, extending it with shift-down. Moving selection outside of visual borders will automatically scroll table if not in end already. Selection is also moved by clicking on cells (if not on/near border), extending selection with shift-down and/or ctrl-down.

**Freezing** of rows and/or columns is enabled from local menu. Right-click on row/column/cell which you want to freeze and choose "Freeze" from submenu of cell, row or column. Frozen rows/columns are dark-colored. Freezing can be repeated, e.g. if table is scrolled after previous freezing. "Unfreeze" removes all freezing correspondingly from cells/rows/columns. To unfreeze, it is not necessary to place mouse on corresponding row/column as when freezing.

**Sorting** is currently possible by single column only. With mouse on column to be sorted by, select "Up" or "Down" from Column->Sort submenu. Table is sorted from non-frozen rows downward. If table is created from csv file, then all data is of type `string!`, and sorted accordingly. To sort by loaded values, choose Column->Sort->Loaded... or convert column to different type before sorting (see below). The only way to restore original order currently is to sort by column that holds original order (e.g. with options/auto-index set to `true`) or to select "Unsort" from menu.

**Filtering** is so far also possible by single column at time only. As with sorting, only non-frozen rows are considered. Select Column->Filter from local menu and enter selection criteria. There is special format for criteria. It may start with operator, e.g. `< 100` (provided data is of corresponding type - see type changing below), or with function name expecting data as its first argument, but without specifying this argument, e.g. `find charset [#"a" #"e" #"i" #"o" #"u"]`. Missing argument will be inserted automatically. Code may start also with a solitary set-word, which will reference data in edited field (but it should not be specified). So you can use the word in further code, e.g. `string-field:  all [find string-field #"a"  20 < length? string-field]`. Repeated filtering will consider already filtered rows only (but it is buggy :)). To remove filter choose Column->Unfilter from local menu. 

There is very limited basic regex func `~` for compact comparison of strings, e.g. `~ "^^2"` is ~same as `parse [#"2" to end]`.

**Copying/pasting**

Selected cells can be copied or cut, and then pasted in same or different configuration. If pasted when single cell is selected, selection is pasted in same configuration as it was copied, otherwise it is pasted in order as cells are selected. Order of selection of original cells is also significant.

**Cell editing** is activated with double-click or enter on cell or from local menu, and committed with enter.

**Column editing** can be activated from local menu, opened on column you are going to edit. Editing command is entered into code window and it has special format too: in case of a single command it takes a command with arguments, but with main argument right after the command name omitted. E.g. when you have opened CSV file with one column as formed float, but with commas as thousand-separators, and you want to remove these commas before you can change type of the column, then choose Column->Edit and enter `replace/all comma ""`

