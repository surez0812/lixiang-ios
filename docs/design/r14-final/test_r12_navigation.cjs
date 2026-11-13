const fs=require('node:fs'), vm=require('node:vm'), assert=require('node:assert/strict');
const rows=JSON.parse(fs.readFileSync('screens.json','utf8')).filter(r=>r.page==='compass'&&!r.state);
const data=JSON.parse(fs.readFileSync('calendar-fixture.json','utf8'));const results=[];
function node(dataset={}){return {dataset,href:'',textContent:'',hidden:false,style:{},value:'5',attributes:{},setAttribute(k,v){this.attributes[k]=v},classList:{toggle(){}}}}
for(const row of rows){
 const html=fs.readFileSync(row.file+'.html','utf8');const source=html.slice(html.indexOf('function r11DateKey'),html.indexOf('</script>'));
 const nodes=new Map();const q=s=>{if(!nodes.has(s))nodes.set(s,node());return nodes.get(s)};
 const sets={'[data-date-step]':[node({dateStep:'-1'}),node({dateStep:'1'})],'p[data-almanac-date],p[data-date-label="selected"]':[node()],'[data-r11-compass-link]':[node()],'[data-r11-compass]':[node({r11Compass:'day'}),node({r11Compass:'hour'})],'[data-r11-direction]':Array.from({length:5},()=>node()),'.compass-board .pin':Array.from({length:5},()=>node())};
 const c={q,qa:s=>sets[s]||[],URLSearchParams,location:{search:'?date=2026-12-31'},document:{body:{classList:{contains:s=>s==='page-compass'}}}};vm.createContext(c);vm.runInContext(source,c);
 assert.ok(sets['[data-date-step]'][1].href.endsWith('?date=2027-01-01'));assert.ok(sets['[data-date-step]'][0].href.endsWith('?date=2026-12-30'));
 assert.equal(vm.runInContext("r11ShiftDate('2028-03-01',-1)",c),'2028-02-29');assert.equal(vm.runInContext("r11ShiftDate('2026-03-01',-1)",c),'2026-02-28');
 assert.ok(q('.floating-back').href.endsWith('?date=2026-12-31'));assert.ok(sets['[data-r11-compass-link]'][0].href.endsWith('?date=2026-12-31'));
 sets['[data-r11-compass]'][0].onclick();assert.deepEqual(sets['[data-r11-direction]'].map(n=>n.textContent),data.directions);assert.equal(q('.hour-choice').hidden,true);
 sets['[data-r11-compass]'][1].onclick();assert.equal(q('.hour-choice').hidden,false);
 for(let i=0;i<12;i++){q('#compass-hour').value=String(i);q('#compass-hour').onchange();assert.deepEqual(sets['[data-r11-direction]'].map(n=>n.textContent),data.hours[i].directions);assert.equal(q('[data-r11-sha]').textContent,data.hours[i].sha);}
 results.push({mode:row.mode,datedRoutes:true,yearAndLeapTransitions:true,dayDirections:true,all12Hours:true});
}
fs.writeFileSync('R12-NAVIGATION-TESTS.json',JSON.stringify({method:'Actual generated script with DOM state stubs, no browser paint validation',results},null,2));console.log('PASS 14 modes: dated navigation, leap/year boundaries, day + 12 hour switches');
