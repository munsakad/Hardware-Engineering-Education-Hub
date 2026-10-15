const {test} = require('node:test');
const assert = require('node:assert/strict');
const vm = require('node:vm');
const fs = require('node:fs');
const path = require('node:path');
const bank = JSON.parse(fs.readFileSync(path.join(__dirname,'../data/quizzes.json')));
const source = fs.readFileSync(path.join(__dirname,'demo-backend.js'),'utf8');
const seed = [{id:1,slug:'arduino',title:'Arduino',category:'Embedded',description:'Learn',lessons:[{id:1,slug:'intro',title:'Intro',content:'<p>Original</p>',sort_order:1}]}];
function setup(storage = new Map()) {
  const context = {URL,Response,TextEncoder,crypto:require('node:crypto').webcrypto,localStorage:{getItem:k=>storage.get(k)||null,setItem:(k,v)=>storage.set(k,v)},document:{currentScript:{src:'https://example.test/js/demo-backend.js'},addEventListener:()=>{}},window:{fetch:async url=>new Response(JSON.stringify(String(url).endsWith('quizzes.json')?bank:seed))}};
  vm.runInNewContext(source,context);
  return {storage,request:async(route,method='GET',body,user=1)=>{
    const response=await context.window.fetch('http://127.0.0.1:5000/api'+route,{method,body:JSON.stringify(body),headers:{Authorization:'Bearer demo.'+user}});
    return {status:response.status,data:await response.json()};
  }};
}
test('all seven banks contain valid questions, answers and explanations',()=>{
  assert.equal(Object.keys(bank).length,7);
  for(const questions of Object.values(bank)) {assert.equal(questions.length,3);for(const q of questions){assert.ok(q.prompt&&q.explanation);assert.ok(q.options[q.answer]);assert.equal(new Set(q.options).size,q.options.length);}}
});
test('quiz grading, invalid attempts, persistence and per-user history',async()=>{
  const app=setup();app.storage.set('heh_demo_users',JSON.stringify([{id:1},{id:2}]));
  const quiz=await app.request('/quizzes/arduino');assert.equal(quiz.status,200);assert.equal(quiz.data.questions[0].answer,undefined);
  assert.equal((await app.request('/quizzes/arduino/attempts','POST',{answers:[1]})).status,400);
  assert.equal((await app.request('/quizzes/arduino/attempts','POST',{answers:[1,2,0]},99)).status,401);
  const result=await app.request('/quizzes/arduino/attempts','POST',{answers:[1,2,0]});assert.equal(result.data.score,3);assert.equal(result.data.review.length,3);
  assert.equal((await app.request('/quizzes/arduino/attempts','POST',{answers:[0,0,1]})).data.score,0);
  assert.equal((await app.request('/quiz-attempts','GET',undefined,2)).data.length,0);
  assert.equal((await setup(app.storage).request('/quiz-attempts')).data.length,2);
});
test('CMS create, edit, duplicate rejection, escaped content, reload and export',async()=>{
  const app=setup();
  let result=await app.request('/cms/courses','POST',{slug:'circuits-lab',title:'Circuits lab',category:'Lab',description:'Practice'});assert.equal(result.status,200);
  assert.equal((await app.request('/cms/courses','POST',{slug:'circuits-lab',title:'Duplicate',category:'Lab',description:''})).status,409);
  assert.equal((await app.request('/cms/courses','POST',{slug:'bad slug',title:'Bad',category:'Lab',description:''})).status,400);
  result=await app.request('/cms/courses/circuits-lab/lessons','POST',{slug:'safety',title:'Safety',text:'<script>alert(1)</script>\nStay safe'});assert.equal(result.status,200);
  let lesson=(await app.request('/courses/circuits-lab/lessons/safety')).data;assert.ok(!lesson.content.includes('<script>'));assert.ok(lesson.content.includes('&lt;script&gt;'));
  assert.equal((await app.request('/cms/courses/circuits-lab/lessons/safety','PUT',{title:'Safety updated',text:'Disconnect power.'})).status,200);
  const reloaded=setup(app.storage);assert.equal((await reloaded.request('/courses/circuits-lab/lessons/safety')).data.title,'Safety updated');
  assert.equal((await reloaded.request('/cms/export')).data.length,2);
  assert.equal((await app.request('/cms/courses/missing','PUT',{title:'X',category:'Y',description:''})).status,404);
});
