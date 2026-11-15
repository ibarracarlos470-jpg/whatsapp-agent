const express = require('express');
const companyController = require('../controllers/companyController');
const { authMiddleware } = require('../middleware/authMiddleware');

const router = express.Router();

router.post('/register', companyController.register.bind(companyController));
router.get('/profile', authMiddleware, companyController.getProfile.bind(companyController));
router.put('/profile', authMiddleware, companyController.updateProfile.bind(companyController));
router.get('/stats', authMiddleware, companyController.getStats.bind(companyController));

module.exports = router;
