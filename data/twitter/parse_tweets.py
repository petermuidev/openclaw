import re
import json
from datetime import datetime

with open('/c/Users/Administrator/Desktop/New folder/data/twitter/all_jan16-27_raw.txt', 'r') as f:
    content = f.read()

tweets = []
blocks = content.split('─' * 64)

for block in blocks:
    if '📅' not in block or 'davispeet' not in block.lower():
        continue
    
    tweet = {}
    
    # Extract author (RT @username)
    rt_match = re.search(r'RT @(\w+):', block)
    if rt_match:
        tweet['original_author'] = rt_match.group(1)
    else:
        tweet['original_author'] = None
    
    # Extract date
    date_match = re.search(r'📅 (.+?) \+0000 (\d{4})', block)
    if date_match:
        date_str = f"{date_match.group(1)} {date_match.group(2)}"
        tweet['timestamp'] = date_str
        try:
            tweet['parsed_date'] = datetime.strptime(date_str, '%a %b %d %H:%M:%S %Y').isoformat()
        except:
            tweet['parsed_date'] = None
    
    # Extract URL
    url_match = re.search(r'🔗 (https://x\.com/davispeet/status/\d+)', block)
    if url_match:
        tweet['url'] = url_match.group(1)
    
    # Extract status ID
    id_match = re.search(r'status/(\d+)', block)
    if id_match:
        tweet['tweet_id'] = id_match.group(1)
    
    # Extract image
    img_match = re.search(r'🖼️ (https://pbs\.twimg\.com/media/[^\s]+)', block)
    if img_match:
        tweet['image'] = img_match.group(1)
    
    # Extract content (first line after username)
    lines = [l.strip() for l in block.split('\n') if l.strip()]
    for line in lines:
        if line.startswith('@davispeet'):
            continue
        if 'RT @' in line or '📅' in line or '🔗' in line or '🖼️' in line:
            continue
        if line.strip():
            tweet['content_preview'] = line[:200] if len(line) > 200 else line
            break
    
    if tweet.get('timestamp'):
        tweets.append(tweet)

# Sort by date
tweets.sort(key=lambda x: x.get('parsed_date', ''))

output = {
    'account': 'davispeet',
    'period': '2026-01-16 to 2026-01-27',
    'total_retweets': len(tweets),
    'generated': datetime.now().isoformat(),
    'retweets': tweets
}

with open('/c/Users/Administrator/Desktop/New folder/data/twitter/all_retweets.json', 'w', encoding='utf-8') as f:
    json.dump(output, f, indent=2, ensure_ascii=False)

print(f"✓ Saved {len(tweets)} retweets to all_retweets.json")
