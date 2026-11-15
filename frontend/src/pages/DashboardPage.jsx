import { useEffect, useState } from 'react';
import axios from 'axios';
import '../styles/Dashboard.css';

function DashboardPage({ token, companyId }) {
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchStats();
  }, []);

  const fetchStats = async () => {
    try {
      const response = await axios.get('http://localhost:3000/api/companies/stats', {
        headers: { Authorization: `Bearer ${token}` },
      });
      setStats(response.data);
    } catch (err) {
      setError('Error cargando estadísticas');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div className="container"><p>Cargando...</p></div>;

  return (
    <div className="container">
      <div className="dashboard">
        <h1>Dashboard</h1>

        {error && <div className="error">{error}</div>}

        {stats && (
          <div className="stats-grid">
            <div className="stat-card">
              <div className="stat-label">Conversaciones</div>
              <div className="stat-value">{stats.conversations}</div>
            </div>

            <div className="stat-card">
              <div className="stat-label">Mensajes</div>
              <div className="stat-value">{stats.messages}</div>
            </div>

            <div className="stat-card">
              <div className="stat-label">Agentes Activos</div>
              <div className="stat-value">{stats.agentsActive}</div>
            </div>

            <div className="stat-card">
              <div className="stat-label">Plan</div>
              <div className="stat-value">{stats.plan}</div>
            </div>
          </div>
        )}

        <div className="welcome-section">
          <h2>Bienvenido a WhatsApp Agent</h2>
          <p>Tu agente de IA está listo para atender clientes 24/7</p>

          <div className="quick-start">
            <h3>Inicio Rápido:</h3>
            <ol>
              <li>✅ <strong>Backend:</strong> Corriendo en puerto 3000</li>
              <li>✅ <strong>Base de datos:</strong> SQLite sincronizada</li>
              <li>🔧 <strong>Crear agente:</strong> Ve a la sección Agentes</li>
              <li>🔗 <strong>Conectar WhatsApp:</strong> Configura webhook en Meta</li>
              <li>💬 <strong>Ver conversaciones:</strong> Aparecerán aquí en tiempo real</li>
            </ol>
          </div>

          <div className="info-cards">
            <div className="info-card">
              <h4>📡 API Disponible</h4>
              <p>Todos los endpoints están listos. Consulta la documentación.</p>
            </div>

            <div className="info-card">
              <h4>🤖 IA Gemini</h4>
              <p>Tus agentes usan Google Gemini para respuestas inteligentes.</p>
            </div>

            <div className="info-card">
              <h4>🔐 Multi-tenant</h4>
              <p>Cada empresa tiene su propio espacio aislado.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default DashboardPage;
