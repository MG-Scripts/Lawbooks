document.addEventListener("DOMContentLoaded", function () {

    function debugJSON(obj, label = 'Object') {
        if (arguments.length === 0) {
            console.log(`${label}: <no argument passed>`);
            return;
        }
        if (obj === null) {
            console.log(`${label}: null`);
            return;
        }
        if (obj === undefined) {
            console.log(`${label}: undefined`);
            return;
        }
        const seen = new WeakSet();
        const jsonString = JSON.stringify(obj, (key, value) => {
            if (typeof value === 'object' && value !== null) {
                if (seen.has(value)) return '[Circular]';
                seen.add(value);
            }
            return value;
        }, 2);
        console.log(`${label}:`);
        console.log(jsonString);
    }

    function toggleInterface(show) {
        const body = document.getElementById('law-book-body');
        if (show) {
            body.classList.remove('d-none');
        } else {
            body.classList.add('d-none');
        }
    }

    function toggleAppWait(show) {
        const appWait = document.getElementById('app-wait');
        if (show) {
            appWait.classList.remove('d-none');
        } else {
            appWait.classList.add('d-none');
        }
    }

    function fixUmlaute(text) {
        if (!text) return text; 
        return text
            .replace(/Ã¼/g, "ü")
            .replace(/Ã–/g, "Ö")
            .replace(/Ã¶/g, "ö")
            .replace(/Ã¤/g, "ä")
            .replace(/Ã„/g, "Ä")
            .replace(/ÃŸ/g, "ß")
    }

    function formatBookTitle(template, book) {
        return template.replace(/\{(\w+)\}/g, (match, key) => {
            return (book[key] != null) ? book[key] : "";
        });
    }

    function buildTableHtml(headsConfig, dataRows) {
        let html = '<table class="table"><thead><tr>';
        headsConfig.forEach(({label}) => {
            html += `<th style="min-width: 100px;">${label}</th>`;
        });
        html += '</tr></thead><tbody>';

        dataRows.forEach(row => {
            html += '<tr>';
            headsConfig.forEach(({column}) => {
                let cell = row[column] != null ? row[column] : "";
                if (typeof cell === 'string') {
                    cell = fixUmlaute(cell);
                }
                html += `<td style="min-width: 100px;">${cell}</td>`;
            });
            html += '</tr>';
        });

        html += '</tbody></table>';
        return html;
    }


    function createAccordionItem(book, bookNameTemplate, tableHeads) {
        let html = "";
        debugJSON(tableHeads)
        debugJSON(bookNameTemplate)
        const bookID = book.bookID;
        const titleText = formatBookTitle(bookNameTemplate, {
            bookID: bookID,
            bookName: book.bookName,
            bookShortName: book.bookShortName
        });
        html += `<div id="${book.bookShortName}-${bookID}" class="accordion-item">`;
        html += `<h2 class="accordion-header" id="heading-${bookID}">`;
        html += `<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-${bookID}" aria-expanded="false" aria-controls="collapse-${bookID}">`;
        html += titleText;
        html += `</button>`;
        html += `</h2>`;

        html += `<div id="collapse-${bookID}" class="accordion-collapse collapse" aria-labelledby="heading-${bookID}" data-bs-parent="#lawBooks">`;
        html += `<div class="accordion-body">`;

        html += `<form>`;
        html += `<div class="row mb-3 justify-content-center">`;
        html += `<div class="col-md-6">`;
        html += `<div class="row">`;
        html += `<div class="col-8">`;
        html += `<input type="text" class="form-control search-input" id="search-${bookID}" data-id="${bookID}" data-table-id="table-${bookID}" placeholder="Suche...">`;
        html += `</div>`;
        html += `<div class="col-4">`;
        html += `<input type="reset" value="Zurücksetzen" class="btn btn-danger w-100" data-id="${bookID}" id="reset-${bookID}">`;
        html += `</div>`;
        html += `</div>`;
        html += `</div>`;
        html += `</div>`;
        html += `</form>`;
        html += buildTableHtml(tableHeads, book.laws);


        // html += `<table class="table" id="table-${bookID}">`;
        // html += `<thead><tr>`
        // tableHeads.forEach(tHead => {
        //     html += `<th>${tHead}</th>`
        // })
        // html += `</tr></thead>`;
        // html += `<tbody>`;
        // book.laws.forEach(law => {
        //     html += `<tr>`;
        //     html += `<td>${law.paragraph}</td>`;
        //     html += `<td>${fixUmlaute(law.crime)}</td>`;
        //     html += `<td>${fixUmlaute(law.other)}</td>`;
        //     html += `<td>${law.minimum_penalty}</td>`;
        //     html += `<td>${law.detention_time}</td>`;
        //     html += `<td>${law.changeddate}</td>`;
        //     html += `</tr>`;
        // });
        // html += `</tbody>`;
        // html += `</table>`;

        html += `</div>`;
        html += `</div>`;
        html += `</div>`;

        return html;
    }

    function buildAccordion(lawData, bookNameTemplate, tableHeads) {
        let accordionHTML = "";
        lawData.forEach(book => {
            accordionHTML += createAccordionItem(book, bookNameTemplate, tableHeads);
        });
        return accordionHTML;
    }

    function attachSearchFunctionality() {
        const resetInputs = document.querySelectorAll('[id^="reset-"]');
        const searchInputs = document.querySelectorAll('.search-input');
        searchInputs.forEach(input => {
            input.addEventListener('keyup', function () {
                const query = this.value.toLowerCase();
                const tableId = this.getAttribute('data-table-id');
                const table = document.getElementById(tableId);
                if (table) {
                    const rows = table.querySelectorAll('tbody tr');
                    rows.forEach(row => {
                        const rowText = row.innerText.toLowerCase();
                        row.style.display = rowText.indexOf(query) > -1 ? '' : 'none';
                    });
                }
            });
        });
        resetInputs.forEach(reset => {
            reset.addEventListener('click', function () {
                const searchInputs = document.querySelectorAll('.search-input');
                searchInputs.forEach(input => {
                    input.value = '';
                    const tableId = input.getAttribute('data-table-id');
                    const table = document.getElementById(tableId);
                    if (table) {
                        table.querySelectorAll('tbody tr').forEach(row => {
                            row.style.display = '';
                        });
                    }
                });
            });
        });
    }

    window.addEventListener('message', function (event) {
        const data = event.data;
        if (data.action === 'showLawbooks') {
            toggleAppWait(true);
            toggleInterface(true);
            if (data.data) {
                const lawData = data.data;
                const accordion = document.getElementById('lawBooks');
                if (accordion) {
                    accordion.innerHTML = buildAccordion(lawData, data.bookNameTemplate, data.tableHeads);
                    attachSearchFunctionality();
                } else {
                    console.error("Accordion Container nicht gefunden!");
                }
            }
            if (data.heading) {
                document.getElementById('heading').textContent = data.heading
            }
            toggleAppWait(false);
        }
    });

    document.addEventListener('keydown', function (event) {
        if (event.key === "Escape") {
            toggleInterface(false);
            fetch(`https://${GetParentResourceName()}/closeNUI`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' }
            });
        }
    });

    document.getElementById('close-interface').addEventListener('click', function () {
        toggleInterface(false);
        fetch(`https://${GetParentResourceName()}/closeNUI`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' }
        });
    });
});
