const jwt = require('jsonwebtoken');
const Company = require('../models/Company');
const config = require('../config');

exports.register = async (req, res) => {
  try {
    const { email, password, companyName } = req.body;

    if (!email || !password || !companyName) {
      return res.status(400).json({ error: 'Email, password, and company name required' });
    }

    const existingCompany = await Company.findOne({ where: { email } });
    if (existingCompany) {
      return res.status(400).json({ error: 'Email already registered' });
    }

    const company = await Company.create({
      email,
      password,
      name: companyName,
      plan: 'starter',
      status: 'active'
    });

    const token = jwt.sign(
      { companyId: company.id, email: company.email },
      config.auth.jwtSecret,
      { expiresIn: '7d' }
    );

    res.status(201).json({
      message: 'Company registered successfully',
      company: {
        id: company.id,
        email: company.email,
        name: company.name,
        plan: company.plan
      },
      token
    });
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({ error: error.message });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password required' });
    }

    const company = await Company.findOne({ where: { email } });
    if (!company) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    if (company.password !== password) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const token = jwt.sign(
      { companyId: company.id, email: company.email },
      config.auth.jwtSecret,
      { expiresIn: '7d' }
    );

    res.json({
      message: 'Login successful',
      company: {
        id: company.id,
        email: company.email,
        name: company.name,
        plan: company.plan
      },
      token
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: error.message });
  }
};
