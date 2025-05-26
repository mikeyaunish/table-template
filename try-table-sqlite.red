Red [Needs: 'View]
#include %table-template.red

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