const axios = require('axios');
const config = require('../config');

const META_API_VERSION = 'v18.0';
const META_API_BASE = `https://graph.instagram.com/${META_API_VERSION}`;

class MetaService {
  async sendMessage(phoneNumberId, recipientPhone, message) {
    try {
      const url = `${META_API_BASE}/${phoneNumberId}/messages`;

      const response = await axios.post(url, {
        messaging_product: 'whatsapp',
        to: recipientPhone,
        type: 'text',
        text: { body: message },
      }, {
        headers: {
          Authorization: `Bearer ${config.meta.whatsappToken}`,
          'Content-Type': 'application/json',
        },
      });

      return response.data;
    } catch (error) {
      console.error('Error sending WhatsApp message:', error.response?.data || error.message);
      throw error;
    }
  }

  async markMessageAsRead(phoneNumberId, messageId) {
    try {
      const url = `${META_API_BASE}/${phoneNumberId}/messages`;

      await axios.post(url, {
        messaging_product: 'whatsapp',
        status: 'read',
        message_id: messageId,
      }, {
        headers: {
          Authorization: `Bearer ${config.meta.whatsappToken}`,
          'Content-Type': 'application/json',
        },
      });
    } catch (error) {
      console.error('Error marking message as read:', error.message);
    }
  }

  async uploadMedia(phoneNumberId, mediaUrl, mediaType) {
    try {
      const url = `${META_API_BASE}/${phoneNumberId}/media`;

      const response = await axios.post(url, {
        messaging_product: 'whatsapp',
        url: mediaUrl,
      }, {
        headers: {
          Authorization: `Bearer ${config.meta.whatsappToken}`,
          'Content-Type': 'application/json',
        },
      });

      return response.data;
    } catch (error) {
      console.error('Error uploading media:', error.message);
      throw error;
    }
  }

  verifyWebhookToken(token) {
    return token === config.meta.verifyToken;
  }
}

module.exports = new MetaService();
