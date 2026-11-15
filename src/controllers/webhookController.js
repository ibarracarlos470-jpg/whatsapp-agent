const metaService = require('../services/metaService');
const conversationService = require('../services/conversationService');
const config = require('../config');

class WebhookController {
  async verifyWebhook(req, res) {
    const mode = req.query['hub.mode'];
    const token = req.query['hub.verify_token'];
    const challenge = req.query['hub.challenge'];

    if (mode === 'subscribe' && metaService.verifyWebhookToken(token)) {
      console.log('Webhook verified');
      res.status(200).send(challenge);
    } else {
      res.status(403).send('Verification failed');
    }
  }

  async handleWebhook(req, res) {
    const body = req.body;

    if (body.object === 'whatsapp_business_account') {
      const entries = body.entry || [];

      entries.forEach((entry) => {
        const changes = entry.changes || [];
        changes.forEach((change) => {
          if (change.field === 'messages') {
            const messages = change.value.messages || [];
            const contacts = change.value.contacts || [];
            const metadata = change.value.metadata || {};

            messages.forEach((message) => {
              this.processMessage(message, contacts, metadata);
            });
          }
        });
      });

      res.status(200).send('EVENT_RECEIVED');
    } else {
      res.status(404).send('Not found');
    }
  }

  async processMessage(message, contacts, metadata) {
    try {
      const customerId = message.from;
      const customerName = contacts[0]?.profile?.name || 'Customer';
      const messageId = message.id;
      const messageText = message.text?.body || '';
      const platform = 'whatsapp';

      const phoneNumberId = metadata.phone_number_id;

      const companyId = await this.getCompanyIdByPhoneNumber(phoneNumberId);

      if (!companyId) {
        console.error(`No company found for phone number: ${phoneNumberId}`);
        return;
      }

      await conversationService.processIncomingMessage(
        companyId,
        customerId,
        customerId,
        messageText,
        messageId,
        platform
      );

      await metaService.markMessageAsRead(phoneNumberId, messageId);
    } catch (error) {
      console.error('Error processing message:', error);
    }
  }

  async getCompanyIdByPhoneNumber(phoneNumberId) {
    const Company = require('../models/Company');
    const company = await Company.findOne({
      where: { whatsappPhoneNumber: phoneNumberId },
    });
    return company?.id;
  }
}

module.exports = new WebhookController();
