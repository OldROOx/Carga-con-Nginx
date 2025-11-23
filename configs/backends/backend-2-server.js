const express = require('express');
const app = express();
const os = require('os');
const port = 8081;

// Contador de requests
let requestCount = 0;

app.get('/', (req, res) => {
  requestCount++;
  const hostname = os.hostname();
  const ip = req.headers['x-real-ip'] || req.socket.remoteAddress;
  const loadavg = os.loadavg();
  
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
        <title>Backend 2</title>
        <style>
            body { font-family: Arial; max-width: 800px; margin: 50px auto; }
            .info { background: #e3f2fd; padding: 20px; border-radius: 5px; }
            .metric { margin: 10px 0; }
        </style>
    </head>
    <body>
        <h1>🟢 Backend Server 2</h1>
        <div class="info">
            <div class="metric"><strong>Hostname:</strong> ${hostname}</div>
            <div class="metric"><strong>Puerto:</strong> 8081</div>
            <div class="metric"><strong>IP Cliente:</strong> ${ip}</div>
            <div class="metric"><strong>Requests atendidos:</strong> ${requestCount}</div>
            <div class="metric"><strong>Load Average:</strong> ${loadavg.join(', ')}</div>
            <div class="metric"><strong>Memoria libre:</strong> ${Math.round(os.freemem()/1024/1024)} MB</div>
            <div class="metric"><strong>Timestamp:</strong> ${new Date().toISOString()}</div>
        </div>
    </body>
    </html>
  `);
});

app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'healthy',
    server: 'backend-2',
    uptime: process.uptime()
  });
});

app.get('/api/stats', (req, res) => {
  res.json({
    hostname: os.hostname(),
    port: port,
    requests: requestCount,
    loadavg: os.loadavg(),
    memory: {
      total: os.totalmem(),
      free: os.freemem()
    },
    uptime: process.uptime()
  });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Backend 2 escuchando en puerto ${port}`);
});
