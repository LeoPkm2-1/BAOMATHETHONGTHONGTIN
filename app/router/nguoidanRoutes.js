const express  = require('express');
const router = express.Router();

const nguoidanControls = require('../controller/nguoidanController');

router.get('/',nguoidanControls.getNguoiDan);


module.exports = router;