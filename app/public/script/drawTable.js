function drawTable (tableID, dataSet, tableTitle) {
    $(tableID).DataTable({
        data: dataSet,
        columns: tableTitle,
    });
}

export default drawTable;