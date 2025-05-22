function getLaws(id)
    local law_book_laws = Config.Tables.law_book_laws
    local sqlQuery = "SELECT * FROM " .. law_book_laws.name .. " WHERE `lawbook_id` = ? AND `deleted` = 0"
    if law_book_laws.order ~= nil or law_book_laws.order ~= "" then
        sqlQuery = sqlQuery .. " ORDER BY " .. law_book_laws.order
    end
    if law_book_laws.sorting_type ~= nil or law_book_laws.sorting_type ~= "" then
        sqlQuery = sqlQuery .. " " .. law_book_laws.sorting_type
    end
    local result = MySQL.query.await(sqlQuery, { id }) or {}
    local laws = {}
    if #result > 0 then
        for _, law in pairs(result) do
            local timestamp_sec = math.floor(law.changeddate / 1000)
            os.setlocale("de_DE.UTF-8", "time")
            table.insert(laws, {
                paragraph = law.paragraph,
                crime = law.crime,
                other = law.others,
                minimum_penalty = law.minimum_penalty,
                detention_time = law.detention_time,
                changeddate = os.date("%B %d, %Y %H:%M:%S", timestamp_sec)
            })
        end
        return laws
    end

    return {}
end

function getLawBooks()
    local law_books = Config.Tables.law_books
    local sqlQuery = "SELECT * FROM " .. law_books.name .. " WHERE `deleted` = 0"
    if law_books.order ~= nil or law_books.order ~= "" then
        sqlQuery = sqlQuery .. " ORDER BY " .. law_books.order
    end
    if law_books.sorting_type ~= nil or law_books.sorting_type ~= "" then
        sqlQuery = sqlQuery .. " " .. law_books.sorting_type
    end
    local lawBooks = MySQL.query.await(sqlQuery, {}) or {}
    local lawData = {}
    if #lawBooks > 0 then
        for _, book in pairs(lawBooks) do
            table.insert(lawData, {
                bookID = book.id,
                bookName = book.name,
                bookShortName = book.short_name,
                laws = getLaws(book.id)
            })
        end
    end
    return lawData
end

RegisterNetEvent(GetCurrentResourceName() .. ':server:getLawbooks')
AddEventHandler(GetCurrentResourceName() .. ':server:getLawbooks', function(player)
    local _source = player or source
    local lawData = getLawBooks()
    TriggerClientEvent(GetCurrentResourceName() .. ':client:openNUI', _source, lawData)
end)



RegisterCommand("Lawbooks", function(source, args, rawcommand)
    TriggerEvent(GetCurrentResourceName() .. ':server:getLawbooks', source)
end)
