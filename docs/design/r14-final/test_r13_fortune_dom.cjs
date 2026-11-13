const fs=require('node:fs'),assert=require('node:assert/strict');
let lib;try{lib=require('jsdom')}catch{lib=require('/tmp/lixiang-r12-dom-regression/node_modules/jsdom')}
const {JSDOM,VirtualConsole}=lib;const rows=JSON.parse(fs.readFileSync('screens.json','utf8')).filter(r=>r.page==='fortune');const results=[];
for(const row of rows){
 const errors=[],vc=new VirtualConsole();vc.on('jsdomError',e=>{if(e.type==='unhandled exception')errors.push(e.message)});
 const dom=new JSDOM(fs.readFileSync(row.file+'.html','utf8'),{url:'https://lixiang-review.test/'+row.file+'.html',runScripts:'dangerously',virtualConsole:vc,beforeParse(w){w.HTMLElement.prototype.scrollIntoView=function(){};w.matchMedia=()=>({matches:false});w.ResizeObserver=class{observe(){} disconnect(){}};}});
 assert.deepEqual(errors,[],row.file);const w=dom.window,d=w.document;const title=d.querySelector('.persistent-fortune-title');assert.ok(title&&title.textContent.includes('每日一签'));
 for(const frame of [0,180,600,1050,1450]){w.renderAt(frame);assert.equal(w.getComputedStyle(title).opacity,'1',row.file+' title faded at '+frame);assert.notEqual(w.getComputedStyle(title).display,'none');}
 assert.equal(d.querySelector('.result').style.opacity,'1');assert.equal(d.querySelector('.heading').getAttribute('aria-hidden'),'true');assert.notEqual(title,d.querySelector('.heading'));assert.equal(d.querySelectorAll('#sign-title').length,1);assert.equal(w.getComputedStyle(d.querySelector('.result')).overflow,'visible');
 results.push({file:row.file,titleVisibleAtAllFiveFrames:true,resultVisible:true,noInternalResultScroll:true});dom.window.close();
}
fs.writeFileSync('R13-FORTUNE-DOM-TESTS.json',JSON.stringify({method:'jsdom actual full HTML and frozen motion script; ResizeObserver/matchMedia/scroll adapters only; no paint validation',results},null,2));console.log('PASS persistent titles and full result structure',results.length,'idle/result pages');
