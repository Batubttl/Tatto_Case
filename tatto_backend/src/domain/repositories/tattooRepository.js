// Abstract repository for tattoo generation
class TattooRepository {
  async generateTattoo(prompt, style) {
    throw new Error('Not implemented');
  }
}

module.exports = TattooRepository; 