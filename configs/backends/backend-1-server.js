const express = require('express');
const app = express();
const os = require('os');
const port = 8080;

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
        <title>Backend 1</title>
        <style>
            body { 
                font-family: Arial, sans-serif; 
                max-width: 800px; 
                margin: 50px auto;
                padding: 20px;
            }
            .info { 
                background: #e3f2fd; 
                padding: 20px; 
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .metric { 
                margin: 10px 0;
                padding: 8px;
                background: white;
                border-radius: 4px;
            }
            h1 { color: #1976d2; }
        </style>
    </head>
    <body>
        <h1>🟢 Backend Server 1</h1>
        <div class="info">
            <div class="metric"><strong>Hostname:</strong> ${hostname}</div>
            <div class="metric"><strong>Puerto:</strong> ${port}</div>
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
    server: 'backend-1',
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Backend 1 escuchando en puerto ${port}`);
  console.log(`Hora de inicio: ${new Date().toISOString()}`);
});
