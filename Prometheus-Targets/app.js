const express = require('express');
const morgan = require('morgan');
const client = require('prom-client');

const app = express();
const startTime = Date.now();
const FIVE_MINUTES = 5 * 60 * 1000;

app.use(morgan('combined'));

// Prometheus metrics
const collectDefaultMetrics = client.collectDefaultMetrics;
collectDefaultMetrics();

const requestCounter = new client.Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['status_code']
});

app.get('/', (req, res) => {
  const withinFiveMinutes = (Date.now() - startTime) < FIVE_MINUTES;
  const randomFail = Math.random() < 0.05;

  let status;
  if (withinFiveMinutes && randomFail) {
    status = 500;
    res.status(500).send('Internal Server Error');
  } else {
    status = 200;
    res.status(200).send('OK');
  }

  requestCounter.inc({ status_code: status });
});

// Metrics endpoint
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', client.register.contentType);
  res.end(await client.register.metrics());
});

app.listen(3000, () => console.log('App running on port 3000'));
