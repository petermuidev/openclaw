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
uv run {baseDir}/scripts/generate.py --prompt "your image description" --filename "output.png" --resolution 1024x1024
```

## Options

```bash
uv run {baseDir}/scripts/generate.py --prompt "a beautiful sunset" --filename "sunset.png" --width 1024 --height 1024 --steps 50 --guidance 7.5

# Use different models
uv run {baseDir}/scripts/generate.py --prompt "your prompt" --model "Qwen-Image-2512" --filename "output.png"
uv run {baseDir}/scripts/generate.py --prompt "your prompt" --model "z-image-turbo" --filename "output.png"
```

## Image Editing (Qwen-Image-Edit-2511)

```bash
uv run {baseDir}/scripts/edit.py --prompt "your edit description" --input-image "/path/in.png" --filename "edited.png"

# With options
uv run {baseDir}/scripts/edit.py \
  --prompt "Make it more vibrant" \
  --input-image "input.png" \
  --width 1024 --height 1024 \
  --steps 40 --cfg-scale 4 \
  --filename "edited.png"
```

## Environment

- `CHUTES_API_TOKEN` - Your Chutes API token (format: `cpk_...`)
- `CHUTES_IMAGE_ENDPOINT` - Text-to-image endpoint (default: `https://image.chutes.ai/generate`)
- `CHUTES_IMAGE_EDIT_ENDPOINT` - Image editing endpoint (default: `https://chutes-qwen-image-edit-2511.chutes.ai/generate`)

## Models

- `Qwen-Image-2512` - High quality text-to-image
- `z-image-turbo` - Fast text-to-image
- `Qwen-Image-Edit-2511` - Image editing

## Output

The script saves images and prints a `MEDIA:` line for Clawdbot to auto-attach.
