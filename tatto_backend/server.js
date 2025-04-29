const express = require('express');
const bodyParser = require('body-parser');
const generateRoutes = require('./src/presentation/routes/generateRoutes');
const randomPromptRoutes = require('./src/presentation/routes/randomPromptRoutes');
const rateLimit = require('express-rate-limit');
const Sentry = require('@sentry/node');
require('dotenv').config();

// Sentry init
Sentry.init({
    dsn: "https://23835226f00e33f09c174f8d09d70219@o4509226492362752.ingest.de.sentry.io/4509226509205584",
    tracesSampleRate: 1.0,
});

const app = express();
const PORT = process.env.PORT || 3000;

// Logging middleware
app.use((req, res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.originalUrl} from ${req.ip}`);
    next();
});

// Rate limiting middleware
const limiter = rateLimit({
    windowMs: 60 * 1000,
    max: 10,
    message: {
        error: 'Too many requests, please try again later.'
    }
});
app.use(limiter);

// Middleware
app.use(bodyParser.json());

// Routes
app.use('/', generateRoutes);
app.use('/', randomPromptRoutes);

// Error logging middleware
app.use((err, req, res, next) => {
    console.error(`[${new Date().toISOString()}] ERROR:`, err);
    res.status(500).json({ error: 'Internal server error' });
});

if (process.env.NODE_ENV !== 'test') {
    app.listen(PORT, () => {
        console.log(`Server is running on port ${PORT}`);
    });
}

module.exports = app;
