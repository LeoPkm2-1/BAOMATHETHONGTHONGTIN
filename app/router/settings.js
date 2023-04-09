const express = require ('express');
const router = express.Router()

router.get('/', function (req, res) {
    res.send('Settings Page');
});
router.get('/profile', function (req, res) {
    res.send('Profile Page');
});

module.exports = router;
