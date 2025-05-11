Config = {}

Config.Header = "Gesetzbuch"

Config.Tables = {
    law_books = {
        name = "myemergency_law_books", -- tablename
        order = "id",                   -- the column by which the sorting should be done | empty for nothing
        sorting_type = "ASC"            -- ASC Ato Z/1 to 9 | DESC Z to A/9 to 1 | empty for nothing
    },
    law_book_laws = {
        name = "myemergency_law_book_laws", -- tablename
        order = "paragraph",                -- the column by which the sorting should be done | empty for nothing
        sorting_type = "ASC"                -- ASC Ato Z/1 to 9 | DESC Z to A/9 to 1 | empty for nothing
    }
}

Config.Locations = {
    {
        coords = { x = 440.98, y = -978.79, z = 30.69, h = 179.55 },
        pedModel = "a_m_m_business_01",
        blip = {
            enabled = true,
            sprite = 77,
            scale = 0.8,
            color = 3,
            name = "Lawbook"
        }
    },
    {
        coords = { x = 117.06, y = -747.30, z = 45.75, h = 115.18 },
        pedModel = "a_m_m_business_01",
        blip = {
            enabled = true,
            sprite = 77,
            scale = 0.8,
            color = 3,
            name = "Lawbook"
        }
    },
}

-- available: {bookID} {bookName} {bookShortName}
Config.LawBookName = "{bookID} – {bookName} ({bookShortName})"
Config.TableHeads = {
    [1] = {
        column = "paragraph",
        label = "Paragraph"
    },
    [2] = {
        column = "crime",
        label = "Titel"
    },
    [3] = {
        column = "other",
        label = "Inhalt"
    },
    [4] = {
        column = "minimum_penalty",
        label = "Geldstrafe"
    },
    [5] = {
        column = "detention_time",
        label = "Haftzeit"
    },
    [6] = {
        column = "changeddate",
        label = "letzte Änderung"
    },
}