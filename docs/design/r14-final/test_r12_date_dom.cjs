const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
let DOMLibrary;try{DOMLibrary=require('jsdom')}catch{DOMLibrary=require('/tmp/lixiang-r12-dom-regression/node_modules/jsdom')}
const {JSDOM,VirtualConsole}=DOMLibrary;
const modes=[...new Set(JSON.parse(fs.readFileSync('screens.json','utf8')).map(r=>r.mode))];
const base='https://lixiang-review.test/';const results=[];let executions=0;
function load(relative,regression=false){
 const url=new URL(relative,base);const file=path.basename(url.pathname);let source=fs.readFileSync(file,'utf8');if(regression){const fixed="qa('p[data-almanac-date],p[data-date-label=\"selected\"]').forEach(n=>{if(n.childElementCount===0)n.textContent=r11DateLabel;});";assert.ok(source.includes(fixed));source=source.replace(fixed,"qa('[data-almanac-date],[data-selected-date]').forEach(n=>n.textContent=r11DateLabel);");}const errors=[];const vc=new VirtualConsole();
 vc.on('jsdomError',e=>{if(e.type==='unhandled exception')errors.push(e.message)});
 const dom=new JSDOM(source,{url:url.href,runScripts:'dangerously',virtualConsole:vc,beforeParse(window){window.HTMLElement.prototype.scrollIntoView=function(){};window.matchMedia=()=>({matches:false,addListener(){},removeListener(){}});}});
 executions++;assert.deepEqual(errors,[],file+' runtime errors');
 const d=dom.window.document;assert.ok(d.querySelector('.device .workspace'),file+' lost workspace');assert.ok(d.querySelector('.workspace>.lead')&&d.querySelector('.workspace>.detail'),file+' lost panes');
 const links=d.querySelectorAll('a[href]');assert.ok(links.length>=6,file+' lost navigation');
 const root=d.querySelector('.device');assert.ok(root.childElementCount>=1,file+' root was overwritten');
 return {dom,d,url,close(){dom.window.close()}};
}
function relative(href){const u=new URL(href,base);return path.basename(u.pathname)+u.search;}
function expectDate(page,date){const leaf=page.d.querySelector('p[data-almanac-date],p[data-date-label="selected"]');assert.ok(leaf);assert.equal(leaf.childElementCount,0);assert.equal(leaf.textContent,new Intl.DateTimeFormat('zh-CN',{year:'numeric',month:'long',day:'numeric',weekday:'long',timeZone:'UTC'}).format(new Date(date+'T12:00:00Z')));assert.equal(page.url.searchParams.get('date'),date);}
for(const mode of modes){
 const home=load('home-'+mode+'.html');const cell=home.d.querySelector('[data-date="2026-11-22"]');assert.ok(cell,mode+' missing calendar day');const target=relative(cell.href);home.close();
 const almanac=load(target);expectDate(almanac,'2026-11-22');assert.equal(almanac.d.querySelector('.device').dataset.selectedDate,'2026-11-22');
 const compassHref=relative(almanac.d.querySelector('.bar-controls [data-r11-compass-link]').href);const prev=relative(almanac.d.querySelector('[data-date-step="-1"]').href);const next=relative(almanac.d.querySelector('[data-date-step="1"]').href);almanac.close();
 const compass=load(compassHref);expectDate(compass,'2026-11-22');assert.equal(compass.d.querySelectorAll('.compass-board .pin').length,5);const back=relative(compass.d.querySelector('.floating-back').href);compass.close();
 const returned=load(back);expectDate(returned,'2026-11-22');returned.close();
 const previous=load(prev);expectDate(previous,'2026-11-21');previous.close();
 const following=load(next);expectDate(following,'2026-11-23');following.close();
 results.push({mode,calendarToAlmanac:true,compassAndReturn:true,previousAndNext:true,rootAndLinksPreserved:true});
 console.log('PASS full DOM dated chain',mode);
}
for(const [date,expectedPrev,expectedNext] of [['2026-12-31','2026-12-30','2027-01-01'],['2028-03-01','2028-02-29','2028-03-02'],['2026-03-01','2026-02-28','2026-03-02']]){
 const page=load('almanac-phone-light.html?date='+date);expectDate(page,date);const prev=relative(page.d.querySelector('[data-date-step="-1"]').href),next=relative(page.d.querySelector('[data-date-step="1"]').href);page.close();
 const a=load(prev);expectDate(a,expectedPrev);a.close();const b=load(next);expectDate(b,expectedNext);b.close();
}
assert.throws(()=>load('almanac-phone-light.html?date=2026-11-22',true),/lost workspace/);
fs.writeFileSync('R12-DATE-DOM-REGRESSION.json',JSON.stringify({method:'jsdom 26 actual DOM and complete generated inline scripts; no browser paint or network; scrollIntoView/matchMedia layout adapters only',executions,successfulExecutions:executions-1,originalBugReproducedAndRejected:true,results,boundaries:['year','leap year','non-leap year'],allPass:true},null,2));
console.log('PASS',executions,'complete-document script executions');
