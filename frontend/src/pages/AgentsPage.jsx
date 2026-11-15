import { useEffect, useState } from 'react';
import axios from 'axios';
import '../styles/Agents.css';

function AgentsPage({ token }) {
  const [agents, setAgents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [formData, setFormData] = useState({
    name: '',
    systemPrompt: '',
    temperature: 0.7,
  });

  useEffect(() => {
    fetchAgents();
  }, []);

  const fetchAgents = async () => {
    try {
      const response = await axios.get('http://localhost:3000/api/agents', {
        headers: { Authorization: `Bearer ${token}` },
      });
      setAgents(response.data);
    } catch (error) {
      console.error('Error fetching agents:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await axios.post('http://localhost:3000/api/agents', formData, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setFormData({ name: '', systemPrompt: '', temperature: 0.7 });
      setShowForm(false);
      fetchAgents();
    } catch (error) {
      console.error('Error creating agent:', error);
    }
  };

  const handleDelete = async (agentId) => {
    if (window.confirm('¿Eliminar este agente?')) {
      try {
        await axios.delete(`http://localhost:3000/api/agents/${agentId}`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        fetchAgents();
      } catch (error) {
        console.error('Error deleting agent:', error);
      }
    }
  };

  if (loading) return <div className="container"><p>Cargando agentes...</p></div>;

  return (
    <div className="container">
      <div className="agents-page">
        <div className="page-header">
          <h1>Mis Agentes</h1>
          <button onClick={() => setShowForm(!showForm)} className="btn-primary">
            {showForm ? 'Cancelar' : '➕ Crear Agente'}
          </button>
        </div>

        {showForm && (
          <form onSubmit={handleSubmit} className="agent-form">
            <div className="form-group">
              <label>Nombre del Agente</label>
              <input
                type="text"
                placeholder="Ej: Agente de Ventas"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                required
              />
            </div>

            <div className="form-group">
              <label>System Prompt (Instrucciones)</label>
              <textarea
                placeholder="Ej: Eres un asistente amable de ventas. Ayuda a los clientes con..."
                value={formData.systemPrompt}
                onChange={(e) => setFormData({ ...formData, systemPrompt: e.target.value })}
                rows="4"
                required
              />
            </div>

            <div className="form-group">
              <label>Temperatura ({formData.temperature})</label>
              <input
                type="range"
                min="0"
                max="1"
                step="0.1"
                value={formData.temperature}
                onChange={(e) => setFormData({ ...formData, temperature: parseFloat(e.target.value) })}
              />
              <small>Baja = más preciso, Alta = más creativo</small>
            </div>

            <button type="submit" className="btn-primary">Crear Agente</button>
          </form>
        )}

        <div className="agents-grid">
          {agents.length === 0 ? (
            <p>No hay agentes aún. ¡Crea uno!</p>
          ) : (
            agents.map((agent) => (
              <div key={agent.id} className="agent-card">
                <div className="agent-header">
                  <h3>{agent.name}</h3>
                  <span className={`status ${agent.isActive ? 'active' : 'inactive'}`}>
                    {agent.isActive ? '🟢 Activo' : '🔴 Inactivo'}
                  </span>
                </div>

                <div className="agent-info">
                  <p><strong>Temperatura:</strong> {agent.temperature}</p>
                  <p><strong>Prompt:</strong> {agent.systemPrompt.substring(0, 100)}...</p>
                </div>

                <div className="agent-actions">
                  <button className="btn-secondary">✏️ Editar</button>
                  <button
                    className="btn-danger"
                    onClick={() => handleDelete(agent.id)}
                  >
                    🗑️ Eliminar
                  </button>
                </div>
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
}

export default AgentsPage;
