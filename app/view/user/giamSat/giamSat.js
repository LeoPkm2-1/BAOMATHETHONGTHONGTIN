async function getData(url, requestData) {
    const response = await fetch(url, {
        method: "GET", // *GET, POST, PUT, DELETE, etc.
        mode: "cors", // no-cors, *cors, same-origin
        cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
        credentials: "same-origin", // include, *same-origin, omit
        headers: {
          "Content-Type": "application/json",
          // 'Content-Type': 'application/x-www-form-urlencoded',
        },
        redirect: "follow", // manual, *follow, error
        referrerPolicy: "no-referrer", // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
    });
    return response.text();
}

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
    data = JSON.parse(await getData(url + '/' + api + '/' + requestInfo));
    console.log(tableID);
    $('#' + tableID).DataTable().destroy();
    /*
    let tableElement = document.createElement("table");
    tableElement.setAttribute("id", tableID);
    const tableDiv= document.getElementsByClassName("tableDiv")[0];
    tableDiv.append(tableElement);
    */
    drawTable(tableID, data["data"], data["dataTitle"]);
}