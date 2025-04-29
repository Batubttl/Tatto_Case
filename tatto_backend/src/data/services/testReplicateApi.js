const { callReplicateApi } = require('./replicateApiService');

(async () => {
  try {
    const result = await callReplicateApi(
      "a captivating anime-style illustration of a woman in a white astronaut suit.",
      "minimalist blackwork tattoo"
    );
    console.log('API Response:', result);
  } catch (err) {
    console.error('API Error:', err);
  }
})(); 