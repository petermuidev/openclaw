# Clawdbot: what runs what (short)

- Gateway: the backend server (WebSocket control plane). It is required. It routes messages, runs agents, and serves the web UI.
- UI server: served by the Gateway. You do not run it separately. When the Gateway is up, the UI is available from the Gateway.
- Backend vs UI: the Gateway is the backend; the UI is just a web frontend that connects to it.

## Minimum to run (local)
1) Start the Gateway (this is enough).
2) Open the UI or use CLI commands.

## Run now (foreground)
```powershell
cd "C:\Users\Administrator\Desktop\New folder\clawdbot"
pnpm install
pnpm clawdbot gateway run --bind loopback --port 18789 --verbose
```

## Run as a service (recommended)
```powershell
cd "C:\Users\Administrator\Desktop\New folder\clawdbot"
pnpm clawdbot gateway install
pnpm clawdbot gateway start
```

## Check / stop
```powershell
pnpm clawdbot gateway probe
pnpm clawdbot gateway stop
```

## UI
- With Gateway running, the UI is served by it. (No separate UI server.)

## Notes
- Config uses `.env` in the repo automatically.
- Default model is `minimax/minimax-m2.1` using MiniMax Anthropic-compatible API.
- After any config change, restart the gateway.

## When you change config
```powershell
pnpm clawdbot gateway restart
```

## Config change checklist
1) Update config or `.env`
2) Restart gateway
3) Probe gateway

```powershell
pnpm clawdbot gateway restart
pnpm clawdbot gateway probe
```
