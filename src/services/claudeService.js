const { GoogleGenerativeAI } = require('@google/generative-ai');
const config = require('../config');

const genAI = new GoogleGenerativeAI(config.gemini.apiKey);

class GeminiService {
  async generateResponse(agent, conversationHistory) {
    try {
      const model = genAI.getGenerativeModel({ model: 'gemini-pro' });

      const messages = conversationHistory.map((msg) => ({
        role: msg.sender === 'customer' ? 'user' : 'model',
        parts: [{ text: msg.content }],
      }));

      const chat = model.startChat({
        history: messages.slice(0, -1),
      });

      const lastMessage = conversationHistory[conversationHistory.length - 1];
      const result = await chat.sendMessage(lastMessage.content);
      const response = await result.response;

      return response.text();
    } catch (error) {
      console.error('Error generating response with Gemini:', error);
      throw error;
    }
  }

  async extractIntent(userMessage) {
    try {
      const model = genAI.getGenerativeModel({ model: 'gemini-pro' });

      const prompt = `Eres un analizador de intenciones. Analiza este mensaje del usuario y responde SOLO con un JSON válido (sin markdown):

Mensaje: "${userMessage}"

Responde exactamente en este formato JSON:
{
  "intent": "intención principal",
  "entities": {"clave": "valor"},
  "sentiment": "positivo|negativo|neutral"
}`;

      const result = await model.generateContent(prompt);
      const response = await result.response;
      const text = response.text();

      return JSON.parse(text);
    } catch (error) {
      console.error('Error extracting intent:', error);
      return { intent: 'unknown', entities: {}, sentiment: 'neutral' };
    }
  }
}

module.exports = new GeminiService();
