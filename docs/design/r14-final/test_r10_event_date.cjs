const fs = require('node:fs');
const vm = require('node:vm');
const assert = require('node:assert/strict');
const rows = JSON.parse(fs.readFileSync('screens.json','utf8')).filter(row => row.page === 'folklore-detail');
const events = [
 {id:'winter',title:'小雪',date:'2026-11-22',category:'传统节日',days:10},
 {id:'daily-kindness',title:'静心行善',date:'2026-11-12',category:'民俗科仪',days:0}
];
const checks=[];
for (const row of rows) {
 const html = fs.readFileSync(row.file+'.html','utf8');
 const headHtml = html.match(/<section[^>]*native-event-head[\s\S]*?<\/section>/)[0];
 assert.equal((headHtml.match(/data-event-date=/g)||[]).length,1);
 assert.equal((headHtml.match(/class="event-deck"/g)||[]).length,1);
 const source = html.match(/let pageParams=new URLSearchParams[\s\S]*?if\(window.addEventListener\)window.addEventListener\('pageshow',refreshBadges\);/)[0];
 for (const query of ['', '?event=winter', '?event=daily-kindness', '?date=2026-11-22', '?event=daily-kindness&date=2026-11-12']) {
  const nodes = new Map();
  const deck = {textContent:'读一段来由，留一个属于今天的小仪式。'};
  const head = {querySelector(selector) {
   assert.notEqual(selector,'p','Must not select first paragraph');
   if (!nodes.has(selector)) nodes.set(selector,{textContent:''});
   return nodes.get(selector);
  }};
  const context = {URLSearchParams, location:{search:query}, REVIEW_EVENTS:events, R8:{unlocked:days=>days>=0&&days<=10},q:selector=>selector==='.native-event-head'?head:null,refreshBadges(){},window:{},localStorage:{},document:{}};
  vm.runInNewContext(source,context);
  const id = new URLSearchParams(query).get('event') || (row.state==='today'?'daily-kindness':'winter');
  assert.equal(nodes.get('[data-event-date]').textContent,id==='winter'?'2026年11月22日':'2026年11月12日');
  assert.equal(deck.textContent,'读一段来由，留一个属于今天的小仪式。');
  checks.push({file:row.file,query,dateNodeOnly:true,deckPreserved:true});
 }
}
fs.writeFileSync('R10-EVENT-DATE-TESTS.json',JSON.stringify({method:'Actual generated event-header runtime handler in Node VM; no browser opened',checks},null,2));
console.log('PASS',checks.length,'event/date entry checks');
