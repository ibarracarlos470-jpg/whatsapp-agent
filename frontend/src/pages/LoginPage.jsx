import { useState } from 'react';
import axios from 'axios';
import '../styles/LoginPage.css';

function LoginPage({ onLogin }) {
  const [mode, setMode] = useState('login'); // 'login' or 'register'
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    industry: '',
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const API_URL = 'http://localhost:3000/api';

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  const handleRegister = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      const response = await axios.post(`${API_URL}/companies/register`, {
        name: formData.name,
        email: formData.email,
        industry: formData.industry,
      });

      const { token, company } = response.data;
      onLogin(token, company.id);
    } catch (err) {
      setError(err.response?.data?.error || 'Error registrando empresa');
    } finally {
      setLoading(false);
    }
  };

  const handleLogin = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    // Para demostración, usamos email como ID
    // En producción, tendrías un endpoint de login real
    try {
      // Simulación - en producción conectarías con endpoint de login
      alert('Demo: Usa credentials de empresa registrada');
      setError('Endpoint de login no implementado aún. Registrate con una empresa.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="login-container">
      <div className="login-box">
        <h1>🤖 WhatsApp Agent</h1>
        <p className="subtitle">Agente de IA para atención al cliente</p>

        {error && <div className="error-message">{error}</div>}

        {mode === 'register' ? (
          <form onSubmit={handleRegister} className="login-form">
            <h2>Registrar Empresa</h2>

            <div className="form-group">
              <label>Nombre de Empresa</label>
              <input
                type="text"
                name="name"
                placeholder="Mi Empresa"
                value={formData.name}
                onChange={handleChange}
                required
              />
            </div>

            <div className="form-group">
              <label>Email</label>
              <input
                type="email"
                name="email"
                placeholder="admin@empresa.com"
                value={formData.email}
                onChange={handleChange}
                required
              />
            </div>

            <div className="form-group">
              <label>Industria</label>
              <select name="industry" value={formData.industry} onChange={handleChange}>
                <option value="">Selecciona industria</option>
                <option value="E-commerce">E-commerce</option>
                <option value="Servicios">Servicios</option>
                <option value="Consultoría">Consultoría</option>
                <option value="Educación">Educación</option>
                <option value="Salud">Salud</option>
                <option value="Otros">Otros</option>
              </select>
            </div>

            <button type="submit" disabled={loading} className="btn-primary">
              {loading ? 'Registrando...' : 'Registrarse'}
            </button>

            <p className="toggle-mode">
              ¿Ya tienes cuenta?{' '}
              <button
                type="button"
                onClick={() => {
                  setMode('login');
                  setError('');
                }}
                className="link-btn"
              >
                Inicia sesión
              </button>
            </p>
          </form>
        ) : (
          <form onSubmit={handleLogin} className="login-form">
            <h2>Iniciar Sesión</h2>

            <div className="form-group">
              <label>Email</label>
              <input
                type="email"
                name="email"
                placeholder="admin@empresa.com"
                value={formData.email}
                onChange={handleChange}
                required
              />
            </div>

            <div className="form-group">
              <label>Token</label>
              <input
                type="password"
                name="password"
                placeholder="Token JWT"
                value={formData.password}
                onChange={handleChange}
                required
              />
            </div>

            <button type="submit" disabled={loading} className="btn-primary">
              {loading ? 'Cargando...' : 'Iniciar Sesión'}
            </button>

            <p className="toggle-mode">
              ¿No tienes cuenta?{' '}
              <button
                type="button"
                onClick={() => {
                  setMode('register');
                  setError('');
                }}
                className="link-btn"
              >
                Registrate aquí
              </button>
            </p>
          </form>
        )}
      </div>
    </div>
  );
}

export default LoginPage;
