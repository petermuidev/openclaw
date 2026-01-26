import os
from openai import OpenAI

# Load from .env (or set directly)
MINIMAX_API_KEY = os.getenv('MINIMAX_API_KEY', 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJHcm91cE5hbWUiOiJTbm93IEpvaG4iLCJVc2VyTmFtZSI6IlNub3cgSm9obiIsIkFjY291bnQiOiIiLCJTdWJqZWN0SUQiOiIxOTY2Mzc3NjMwMjE1MTg1MTEyIiwiUGhvbmUiOiIiLCJHcm91cElEIjoiMTk2NjM3NzYzMDIxMDk4NjcxMiIsIlBhZ2VOYW1lIjoiIiwiTWFpbCI6ImpvaG4wMDI1MDcwOEBnbWFpbC5jb20iLCJDcmVhdGVUaW1lIjoiMjAyNS0wOS0xNiAxMDo0NToxNiIsIlRva2VuVHlwZSI6MSwiaXNzIjoibWluaW1heCJ9.OhodgsM7URdE476H77dOH4i6RGE_HC78PXTh8Dh-wSOnUKf62go9pU-l5EQSWinHjTd77ZG4b9vqZ6BZGVGJzgrBoj9eJRMEdsBIO8pBT6TaVN9JVztKVjb9q-ET3MKsCsin6_cFNoBzdM4evYZ1FR6PNHNO_wZSjRNRq3R6tekwKSvqfMiGitsV5e8Qd3DfiquBAmH8iEJq6GR28WYezE4Z1YokeRHRE8xuaYXF4urcy1MVQc8aEgpZiK7TzDSQIAxCPKNzLxkZtIpt0QDdxkyPPqyC_UM7bAipewK6k-s135_EYibZXtadJPDIBGPUT79ScaxwCR141W4yB7C32A')
MINIMAX_BASE_URL = os.getenv('MINIMAX_BASE_URL', 'https://api.minimax.io/v1')
MINIMAX_MODEL = os.getenv('MINIMAX_MODEL', 'MiniMax-M2.1')

# Initialize client
client = OpenAI(
    api_key=MINIMAX_API_KEY,
    base_url=MINIMAX_BASE_URL
)

try:
    # Test chat completion
    response = client.chat.completions.create(
        model=MINIMAX_MODEL,
        messages=[{"role": "user", "content": "Test connection - respond with 'OK'"}],
        max_tokens=5
    )
    print(f"✅ Success! Response: {response.choices[0].message.content}")
except Exception as e:
    print(f"❌ Failed: {str(e)}")
