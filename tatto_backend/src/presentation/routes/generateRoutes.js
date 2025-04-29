const express = require('express');
const router = express.Router();
const { generateTattoo, getPredictionResult } = require('../controllers/generateController');

// POST /generate
router.post('/generate', generateTattoo);

// GET /generate/:id
router.get('/generate/:id', getPredictionResult);

module.exports = router; 