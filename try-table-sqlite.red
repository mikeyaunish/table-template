Red [Needs: 'View]

#include %table-template.red

if not exists? %chinook.db [
	print rejoin [ {The database file: chinook.db does not exist.} newline
	{Download it from: https://www.sqlitetutorial.net/wp-content/uploads/2018/03/chinook.zip} newline
	{and then try this program again.}]
	halt
]

sql-query: func [sql][
    out: copy ""
    call/output rejoin [{sqlite3 -csv -header chinook.db "} sql {"}]  out
    load/as out 'csv
]
view [
    table 717x517 with [
        data: sql-query "select TrackId, Name, Title, Composer from tracks inner join albums on tracks.AlbumID = albums.AlbumId"
    ]
]