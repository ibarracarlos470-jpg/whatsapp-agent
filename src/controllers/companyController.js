const { Company, Agent } = require('../models');
const { generateToken } = require('../middleware/authMiddleware');
const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');

class CompanyController {
  async register(req, res) {
    try {
      const { name, email, industry, whatsappPhoneNumber } = req.body;

      if (!name || !email) {
        return res.status(400).json({ error: 'Name and email required' });
      }

      const existing = await Company.findOne({ where: { email } });
      if (existing) {
        return res.status(400).json({ error: 'Email already registered' });
      }

      const apiKey = uuidv4();
      const company = await Company.create({
        name,
        email,
        industry,
        whatsappPhoneNumber,
        apiKey,
        plan: 'starter',
      });

      const token = generateToken(company.id, company.id);

      res.status(201).json({
        success: true,
        company: {
          id: company.id,
          name: company.name,
          email: company.email,
          apiKey: company.apiKey,
        },
        token,
      });
    } catch (error) {
      console.error('Register error:', error);
      res.status(500).json({ error: error.message });
    }
  }

  async getProfile(req, res) {
    try {
      const company = await Company.findByPk(req.companyId, {
        include: [{ model: Agent, attributes: ['id', 'name', 'isActive'] }],
      });

      if (!company) {
        return res.status(404).json({ error: 'Company not found' });
      }

      res.json(company);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async updateProfile(req, res) {
    try {
      const { name, industry, whatsappPhoneNumber, instagramHandle, facebookPageId } = req.body;

      const company = await Company.findByPk(req.companyId);
      if (!company) {
        return res.status(404).json({ error: 'Company not found' });
      }

      await company.update({
        name: name || company.name,
        industry: industry || company.industry,
        whatsappPhoneNumber: whatsappPhoneNumber || company.whatsappPhoneNumber,
        instagramHandle: instagramHandle || company.instagramHandle,
        facebookPageId: facebookPageId || company.facebookPageId,
      });

      res.json({
        success: true,
        company,
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async getStats(req, res) {
    try {
      const company = await Company.findByPk(req.companyId);
      if (!company) {
        return res.status(404).json({ error: 'Company not found' });
      }

      const { Conversation, Message } = require('../models');
      const conversations = await Conversation.count({
        where: { companyId: req.companyId },
      });

      const messages = await Message.count({
        include: [
          {
            model: Conversation,
            where: { companyId: req.companyId },
          },
        ],
      });

      res.json({
        company: company.name,
        plan: company.plan,
        conversations,
        messages,
        agentsActive: await Agent.count({
          where: { companyId: req.companyId, isActive: true },
        }),
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
}

module.exports = new CompanyController();
