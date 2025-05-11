# Lawbooks

## Description

Lawbooks is a simple FiveM resource that displays your “law books” in-game via a responsive HTML/JavaScript/CSS UI. All data is read from two MySQL tables managed by the [**myEmergency**](https://shop.myscripts.eu/) asset (by myScripts). Without [**myEmergency**](https://shop.myscripts.eu/), no tables exist, so you’d have to create and populate them yourself.

## Requirements

- FiveM server (cerulean)
- es_extended
- oxmysql
- ox_lib
- [**myEmergency**](https://shop.myscripts.eu/) by myScripts

## Installation

1. Copy the `Lawbooks` folder into your `resources` directory.
2. Add the following line to your `server.cfg`:
   ```
   start lawbooks
   ```
3. Start or restart the server.

## Configuration

All settings are in **config.lua**:

```lua
Config = {}

-- Header in UI (top center)
Config.Header = "Lawbook"

-- Database tables and sorting settings
Config.Tables = {
  law_books = {
    name         = "myemergency_law_books",      -- Table name
    order        = "id",                         -- Column to sort by
    sorting_type = "ASC"                         -- ASC or DESC
  },
  law_book_laws = {
    name         = "myemergency_law_book_laws",  -- Table name
    order        = "paragraph",                  -- Column to sort by
    sorting_type = "ASC"                         -- ASC or DESC
  }
}

-- NPC locations and blip settings
Config.Locations = {
  {
    coords   = { x=440.98, y=-978.79, z=30.69, h=179.55 },
    pedModel = "a_m_m_business_01",
    blip     = {
      enabled = true, sprite = 77, scale = 0.8, color = 3,
      name    = "Lawbook"
    }
  },
  {
    coords   = { x=117.06, y=-747.30, z=45.75, h=115.18 },
    pedModel = "a_m_m_business_01",
    blip     = {
      enabled = true, sprite = 77, scale = 0.8, color = 3,
      name    = "Lawbook"
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
```
Current language is german, you can change the labels to your language. you should leave colums default, ONLY if you renamed the columns in your database table, you can edit

## Usage

1. On server start, NPCs spawn at the locations defined in `Config.Locations`.
2. Approach an NPC and press **E** to open the law book UI.
3. In the UI, expand each book and search by paragraph, title, content, penalty, or last updated date.
4. Click the red **X** in the top right to close the UI.

## Database

The **myemergency_law_books** and **myemergency_law_book_laws** tables are created and populated by the [**myEmergency**](https://shop.myscripts.eu/) asset.
- **myemergency_law_books**: columns `id`, `name`, `short_name`, …
- **myemergency_law_book_laws**: columns `lawbook_id`, `paragraph`, `crime`, `others`, `minimum_penalty`, `detention_time`, `changeddate`, …

Without [**myEmergency**](https://shop.myscripts.eu/), you must create and populate these tables yourself.

## Future Plans

- Create law books even without MDT
- Search across all law books

*Made with ❤ by MG-Scripts*  
Created by MG-Scripts
