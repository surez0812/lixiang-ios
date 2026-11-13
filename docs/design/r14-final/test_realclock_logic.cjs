const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const { webcrypto } = require('node:crypto');
const { performance } = require('node:perf_hooks');
const root = __dirname;
const source = fs.readFileSync(path.join(root, 'ApprovedFortuneCore.js'), 'utf8');
const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));
function environment(systemReduce = false) {
  const nodes = new Map(), saved = new Map();
  const counters = { digest: 0, writes: 0, animationFrames: 0 };
  function node(selector) {
    if (!nodes.has(selector)) nodes.set(selector, { style: {}, textContent: '', innerHTML: '', value: '', checked: false, disabled: false, focused: false, focus() { this.focused = true; }, classList: { add() {} } });
    return nodes.get(selector);
  }
  class FixedDate extends Date {
    constructor(...args) { super(...(args.length ? args : ['2026-11-12T12:00:00+08:00'])); }
    static now() { return new Date('2026-11-12T12:00:00+08:00').getTime(); }
  }
  const context = {
    Date: FixedDate, Intl, URLSearchParams, TextEncoder, Uint8Array, BigInt, Math,
    setTimeout, clearTimeout,
    crypto: { subtle: { async digest(...args) { counters.digest++; return webcrypto.subtle.digest(...args); } } },
    localStorage: { getItem: key => saved.get(key) || null, setItem: (key, value) => { counters.writes++; saved.set(key, value); } },
    document: { querySelector: node, body: { classList: { add() {} } } },
    location: { search: '' },
    matchMedia: query => ({ matches: systemReduce && query.includes('prefers-reduced-motion') }),
    requestAnimationFrame: callback => setTimeout(() => { counters.animationFrames++; callback(performance.now()); }, 16),
    cancelAnimationFrame: clearTimeout,
  };
  context.window = context;
  vm.createContext(context);
  vm.runInContext(source, context, { timeout: 2000 });
  return { node, counters, saved };
}
(async () => {
  const results = await Promise.all([
    (async () => {
      const e = environment();
      const started = performance.now();
      await e.node('#draw').onclick();
      await sleep(720);
      const liftAt720 = e.node('.bamboo.main').style.transform;
      await sleep(940);
      const elapsed = Math.round(performance.now() - started);
      const title = e.node('#sign-title').textContent;
      const complete = e.node('.result').style.opacity === 1 && e.node('#draw').textContent.includes('收好');
      e.node('#replay').onclick();
      await e.node('#draw').onclick();
      await sleep(1660);
      return { name: 'trigger-final-and-same-day-persistence', pass: complete && e.node('#sign-title').textContent === title && e.counters.digest === 1 && e.counters.writes === 1 && e.node('.result').style.opacity === 1, elapsedFirstMs: elapsed, liftAt720, title, counters: e.counters, cacheKeys: [...e.saved.keys()] };
    })(),
    (async () => {
      const e = environment();
      await e.node('#draw').onclick();
      await sleep(230);
      await e.node('#skip').onclick();
      await sleep(1520);
      return { name: 'skip-mid-animation-stays-complete', pass: e.node('.result').style.opacity === 1 && e.node('#draw').textContent.includes('收好') && e.node('#sign-title').focused && e.counters.writes === 1, counters: e.counters };
    })(),
    (async () => {
      const e = environment();
      e.node('#reduce').checked = true;
      await e.node('#draw').onclick();
      await sleep(200);
      return { name: 'explicit-reduce-motion', pass: e.node('.result').style.opacity === 1 && e.counters.animationFrames === 0 && e.node('.result').style.transition === 'opacity 150ms', transitionTarget: e.node('.result').style.transition, counters: e.counters };
    })(),
    (async () => {
      const e = environment(true);
      await e.node('#draw').onclick();
      await sleep(200);
      return { name: 'system-reduce-motion', pass: e.node('.result').style.opacity === 1 && e.counters.animationFrames === 0, counters: e.counters };
    })()
  ]);
  const output = { method: 'Exact approved R7 motion core embedded in all R8 fortune pages in Node vm with minimal DOM state stubs, real wall-clock timers and WebCrypto. No browser opened, no network used.', limitations: 'Checks interaction state and real-clock completion only. It does not validate browser paint, CSS transition visuals, native SwiftUI runtime or actual device motion.', results, allLogicPass: results.every(x => x.pass), browserRealtimeVisual: 'UNVERIFIED', originalVirtualClockEvidence: 'evidence/r6-before-cleanup/INTERACTION-TESTS.json' };
  fs.writeFileSync(path.join(root, 'REALCLOCK-LOGIC-TESTS.json'), JSON.stringify(output, null, 2));
  console.log(JSON.stringify(output, null, 2));
  if (!output.allLogicPass) process.exitCode = 1;
})();
