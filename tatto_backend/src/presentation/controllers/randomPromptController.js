const prompts = [
  "A geometric wolf tattoo",
  "Minimalist mountain landscape",
  "Classic rose with thorns",
  "Halloween pumpkin with smoke",
  "Elegant script quote",
  "Lion with crown",
  "Feather turning into birds",
  "Abstract watercolor splash"
];

exports.getRandomPrompt = (req, res) => {
  const randomIndex = Math.floor(Math.random() * prompts.length);
  res.json({ prompt: prompts[randomIndex] });
}; 