const Company = require('./Company');
const Agent = require('./Agent');
const Conversation = require('./Conversation');
const Message = require('./Message');

Company.hasMany(Agent, { foreignKey: 'companyId' });
Company.hasMany(Conversation, { foreignKey: 'companyId' });

Agent.belongsTo(Company, { foreignKey: 'companyId' });
Agent.hasMany(Conversation, { foreignKey: 'agentId' });

Conversation.belongsTo(Company, { foreignKey: 'companyId' });
Conversation.belongsTo(Agent, { foreignKey: 'agentId' });
Conversation.hasMany(Message, { foreignKey: 'conversationId' });

Message.belongsTo(Conversation, { foreignKey: 'conversationId' });

module.exports = {
  Company,
  Agent,
  Conversation,
  Message,
};
