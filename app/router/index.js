const express = require ('express');
const router = express.Router()

const settingRoutes = require('./settings');
const blogRoutes = require('./blogs')



router.use('/settings',settingRoutes);
router.use('/blog',blogRoutes)

module.exports = router;
