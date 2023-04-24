const express = require('express');
const bodyParser = require('body-parser')
const app = express();
const path = require('path');
const port = process.env.PORT ||3000;
const routes = require('./router');

const oracledb = require('oracledb');

app.use(express.static('public'));
app.use(express.static('view'));
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: false }))

// jump to router.
app.use('/',routes)




app.listen(port, ()=> {
    console.log(`create successfully ${port}`);
});