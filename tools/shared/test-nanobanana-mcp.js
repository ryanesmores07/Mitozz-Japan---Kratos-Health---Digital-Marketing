const { spawn } = require("node:child_process");
const { resolve } = require("node:path");

const launcherPath = resolve(
  "C:/Users/esmoresernieryanocam/Desktop/Workspace/Mitozz Japan/tools/run-nanobanana-mcp.ps1",
);

const child = spawn(
  "C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
  ["-NoProfile", "-ExecutionPolicy", "Bypass", "-File", launcherPath],
  {
    stdio: ["pipe", "pipe", "pipe"],
  },
);

const requests = [
  {
    jsonrpc: "2.0",
    id: 1,
    method: "initialize",
    params: {
      protocolVersion: "2024-11-05",
      capabilities: {},
      clientInfo: { name: "mitozz-nanobanana-smoke-test", version: "1.0.0" },
    },
  },
  {
    jsonrpc: "2.0",
    method: "notifications/initialized",
    params: {},
  },
  {
    jsonrpc: "2.0",
    id: 2,
    method: "tools/list",
    params: {},
  },
];

let stdout = "";
let stderr = "";
let resolved = false;

const timer = setTimeout(() => {
  if (!resolved) {
    child.kill();
    console.error("Timed out waiting for Nano Banana MCP response");
    if (stderr) {
      console.error(stderr.trim());
    }
    process.exit(1);
  }
}, 15000);

child.stdout.on("data", (chunk) => {
  stdout += chunk.toString();

  const lines = stdout.split(/\r?\n/).filter(Boolean);
  for (const line of lines) {
    try {
      const message = JSON.parse(line);
      if (message.id === 2) {
        resolved = true;
        clearTimeout(timer);
        process.stdout.write(`${JSON.stringify(message, null, 2)}\n`);
        child.stdin.end();
        child.kill();
        process.exit(0);
      }
    } catch {
    }
  }
});

child.stderr.on("data", (chunk) => {
  stderr += chunk.toString();
});

child.on("close", (code) => {
  if (!resolved) {
    clearTimeout(timer);
    if (stderr.trim()) {
      console.error(stderr.trim());
    }
    process.exit(code ?? 1);
  }
});

for (const request of requests) {
  child.stdin.write(`${JSON.stringify(request)}\n`);
}
