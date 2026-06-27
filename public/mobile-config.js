// Android/WebView builds must point API calls at a public Mineradio API server.
// Use an HTTPS domain for real mobile use. Leave empty for Windows Electron,
// where /api is served by the local Electron-started server.js.
window.MINERADIO_API_BASE = window.MINERADIO_API_BASE || '';
