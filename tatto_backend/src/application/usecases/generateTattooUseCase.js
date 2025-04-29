const { callReplicateApi } = require('../../data/services/replicateApiService');
const TattooPrompt = require('../../domain/entities/tattooPrompt');

// Use case for generating a tattoo image
async function generateTattooUseCase(prompt, style, output) {
  // Entity oluştur
  const tattooPrompt = new TattooPrompt(prompt, style, output);
  // Promptu birleştir
  const fullPrompt = `${style} ${output} ${prompt}`;
  // Replicate API'yi çağır
  const result = await callReplicateApi(fullPrompt);
  return result;
}

module.exports = generateTattooUseCase; 