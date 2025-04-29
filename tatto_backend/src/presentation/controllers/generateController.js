const generateTattooUseCase = require('../../application/usecases/generateTattooUseCase');
const axios = require('axios');

const ALLOWED_STYLES = ['blackwork', 'geometric', 'minimalist', 'Halloween'];
const ALLOWED_OUTPUTS = ['arm', 'leg', 'whitepaper', 'skin paper'];

// Controller for handling tattoo generation requests
exports.generateTattoo = async (req, res) => {
  try {
    console.log('--- /generate endpoint çağrıldı ---');
    console.log('Gelen body:', req.body);
    const { prompt, style, output } = req.body;

    // Prompt validasyonu
    if (!prompt || typeof prompt !== 'string') {
      console.log('Prompt validasyonu başarısız:', prompt);
      return res.status(400).json({ error: 'Prompt is required and must be a string.' });
    }
    if (prompt.length < 5) {
      console.log('Prompt çok kısa:', prompt);
      return res.status(400).json({ error: 'Prompt must be at least 5 characters.' });
    }
    if (prompt.length > 200) {
      console.log('Prompt çok uzun:', prompt);
      return res.status(400).json({ error: 'Prompt must be at most 200 characters.' });
    }

    // Style validasyonu
    if (!style || typeof style !== 'string') {
      console.log('Style validasyonu başarısız:', style);
      return res.status(400).json({ error: 'Style is required and must be a string.' });
    }
    if (!ALLOWED_STYLES.includes(style.toLowerCase())) {
      console.log('Style geçersiz:', style);
      return res.status(400).json({ error: `Style must be one of: ${ALLOWED_STYLES.join(', ')}` });
    }

    // Output validasyonu
    if (!output || typeof output !== 'string') {
      console.log('Output validasyonu başarısız:', output);
      return res.status(400).json({ error: 'Output is required and must be a string.' });
    }
    if (!ALLOWED_OUTPUTS.includes(output.toLowerCase())) {
      console.log('Output geçersiz:', output);
      return res.status(400).json({ error: `Output must be one of: ${ALLOWED_OUTPUTS.join(', ')}` });
    }

    console.log('Validasyonlar başarılı. generateTattooUseCase çağrılıyor:', { prompt, style, output });
    const result = await generateTattooUseCase(prompt, style.toLowerCase(), output.toLowerCase());
    console.log('generateTattooUseCase sonucu:', result);
    res.status(200).json(result);
  } catch (error) {
    console.error('generateTattoo hata:', error);
    res.status(500).json({ error: error.message || 'Internal server error' });
  }
};

// Prediction sonucunu Replicate API'den çekmek için GET /generate/:id
exports.getPredictionResult = async (req, res) => {
  const predictionId = req.params.id;
  if (!predictionId) {
    return res.status(400).json({ error: 'Prediction id is required.' });
  }
  try {
    const REPLICATE_GET_URL = `https://api.replicate.com/v1/predictions/${predictionId}`;
    const { replicateApiToken } = require('../../config');
    const response = await axios.get(REPLICATE_GET_URL, {
      headers: {
        'Authorization': `Bearer ${replicateApiToken}`,
        'Content-Type': 'application/json'
      }
    });

    const data = response.data;
    // output dizisinden imageUrl çıkar
    const imageUrl = Array.isArray(data.output) && data.output.length > 0 ? data.output[0] : '';
    res.status(200).json({
      status: data.status,
      imageUrl: imageUrl
    });
  } catch (error) {
    console.error('getPredictionResult hata:', error);
    res.status(error.response?.status || 500).json({ error: error.response?.data || error.message });
  }
};