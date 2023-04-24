const express = require ('express');
const router = express.Router()


const vertifylogin= require('./vertifylogin');
const sampleRoutes = require('./sampleRoutes');
const nguoidanRoutes = require('./nguoidanRoutes');



router.use('/vertifylogin',vertifylogin);
router.use('/sample',sampleRoutes);
router.use('/nguoidan',nguoidanRoutes);



module.exports = router;
