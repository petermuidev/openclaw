const fs = require('fs');
const data = JSON.parse(fs.readFileSync('C:/Users/Administrator/Desktop/New folder/data/twitter/all_retweets.json', 'utf8'));

const jan16_27 = data.retweets.filter(t => {
  if (!t.parsed_date) return false;
  const date = new Date(t.parsed_date);
  const start = new Date('2026-01-16');
  const end = new Date('2026-01-28');
  return date >= start && date < end;
});

const output = {
  account: 'davispeet',
  period: '2026-01-16 to 2026-01-27',
  total_retweets: jan16_27.length,
  generated: new Date().toISOString(),
  retweets: jan16_27
};

fs.writeFileSync('C:/Users/Administrator/Desktop/New folder/data/twitter/all_retweets.json', JSON.stringify(output, null, 2), 'utf8');
console.log('Saved ' + jan16_27.length + ' retweets (Jan 16-27, 2026) to all_retweets.json');
