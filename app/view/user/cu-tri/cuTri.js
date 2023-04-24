const tempList = [
    ["Nguyen Van A", "a1"],
    ["Tran Thi B", "b1"],
    ["Hoan Nhi C", "c1"]
]

async function drawCanidate(canidateList, divToInsertID) {
    canidateList = tempList;
    divToInsertID = "canidate";
    const fatherElement = document.getElementById(divToInsertID);
    let insertElement, radioElement, labelElement;
    canidateList.forEach(canidate => {
        radioElement = document.createElement("input");
        labelElement = document.createElement("label");
        insertElement = document.createElement("div");
        radioElement.setAttribute("type", "radio");
        radioElement.setAttribute("class", "radioReq");
        radioElement.setAttribute("name", "radioReq");
        radioElement.setAttribute("value", canidate[1]);
        radioElement.setAttribute("id", canidate[1]);
        labelElement.setAttribute("for", canidate[1]);
        labelElement.appendChild(document.createTextNode(canidate[0]));
        insertElement.appendChild(radioElement);
        insertElement.appendChild(labelElement);
        fatherElement.appendChild(insertElement);
    });
}