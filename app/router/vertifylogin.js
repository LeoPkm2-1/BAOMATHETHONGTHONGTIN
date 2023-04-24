const express  = require('express');
const router = express.Router();

const vertifyloginController = require('../controller/vertifyloginController')

router.post('/',vertifyloginController.checkMacthUserName)

module.exports = router;