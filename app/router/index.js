const express = require ('express');
const router = express.Router()
const auth = require('../middleware/authen');

const vertifylogin= require('./vertifylogin');
const sampleRoutes = require('./sampleRoutes');
const nguoidanRoutes = require('./nguoidanRoutes');

router.use('/nguoidan',nguoidanRoutes);
router.use(auth.authenHandler);

router.use('/vertifylogin',vertifylogin);
router.use('/sample',sampleRoutes);



module.exports = router;
