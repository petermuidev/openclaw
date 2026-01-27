# Heroku Deployment

Deploy from `/Users/json/Desktop/clawbot` (not clawsamui folder).

```bash
cd /Users/json/Desktop/clawbot
git init
git add .
git commit -m "Initial deploy"

heroku login
heroku create your-app-name

# Set config vars
heroku config:set CLAWDBOT_GATEWAY_TOKEN=your-secret-token
heroku config:set MINIMAX_API_KEY=your-minimax-key
heroku config:set TELEGRAM_BOT_TOKEN=your-telegram-token
heroku config:set PERPLEXITY_API_KEY=your-perplexity-key
heroku config:set R2_ACCESS_KEY_ID=your-key
heroku config:set R2_SECRET_ACCESS_KEY=your-secret
heroku config:set R2_BUCKET=samui
heroku config:set R2_PUBLIC_BASE_URL=https://pub-599c201f5f884b2199d29c4e1e2e43d2.r2.dev

# Deploy
git push heroku main
heroku open
```

## Addons (optional)

```bash
heroku addons:create supabase:free
heroku addons:create heroku-postgresql:hobby-dev
```

## Telegram Webhook

```
https://your-app.herokuapp.com/telegram/webhook
```

## Access UI

```
https://your-app.herokuapp.com/?token=your-secret-token
```
