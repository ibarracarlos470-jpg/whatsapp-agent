const { Conversation, Message, Agent, Company } = require('../models');
const claudeService = require('./claudeService');
const metaService = require('./metaService');

class ConversationService {
  async getOrCreateConversation(companyId, customerId, customerPhone, agentId, platform) {
    let conversation = await Conversation.findOne({
      where: { companyId, customerId, platform, status: 'active' },
    });

    if (!conversation) {
      conversation = await Conversation.create({
        companyId,
        customerId,
        customerPhone,
        agentId,
        platform,
        status: 'active',
        context: [],
      });
    }

    return conversation;
  }

  async addMessage(conversationId, sender, content, messageId, mediaType = 'text') {
    const message = await Message.create({
      conversationId,
      sender,
      content,
      messageId,
      mediaType,
      status: 'sent',
    });

    return message;
  }

  async getConversationHistory(conversationId, limit = 10) {
    const messages = await Message.findAll({
      where: { conversationId },
      order: [['createdAt', 'ASC']],
      limit,
    });

    return messages.map((msg) => ({
      sender: msg.sender,
      content: msg.content,
      createdAt: msg.createdAt,
    }));
  }

  async processIncomingMessage(companyId, customerId, customerPhone, messageContent, messageId, platform) {
    try {
      const company = await Company.findByPk(companyId);
      if (!company || !company.isActive) {
        throw new Error('Company not found or inactive');
      }

      let agent = await Agent.findOne({
        where: { companyId, isActive: true },
      });

      if (!agent) {
        throw new Error('No active agent found for company');
      }

      const conversation = await this.getOrCreateConversation(
        companyId,
        customerId,
        customerPhone,
        agent.id,
        platform
      );

      await this.addMessage(conversation.id, 'customer', messageContent, messageId);

      const history = await this.getConversationHistory(conversation.id);

      const agentResponse = await claudeService.generateResponse(agent, history);

      await this.addMessage(conversation.id, 'agent', agentResponse);

      await metaService.sendMessage(
        company[`${platform}PhoneNumber`] || company.whatsappPhoneNumber,
        customerPhone,
        agentResponse
      );

      await conversation.update({ lastMessageAt: new Date() });

      return {
        success: true,
        response: agentResponse,
        conversationId: conversation.id,
      };
    } catch (error) {
      console.error('Error processing incoming message:', error);
      throw error;
    }
  }

  async closeConversation(conversationId, reason = 'completed') {
    const conversation = await Conversation.findByPk(conversationId);
    if (conversation) {
      await conversation.update({ status: 'closed' });
    }
    return conversation;
  }
}

module.exports = new ConversationService();
