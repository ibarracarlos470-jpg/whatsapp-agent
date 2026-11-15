const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const bodyParser = require('body-parser');
const path = require('path');
const config = require('./config');
const sequelize = require('./config/database');
const authRoutes = require('./routes/authRoutes');
const webhookRoutes = require('./routes/webhookRoutes');
const companyRoutes = require('./routes/companyRoutes');
const agentRoutes = require('./routes/agentRoutes');

const app = express();

app.use(helmet());
app.use(cors());
app.use(bodyParser.json({ limit: '10mb' }));
app.use(bodyParser.urlencoded({ limit: '10mb', extended: true }));

// Servir archivos estáticos del frontend compilado
app.use(express.static(path.join(__dirname, '../frontend/dist')));

app.use('/api/auth', authRoutes);
app.use('/api/webhook', webhookRoutes);
app.use('/api/companies', companyRoutes);
app.use('/api/agents', agentRoutes);

app.get('/health', (req, res) => {
  res.json({ status: 'healthy', message: 'WhatsApp Agent is running' });
});

// Fallback para React Router - servir index.html para rutas no-API
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '../frontend/dist/index.html'));
});

async function initDatabase() {
  try {
    await sequelize.authenticate();
    console.log('Database connected successfully');
    await sequelize.sync({ alter: process.env.NODE_ENV === 'development' });
    console.log('Database synchronized');
  } catch (error) {
    console.error('Database connection failed:', error);
    process.exit(1);
  }
}

async function startServer() {
  try {
    await initDatabase();

    app.listen(config.server.port, () => {
      console.log(`Server running on port ${config.server.port}`);
      console.log(`Environment: ${config.server.nodeEnv}`);
      console.log(`API URL: ${config.app.url}`);
    });
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

startServer();

module.exports = app;
