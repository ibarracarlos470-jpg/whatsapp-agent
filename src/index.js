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

// Servir página de login
app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html lang="es">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>SP360 - Soluciones Inteligentes</title>
      <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; }
        .login-container {
          display: flex;
          justify-content: center;
          align-items: center;
          min-height: 100vh;
          background: linear-gradient(135deg, #0066cc 0%, #003d99 100%);
          padding: 2rem;
        }
        .login-box {
          background: white;
          padding: 3rem;
          border-radius: 8px;
          box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
          width: 100%;
          max-width: 400px;
        }
        .logo-container {
          text-align: center;
          margin-bottom: 1.5rem;
        }
        .sp360-logo {
          display: inline-block;
          background: linear-gradient(135deg, #0066cc 0%, #ff6600 100%);
          color: white;
          font-weight: 900;
          font-size: 1.8rem;
          padding: 1rem 1.5rem;
          border-radius: 12px;
          letter-spacing: 2px;
          box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
        }
        h1 {
          font-size: 2rem;
          color: #333;
          margin-bottom: 0.5rem;
          text-align: center;
        }
        .subtitle {
          text-align: center;
          color: #666;
          margin-bottom: 2rem;
          font-size: 1.1rem;
        }
        .form-group {
          margin-bottom: 1rem;
        }
        label {
          display: block;
          font-weight: 600;
          color: #333;
          margin-bottom: 0.5rem;
        }
        input {
          width: 100%;
          padding: 0.75rem;
          border: 1px solid #ddd;
          border-radius: 4px;
          font-size: 1rem;
        }
        input:focus {
          outline: none;
          border-color: #0066cc;
          box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.1);
        }
        button {
          width: 100%;
          padding: 0.75rem;
          background-color: #0066cc;
          color: white;
          border: none;
          border-radius: 4px;
          font-weight: 600;
          font-size: 1rem;
          cursor: pointer;
          margin-top: 1rem;
        }
        button:hover {
          background-color: #0052a3;
        }
        .success {
          color: #28a745;
          padding: 1rem;
          background: #d4edda;
          border-radius: 4px;
          margin-bottom: 1rem;
        }
        .error {
          color: #dc3545;
          padding: 1rem;
          background: #f8d7da;
          border-radius: 4px;
          margin-bottom: 1rem;
        }
      </style>
    </head>
    <body>
      <div class="login-container">
        <div class="login-box">
          <div class="logo-container">
            <div class="sp360-logo">SP360</div>
          </div>
          <h1>SP360</h1>
          <p class="subtitle">Soluciones Inteligentes para tu Negocio</p>

          <div id="message"></div>

          <form id="registerForm">
            <div class="form-group">
              <label>Nombre de Empresa</label>
              <input type="text" name="name" placeholder="Mi Empresa" required>
            </div>
            <div class="form-group">
              <label>Email</label>
              <input type="email" name="email" placeholder="admin@empresa.com" required>
            </div>
            <div class="form-group">
              <label>Contraseña</label>
              <input type="password" name="password" placeholder="Tu contraseña" required>
            </div>
            <button type="submit">Registrarse</button>
          </form>
        </div>
      </div>

      <script>
        document.getElementById('registerForm').addEventListener('submit', async (e) => {
          e.preventDefault();
          const messageDiv = document.getElementById('message');

          try {
            const data = {
              name: e.target.name.value,
              email: e.target.email.value,
              password: e.target.password.value
            };

            const response = await fetch('/api/auth/register', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify(data)
            });

            const result = await response.json();

            if (response.ok) {
              messageDiv.innerHTML = '<div class="success">✅ ¡Registro exitoso! Token: ' + result.token.substring(0, 20) + '...</div>';
              e.target.reset();
            } else {
              messageDiv.innerHTML = '<div class="error">❌ Error: ' + result.error + '</div>';
            }
          } catch (error) {
            messageDiv.innerHTML = '<div class="error">❌ Error de conexión</div>';
          }
        });
      </script>
    </body>
    </html>
  `);
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
