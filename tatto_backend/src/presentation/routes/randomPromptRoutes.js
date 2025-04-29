const express = require('express');
const router = express.Router();
const { getRandomPrompt } = require('../controllers/randomPromptController');

router.get('/random-prompt', getRandomPrompt);

module.exports = router; 