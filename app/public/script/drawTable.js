function drawTable (tableID, dataSet, columnRender) {
    $('#' + tableID).DataTable({
        data: dataSet,
        columns: columnRender,
    });
}