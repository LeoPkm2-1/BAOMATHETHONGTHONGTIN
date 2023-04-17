function getCookieDict() {
    let arr = document.cookie.split(';');
    let result = {};
    let temp = [];
    arr.forEach(element => {
        temp = element.split('=');
        result[temp[0].trimStart()] = temp[1];
    })
    return result;
}

export default getCookieDict;