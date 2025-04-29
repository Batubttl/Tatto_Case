const request = require('supertest');
const app = require('../../../server');

describe('POST /generate', () => {
  it('should return 200 and a prediction for valid input', async () => {
    const res = await request(app)
      .post('/generate')
      .send({ prompt: 'minimalist blackwork lion tattoo', style: 'geometric' });
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('id');
    expect(res.body).toHaveProperty('output');
    expect(Array.isArray(res.body.output)).toBe(true);
  });

  it('should return 400 for missing prompt', async () => {
    const res = await request(app)
      .post('/generate')
      .send({ style: 'geometric' });
    expect(res.statusCode).toBe(400);
    expect(res.body).toHaveProperty('error');
  });

  it('should return 400 for short prompt', async () => {
    const res = await request(app)
      .post('/generate')
      .send({ prompt: 'abc', style: 'geometric' });
    expect(res.statusCode).toBe(400);
    expect(res.body).toHaveProperty('error');
  });

  it('should return 400 for invalid style', async () => {
    const res = await request(app)
      .post('/generate')
      .send({ prompt: 'minimalist blackwork lion tattoo', style: 'tribal' });
    expect(res.statusCode).toBe(400);
    expect(res.body).toHaveProperty('error');
  });
}); 