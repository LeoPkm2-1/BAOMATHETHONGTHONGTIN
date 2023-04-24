$(document).ready(function () {
    const neededInfo = document.getElementById("infoRequest");
    neededInfo.addEventListener("change", (event) => {
        $("#infoTable").DataTable().clear().draw().destroy();
        chooseData(event.target.value, "infoTable");
    });
    chooseData(neededInfo.value, "infoTable");
});