# Clawdbot: Heroku Deployment

## Deploy to Heroku

```bash
cd /Users/json/Desktop/clawbot
heroku login
heroku create your-app-name
heroku config:set CLAWDBOT_GATEWAY_TOKEN=your-secret-token
heroku config:set MINIMAX_API_KEY=your-minimax-key
heroku config:set TELEGRAM_BOT_TOKEN=your-telegram-token
heroku config:set PERPLEXITY_API_KEY=your-perplexity-key
heroku config:set R2_ACCESS_KEY_ID=your-r2-key
heroku config:set R2_SECRET_ACCESS_KEY=your-r2-secret
heroku config:set R2_BUCKET=samui
heroku config:set R2_PUBLIC_BASE_URL=https://pub-599c201f5f884b2199d29c4e1e2e43d2.r2.dev
git add .
git commit -m "Deploy to Heroku"
git push heroku main
heroku open
```

## Access

- **UI:** `https://your-app-name.herokuapp.com/?token=your-secret-token`
- **Telegram:** Set webhook to `https://your-app-name.herokuapp.com/telegram/webhook`

## Local Run

```bash
cd /Users/json/Desktop/clawbot/clawdbot
pnpm install
pnpm ui:build
pnpm build
CLAWDBOT_STATE_DIR=/Users/json/Desktop/clawbot \
CLAWDBOT_CONFIG_PATH=/Users/json/Desktop/clawbot/clawdbot.json \
clawdbot gateway --port 18789 --verbose
```

## Skills Installed

- self-improving-agent
- gog
- wacli
- agent-browser
- clawddocs
- summarize
- coding-agent
- humanizer
- clawdhub
- github
- superdesign
- obsidian
- youtube-watcher
- claude-connect
- marketing-mode
- slack
- search-x
- yahoo-finance
- notion
- spotify-player
- research
- gemini-deep-research
- web-search-plus
- perplexity-sonar
- competitive-intelligence-market-research
- chutes-image-gen

## Plugins Enabled

- lobster (workflows)
- llm-task (JSON LLM tool)
- telegram (channel)

## Environment Variables (see /Users/json/Desktop/clawbot/.env)

- MINIMAX_API_KEY
- TELEGRAM_BOT_TOKEN
- PERPLEXITY_API_KEY
- CLAWDBOT_GATEWAY_TOKEN
- R2_*
- SUPABASE_*
