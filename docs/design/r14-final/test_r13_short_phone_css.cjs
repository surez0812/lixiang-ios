const fs=require('node:fs'),assert=require('node:assert/strict');
let lib;try{lib=require('jsdom')}catch{lib=require('/tmp/lixiang-r12-dom-regression/node_modules/jsdom')}
const {JSDOM,VirtualConsole}=lib;const signs=JSON.parse(fs.readFileSync('assets/fortune-samples.json','utf8')).signs;
const override=/\.mode-phone-landscape\.page-fortune \.fortune-host \.result-copy,\.mode-phone-landscape-dark\.page-fortune \.fortune-host \.result-copy\{[^}]+\}/;
function load(mode,negative=false){let html=fs.readFileSync('fortune-'+mode+'.html','utf8');assert.ok(override.test(html));if(negative)html=html.replace(override,'');const errors=[],vc=new VirtualConsole();vc.on('jsdomError',e=>{if(e.type==='unhandled exception')errors.push(e.message)});const dom=new JSDOM(html,{url:'https://lixiang-review.test/fortune-'+mode+'.html',runScripts:'dangerously',virtualConsole:vc,beforeParse(w){w.matchMedia=()=>({matches:false});w.ResizeObserver=class{observe(){}}}});assert.deepEqual(errors,[]);return dom;}
const results=[];
for(const mode of ['phone-landscape','phone-landscape-dark']){
 const broken=load(mode,true);broken.window.renderAt(1450);assert.equal(broken.window.getComputedStyle(broken.window.document.querySelector('.fortune-host .result-copy')).minHeight,'500px');broken.window.close();
 const dom=load(mode),w=dom.window,d=w.document;
 assert.equal(w.getComputedStyle(d.documentElement).getPropertyValue('--ft-vh').trim(),'144px');
 for(const sign of signs){d.querySelector('#sign-title').textContent=sign.title;d.querySelector('#poem').innerHTML=sign.poem.join('<br>');d.querySelector('#explain').textContent=sign.explain;d.querySelector('#advice').textContent=sign.advice;
  for(const frame of [0,600,1050,1450]){w.renderAt(frame);const copy=w.getComputedStyle(d.querySelector('.fortune-host .result-copy'));assert.equal(copy.minHeight,'0');assert.equal(copy.height,'var(--ft-vh)');assert.equal(copy.maxHeight,'var(--ft-vh)');assert.equal(copy.paddingTop,'4px');assert.equal(copy.rowGap,'2px');assert.equal(copy.transform,'none');assert.equal(copy.top,'auto');assert.equal(copy.overflow,'visible');assert.equal(w.getComputedStyle(d.querySelector('.persistent-fortune-title')).opacity,'1');}
  results.push({mode,sign:sign.id,legacyMinimumRemoved:true,heightBoundToVisual:true,noInternalScroll:true,titlePreserved:true});
 }dom.window.close();
}
fs.writeFileSync('R13-SHORT-PHONE-CSS-REGRESSION.json',JSON.stringify({method:'jsdom complete generated HTML and full ancestor CSS; five structural/computed constraints; no browser geometry or paint',negativeControl:'Removing the targeted override restores the observed 500px minimum in both themes',results},null,2));console.log('PASS targeted CSS reset,20 sign/theme cases; legacy 500px negative controls reproduced');
