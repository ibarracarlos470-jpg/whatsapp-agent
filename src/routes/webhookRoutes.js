const express = require('express');
const webhookController = require('../controllers/webhookController');

const router = express.Router();

router.get('/webhook', webhookController.verifyWebhook.bind(webhookController));
router.post('/webhook', webhookController.handleWebhook.bind(webhookController));

module.exports = router;
