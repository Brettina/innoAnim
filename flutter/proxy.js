const http = require('http');
const httpProxy = require('http-proxy');

const targetServer = 'http://localhost:5000'; // Replace with the address of your local server

const proxy = httpProxy.createProxyServer();

const server = http.createServer((req, res) => {
  proxy.web(req, res, { target: targetServer });
});

server.listen(8000, () => {
  console.log('Proxy server listening on port 8000');
});
