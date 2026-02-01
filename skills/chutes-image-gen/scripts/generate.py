#!/usr/bin/env python3
"""
Chutes Image Generation Script

Generate or edit images via Chutes Image API.
"""

import argparse
import base64
import datetime as dt
import json
import os
import sys
import urllib.error
import urllib.request
from pathlib import Path


def slugify(text: str) -> str:
    """Convert text to a filename-friendly slug."""
    import re

    text = text.lower().strip()
    text = re.sub(r"[^a-z0-9]+", "-", text)
    text = re.sub(r"-{2,}", "-", text).strip("-")
    return text or "image"


def default_out_dir() -> Path:
    """Get default output directory."""
    now = dt.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
    preferred = Path.home() / "Projects" / "tmp"
    base = preferred if preferred.is_dir() else Path("./tmp")
    base.mkdir(parents=True, exist_ok=True)
    return base / f"chutes-image-gen-{now}"


def resolve_api_token() -> str:
    """Resolve Chutes API token from env or config."""
    token = os.environ.get("CHUTES_API_TOKEN", "").strip()
    if token:
        return token

    # Try config file
    config_path = Path(os.path.expanduser("~/.clawdbot/clawdbot.json"))
    if config_path.exists():
        try:
            with open(config_path) as f:
                config = json.load(f)
            skills = config.get("skills", {}).get("chutes-image-gen", {})
            token = skills.get("env", {}).get("CHUTES_API_KEY", "")
            if not token:
                token = skills.get("apiKey", "")
        except Exception:
            pass

    if not token:
        print(
            "Error: CHUTES_API_TOKEN not set. Set it via env or config.",
            file=sys.stderr,
        )
        sys.exit(1)

    return token


def resolve_endpoint() -> str:
    """Resolve API endpoint."""
    return os.environ.get("CHUTES_ENDPOINT", "https://image.chutes.ai/generate")


def generate_image(
    prompt: str,
    output_path: Path,
    model: str = "Qwen-Image-2512",
    negative_prompt: str = "",
    guidance_scale: float = 7.5,
    width: int = 1024,
    height: int = 1024,
    steps: int = 50,
    seed: int = None,
) -> None:
    """Generate an image using the Chutes API."""
    token = resolve_api_token()
    endpoint = resolve_endpoint()

    payload = {
        "model": model,
        "prompt": prompt,
        "negative_prompt": negative_prompt,
        "guidance_scale": guidance_scale,
        "width": width,
        "height": height,
        "num_inference_steps": steps,
    }

    if seed is not None:
        payload["seed"] = seed

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
    }

    print(f"Generating image with model: {model}")

    try:
        req = urllib.request.Request(
            endpoint,
            data=json.dumps(payload).encode("utf-8"),
            headers=headers,
            method="POST",
        )

        with urllib.request.urlopen(req, timeout=120) as response:
            content_type = response.headers.get("Content-Type", "")
            raw_data = response.read()

            image_bytes = None

            # Check if response is direct binary image
            if "image" in content_type or raw_data[0:1] in (b"\x89", b"\xff", b"\x8a"):
                image_bytes = raw_data
            else:
                # Try JSON response
                result = json.loads(raw_data.decode("utf-8"))

                if isinstance(result, dict):
                    # Check for base64 image
                    if "image" in result:
                        image_bytes = base64.b64decode(result["image"])
                    elif "images" in result and len(result["images"]) > 0:
                        image_bytes = base64.b64decode(result["images"][0])
                    else:
                        # Try to find image URL
                        image_url = result.get("url") or result.get("output_url")
                        if image_url:
                            # Download from URL
                            req2 = urllib.request.Request(image_url)
                            with urllib.request.urlopen(req2, timeout=60) as resp2:
                                image_bytes = resp2.read()
                        else:
                            print(
                                f"Error: Unexpected response format: {json.dumps(result)}",
                                file=sys.stderr,
                            )
                            sys.exit(1)
                else:
                    print(f"Error: Unexpected response: {result}", file=sys.stderr)
                    sys.exit(1)

        if not image_bytes:
            print("Error: Could not get image data", file=sys.stderr)
            sys.exit(1)

        # Save image
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_bytes(image_bytes)

        # Print MEDIA line for Clawdbot
        print(f"\nMEDIA:{output_path}")
        print(f"\nImage saved to: {output_path}")

    except urllib.error.HTTPError as e:
        error_body = e.read().decode("utf-8") if e.fp else ""
        print(f"Error: HTTP {e.code} - {error_body}", file=sys.stderr)
        sys.exit(1)
    except urllib.error.URLError as e:
        print(f"Error: URL error - {e.reason}", file=sys.stderr)
        sys.exit(1)


def edit_image(
    prompt: str,
    input_image: str,
    output_path: Path,
    model: str = "Qwen-Image-Edit-2511",
    negative_prompt: str = "",
    guidance_scale: float = 7.5,
    width: int = None,
    height: int = None,
    steps: int = 50,
) -> None:
    """Edit an image using the Chutes API."""
    token = resolve_api_token()
    endpoint = os.environ.get("CHUTES_ENDPOINT_EDIT", "https://image.chutes.ai/edit")

    # Read and encode input image
    input_path = Path(input_image)
    if not input_path.exists():
        print(f"Error: Input image not found: {input_image}", file=sys.stderr)
        sys.exit(1)

    with open(input_path, "rb") as f:
        input_b64 = base64.b64encode(f.read()).decode("utf-8")

    payload = {
        "model": model,
        "prompt": prompt,
        "image": input_b64,
        "negative_prompt": negative_prompt,
        "guidance_scale": guidance_scale,
        "num_inference_steps": steps,
    }

    if width:
        payload["width"] = width
    if height:
        payload["height"] = height

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
    }

    print(f"Editing image with model: {model}")

    try:
        req = urllib.request.Request(
            endpoint,
            data=json.dumps(payload).encode("utf-8"),
            headers=headers,
            method="POST",
        )

        with urllib.request.urlopen(req, timeout=120) as response:
            content_type = response.headers.get("Content-Type", "")
            raw_data = response.read()

            image_bytes = None

            if "image" in content_type:
                image_bytes = raw_data
            else:
                result = json.loads(raw_data.decode("utf-8"))

                if isinstance(result, dict):
                    if "image" in result:
                        image_bytes = base64.b64decode(result["image"])
                    elif "images" in result and len(result["images"]) > 0:
                        image_bytes = base64.b64decode(result["images"][0])
                    else:
                        image_url = result.get("url") or result.get("output_url")
                        if image_url:
                            req2 = urllib.request.Request(image_url)
                            with urllib.request.urlopen(req2, timeout=60) as resp2:
                                image_bytes = resp2.read()
                        else:
                            print(
                                f"Error: Unexpected response format: {json.dumps(result)}",
                                file=sys.stderr,
                            )
                            sys.exit(1)
                else:
                    print(f"Error: Unexpected response: {result}", file=sys.stderr)
                    sys.exit(1)

        if not image_bytes:
            print("Error: Could not get image data", file=sys.stderr)
            sys.exit(1)

        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_bytes(image_bytes)

        print(f"\nMEDIA:{output_path}")
        print(f"\nEdited image saved to: {output_path}")

    except urllib.error.HTTPError as e:
        error_body = e.read().decode("utf-8") if e.fp else ""
        print(f"Error: HTTP {e.code} - {error_body}", file=sys.stderr)
        sys.exit(1)
    except urllib.error.URLError as e:
        print(f"Error: URL error - {e.reason}", file=sys.stderr)
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(
        description="Generate or edit images via Chutes Image API"
    )
    parser.add_argument("--prompt", "-p", required=True, help="Image prompt")
    parser.add_argument(
        "--filename",
        "-f",
        default=None,
        help="Output filename (default: auto-generated)",
    )
    parser.add_argument(
        "--model",
        "-m",
        default="Qwen-Image-2512",
        help="Model to use (default: Qwen-Image-2512)",
    )
    parser.add_argument("--negative-prompt", "-n", default="", help="Negative prompt")
    parser.add_argument(
        "--guidance",
        "-g",
        type=float,
        default=7.5,
        help="Guidance scale (default: 7.5)",
    )
    parser.add_argument(
        "--width", "-W", type=int, default=1024, help="Image width (default: 1024)"
    )
    parser.add_argument(
        "--height", "-H", type=int, default=1024, help="Image height (default: 1024)"
    )
    parser.add_argument(
        "--steps", "-s", type=int, default=50, help="Inference steps (default: 50)"
    )
    parser.add_argument(
        "--seed", type=int, default=None, help="Random seed (default: random)"
    )
    parser.add_argument(
        "--input-image", "-i", default=None, help="Input image for editing"
    )
    parser.add_argument(
        "--out-dir",
        "-o",
        default=None,
        help="Output directory (default: ~/Projects/tmp or ./tmp)",
    )

    args = parser.parse_args()

    # Resolve output directory and filename
    out_dir = Path(args.out_dir) if args.out_dir else default_out_dir()

    if args.filename:
        if not args.filename.endswith((".png", ".jpg", ".jpeg", ".webp")):
            args.filename += ".png"
        output_path = out_dir / args.filename
    else:
        timestamp = dt.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
        safe_prompt = slugify(args.prompt)[:20]
        output_path = out_dir / f"{timestamp}-{safe_prompt}.png"

    # Check for edit mode
    if args.input_image:
        edit_image(
            prompt=args.prompt,
            input_image=args.input_image,
            output_path=output_path,
            model=args.model,
            negative_prompt=args.negative_prompt,
            guidance_scale=args.guidance,
            width=args.width if args.width != 1024 else None,
            height=args.height if args.height != 1024 else None,
            steps=args.steps,
        )
    else:
        generate_image(
            prompt=args.prompt,
            output_path=output_path,
            model=args.model,
            negative_prompt=args.negative_prompt,
            guidance_scale=args.guidance,
            width=args.width,
            height=args.height,
            steps=args.steps,
            seed=args.seed,
        )


if __name__ == "__main__":
    main()
