const { Agent, Company } = require('../models');

class AgentController {
  async create(req, res) {
    try {
      const { name, systemPrompt, personality, capabilities, temperature } = req.body;

      if (!name || !systemPrompt) {
        return res.status(400).json({ error: 'Name and systemPrompt required' });
      }

      const agent = await Agent.create({
        companyId: req.companyId,
        name,
        systemPrompt,
        personality: personality || { tone: 'professional', language: 'es' },
        capabilities: capabilities || {
          answerQuestions: true,
          scheduleMeetings: false,
          processPayments: false,
        },
        temperature: temperature || 0.7,
        isActive: true,
      });

      res.status(201).json({
        success: true,
        agent,
      });
    } catch (error) {
      console.error('Create agent error:', error);
      res.status(500).json({ error: error.message });
    }
  }

  async list(req, res) {
    try {
      const agents = await Agent.findAll({
        where: { companyId: req.companyId },
        order: [['createdAt', 'DESC']],
      });

      res.json(agents);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async getById(req, res) {
    try {
      const { agentId } = req.params;

      const agent = await Agent.findOne({
        where: { id: agentId, companyId: req.companyId },
      });

      if (!agent) {
        return res.status(404).json({ error: 'Agent not found' });
      }

      res.json(agent);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async update(req, res) {
    try {
      const { agentId } = req.params;
      const { name, systemPrompt, personality, capabilities, temperature, isActive } = req.body;

      const agent = await Agent.findOne({
        where: { id: agentId, companyId: req.companyId },
      });

      if (!agent) {
        return res.status(404).json({ error: 'Agent not found' });
      }

      await agent.update({
        name: name || agent.name,
        systemPrompt: systemPrompt || agent.systemPrompt,
        personality: personality || agent.personality,
        capabilities: capabilities || agent.capabilities,
        temperature: temperature !== undefined ? temperature : agent.temperature,
        isActive: isActive !== undefined ? isActive : agent.isActive,
      });

      res.json({
        success: true,
        agent,
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async delete(req, res) {
    try {
      const { agentId } = req.params;

      const agent = await Agent.findOne({
        where: { id: agentId, companyId: req.companyId },
      });

      if (!agent) {
        return res.status(404).json({ error: 'Agent not found' });
      }

      await agent.destroy();

      res.json({
        success: true,
        message: 'Agent deleted',
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async clone(req, res) {
    try {
      const { agentId } = req.params;
      const { newName } = req.body;

      const original = await Agent.findOne({
        where: { id: agentId, companyId: req.companyId },
      });

      if (!original) {
        return res.status(404).json({ error: 'Agent not found' });
      }

      const cloned = await Agent.create({
        companyId: req.companyId,
        name: newName || `${original.name} (Copy)`,
        systemPrompt: original.systemPrompt,
        personality: original.personality,
        capabilities: original.capabilities,
        temperature: original.temperature,
        isActive: false,
      });

      res.status(201).json({
        success: true,
        agent: cloned,
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
}

module.exports = new AgentController();
