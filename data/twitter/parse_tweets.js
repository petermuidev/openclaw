const fs = require('fs');
const content = fs.readFileSync('C:/Users/Administrator/Desktop/New folder/data/twitter/all_jan16-27_raw.txt', 'utf8');

const blocks = content.split(/──────────────────────────────────────────────────+/);
const tweets = [];

blocks.forEach(block => {
  if (!block.includes('davispeet')) return;
  
  const tweet = {};
  
  const rtMatch = block.match(/RT @(\w+):/);
  tweet.original_author = rtMatch ? rtMatch[1] : null;
  
  const dateMatch = block.match(/(Mon|Tue|Wed|Thu|Fri|Sat|Sun) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (\d{1,2}) (\d{2}:\d{2}:\d{2}) \+0000 (\d{4})/);
  if (dateMatch) {
    tweet.timestamp = dateMatch[0];
    tweet.parsed_date = new Date(dateMatch[0] + ' UTC').toISOString();
  }
  
  const urlMatch = block.match(/https:\/\/x\.com\/davispeet\/status\/\d+/);
  tweet.url = urlMatch ? urlMatch[0] : null;
  
  const idMatch = block.match(/status\/(\d+)/);
  tweet.tweet_id = idMatch ? idMatch[1] : null;
  
  const imgMatch = block.match(/https:\/\/pbs\.twimg\.com\/media\/[^\s\n]+/);
  tweet.image = imgMatch ? imgMatch[0] : null;
  
  tweet.content_type = tweet.image ? 'image' : 'link_dump';
  
  if (tweet.timestamp) tweets.push(tweet);
});

tweets.sort((a, b) => (a.parsed_date || '').localeCompare(b.parsed_date || ''));

const output = {
  account: 'davispeet',
  period: '2026-01-16 to 2026-01-27',
  total_retweets: tweets.length,
  generated: new Date().toISOString(),
  retweets: tweets
};

fs.writeFileSync('C:/Users/Administrator/Desktop/New folder/data/twitter/all_retweets.json', JSON.stringify(output, null, 2), 'utf8');
console.log('Saved ' + tweets.length + ' retweets to all_retweets.json');
