const axios = require('axios');
const { replicateApiToken } = require('../../config');

// Replicate API model URL (örnek: stable-diffusion-3.5-medium)
const REPLICATE_MODEL_URL = 'https://api.replicate.com/v1/models/stability-ai/stable-diffusion-3.5-medium/predictions';

// Gerçek API fonksiyonu
async function callReplicateApi(fullPrompt) {
  try {
    // Token ve prompt'u logla (token'ın tamamını paylaşma, güvenlik için sadece ilk 6 karakterini göster)
    console.log('Replicate API Token:', replicateApiToken ? replicateApiToken.slice(0, 6) + '...' : 'YOK');
    console.log('Prompt:', fullPrompt);

    const response = await axios.post(
      REPLICATE_MODEL_URL,
      {
        input: {
          prompt: fullPrompt
        }
      },
      {
        headers: {
          'Authorization': `Bearer ${replicateApiToken}`,
          'Content-Type': 'application/json',
          'Prefer': 'wait'
        }
      }
    );
    // Başarılı yanıtı logla
    console.log('Replicate API Response:', response.data);
    return response.data;
  } catch (error) {
    console.error('generateTattoo hata:', error);
    if (error.response && error.response.status) {
      return res.status(error.response.status).json({ error: error.response.data || error.message });
    }
    res.status(500).json({ error: error.message || 'Internal server error' });
  }
}

// Mock fonksiyon
async function callReplicateApiMock(fullPrompt) {
  return {
    id: 'mocked-prediction-id',
    model: 'stability-ai/stable-diffusion-3.5-medium',
    input: { prompt: fullPrompt },
    output: [
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80'
    ],
    status: 'succeeded',
    created_at: new Date().toISOString(),
    urls: {
      get: 'https://api.replicate.com/v1/predictions/mocked-prediction-id'
    }
  };
}

// Ortam değişkenine göre export
const useMock = process.env.USE_REPLICATE_MOCK === 'true';

module.exports = {
  callReplicateApi: useMock ? callReplicateApiMock : callReplicateApi,
  callReplicateApiMock,
  callReplicateApiReal: callReplicateApi
}; 
