import { useEffect, useState } from 'react';
import axios from 'axios';
import '../styles/Conversations.css';

function ConversationsPage({ token }) {
  const [conversations, setConversations] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchConversations();
  }, []);

  const fetchConversations = async () => {
    try {
      // Esta es una demostración - integrarías con tu API real
      setConversations([
        {
          id: '1',
          customerId: '5491234567890',
          customerName: 'Juan García',
          platform: 'whatsapp',
          status: 'active',
          lastMessageAt: new Date().toISOString(),
          messageCount: 12,
        },
        {
          id: '2',
          customerId: '5491234567891',
          customerName: 'María López',
          platform: 'whatsapp',
          status: 'active',
          lastMessageAt: new Date().toISOString(),
          messageCount: 5,
        },
      ]);
    } catch (error) {
      console.error('Error fetching conversations:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div className="container"><p>Cargando conversaciones...</p></div>;

  return (
    <div className="container">
      <div className="conversations-page">
        <h1>💬 Conversaciones</h1>

        {conversations.length === 0 ? (
          <div className="empty-state">
            <p>No hay conversaciones aún.</p>
            <p>Conecta tu WhatsApp Business y comienza a recibir mensajes.</p>
          </div>
        ) : (
          <div className="conversations-table">
            <table>
              <thead>
                <tr>
                  <th>Cliente</th>
                  <th>Plataforma</th>
                  <th>Estado</th>
                  <th>Mensajes</th>
                  <th>Último Mensaje</th>
                  <th>Acciones</th>
                </tr>
              </thead>
              <tbody>
                {conversations.map((conv) => (
                  <tr key={conv.id}>
                    <td>
                      <div className="customer-info">
                        <p className="name">{conv.customerName}</p>
                        <p className="phone">{conv.customerId}</p>
                      </div>
                    </td>
                    <td>
                      {conv.platform === 'whatsapp' ? '📱 WhatsApp' :
                       conv.platform === 'instagram' ? '📷 Instagram' :
                       '👍 Facebook'}
                    </td>
                    <td>
                      <span className={`status ${conv.status}`}>
                        {conv.status === 'active' ? '🟢 Activa' : '⚫ Cerrada'}
                      </span>
                    </td>
                    <td>{conv.messageCount}</td>
                    <td>{new Date(conv.lastMessageAt).toLocaleString()}</td>
                    <td>
                      <button className="btn-small">Ver</button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}

export default ConversationsPage;
