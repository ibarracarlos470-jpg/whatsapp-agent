const express = require('express');
const agentController = require('../controllers/agentController');
const { authMiddleware } = require('../middleware/authMiddleware');

const router = express.Router();

router.use(authMiddleware);

router.post('/', agentController.create.bind(agentController));
router.get('/', agentController.list.bind(agentController));
router.get('/:agentId', agentController.getById.bind(agentController));
router.put('/:agentId', agentController.update.bind(agentController));
router.delete('/:agentId', agentController.delete.bind(agentController));
router.post('/:agentId/clone', agentController.clone.bind(agentController));

module.exports = router;
