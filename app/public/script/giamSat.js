async function chooseData(requestInfo, tableID) {
    const url = "https://d17cc975-b13d-47bd-810d-ed2d2f6b9608.mock.pstmn.io";
    console.log(requestInfo);
    let data = [];
    let api = "";
    if ("voteHistory" == requestInfo) {
        api = "giamSat";
    } else if ("voteCurrentResult" == requestInfo) {
        api = "giamSat";
    } else {
        return;
    }
    data = JSON.parse(await getData(url + '/' + api + '/' + requestInfo, "GET", ""));
    console.log(tableID);
    /*
    let tableElement = document.createElement("table");
    tableElement.setAttribute("id", tableID);
    const tableDiv= document.getElementsByClassName("tableDiv")[0];
    tableDiv.append(tableElement);
    */
    drawTable(tableID, data["data"], data["dataTitle"]);
}