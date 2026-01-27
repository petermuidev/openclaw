---
name: chutes-image-gen
description: Generate or edit images via Chutes Image API (Qwen-Image, FLUX, etc.).
homepage: https://image.chutes.ai/
metadata: {"clawdbot":{"emoji":"🎨","requires":{"env":["CHUTES_API_TOKEN"]},"primaryEnv":"CHUTES_API_TOKEN","install":[]}}
---

# Chutes Image Gen

Generate images using the Chutes Image API.

## Generate Images

```bash
uv run {baseDir}/scripts/generate.py --prompt "your image description" --filename "output.png"
```

## Image Editing (Qwen-Image-Edit-2511)

```bash
uv run {baseDir}/scripts/edit.py --prompt "edit description" --input-image "/path/in.png" --filename "edited.png"
```

## Environment

- `CHUTES_API_TOKEN` - Your Chutes API token
- `CHUTES_IMAGE_ENDPOINT` - Text-to-image endpoint
- `CHUTES_IMAGE_EDIT_ENDPOINT` - Image editing endpoint

## Models

- `Qwen-Image-2512` - Text-to-image
- `z-image-turbo` - Fast text-to-image
- `Qwen-Image-Edit-2511` - Image editing
