// Static GitHub Pages stand-in for the Flask API. Only included in the Pages
// build (backend/export_static.py adds it before js/api.js). It answers the
// same /api routes: the course catalog comes from data/courses.json, exported
// from the MySQL seed by CI; accounts and progress live in this browser's
// localStorage, since there is no server to keep them.
(function () {
  const API = "http://127.0.0.1:5000/api";
  const DATA_URL = new URL("../data/courses.json", document.currentScript.src).href;
  const REPO_URL = "https://github.com/munsakad/Hardware-Engineering-Education-Hub";
  const USERS_KEY = "heh_demo_users";
  const PROGRESS_KEY = "heh_demo_progress";
  const realFetch = window.fetch.bind(window);

  let catalog;
  const courses = () =>
    (catalog = catalog || realFetch(DATA_URL).then((r) => {
      if (!r.ok) throw new Error("Could not load course data");
      return r.json();
    }).then(data => read("heh_demo_catalog", data)));

  const read = (key, fallback) => {
    try {
      return JSON.parse(localStorage.getItem(key)) || fallback;
    } catch (e) {
      return fallback;
    }
  };
  const write = (key, value) => {
    try {
      localStorage.setItem(key, JSON.stringify(value));
    } catch (e) {
      /* storage unavailable */
    }
  };
  const reply = (status, data) =>
    new Response(JSON.stringify(data), { status, headers: { "Content-Type": "application/json" } });

  async function hashPassword(email, password) {
    const bytes = new TextEncoder().encode(email + ":" + password);
    const digest = await crypto.subtle.digest("SHA-256", bytes);
    return Array.from(new Uint8Array(digest), (b) => b.toString(16).padStart(2, "0")).join("");
  }

  // tokens are "demo.<userId>"; there is no server secret to sign a JWT with
  function currentUser(headers) {
    const header = (headers && (headers.Authorization || headers.authorization)) || "";
    const match = header.match(/^Bearer demo\.(\d+)$/);
    return match ? read(USERS_KEY, []).find((u) => u.id === Number(match[1])) : null;
  }

  async function handle(path, method, body, headers) {
    let m;
    if (path === "/health") return reply(200, { status: "ok" });

    if (path === "/quiz-attempts") {
      const user = currentUser(headers);
      if (!user) return reply(401, {error:"Log in to view quiz results"});
      return reply(200, read("heh_demo_attempts", []).filter(a => a.user_id === user.id).reverse());
    }
    if ((m = path.match(/^\/quizzes\/([^/]+)(\/attempts)?$/))) {
      const response = await realFetch(new URL("quizzes.json", DATA_URL));
      if (!response.ok) throw new Error("Could not load quiz questions");
      const bank = await response.json();
      const slug = decodeURIComponent(m[1]), questions = bank[slug];
      if (!questions) return reply(404, {error:"No quiz available for this course yet"});
      if (!m[2] && method === "GET") return reply(200, {questions:questions.map(({prompt,options})=>({prompt,options}))});
      if (m[2] && method === "POST") {
        const user=currentUser(headers);
        if (!user) return reply(401, {error:"Log in to save quiz results"});
        const answers=body.answers;
        if (!Array.isArray(answers) || answers.length!==questions.length || answers.some((a,i)=>!Number.isInteger(a)||a<0||a>=questions[i].options.length))
          return reply(400,{error:"Answer every question with a valid option"});
        const score=answers.filter((a,i)=>a===questions[i].answer).length;
        const attempts=read("heh_demo_attempts",[]);
        attempts.push({user_id:user.id,course_slug:slug,score,total:questions.length,completed_at:new Date().toISOString()});
        localStorage.setItem("heh_demo_attempts",JSON.stringify(attempts));
        return reply(200,{score,total:questions.length,review:questions});
      }
      return reply(405,{error:"Method not allowed"});
    }
    if (path === "/cms" && method === "GET")
      return reply(200,{mode:"browser",message:"Demo CMS: create and edit courses and lessons in this browser. Changes affect only this device. Export JSON to keep a copy; this does not publish changes for other visitors."});
    if (path === "/cms/export" && method === "GET") return reply(200,await courses());
    if (path.startsWith("/cms/courses") && ["POST","PUT"].includes(method)) {
      const match=path.match(/^\/cms\/courses(?:\/([^/]+))?(?:\/lessons(?:\/([^/]+))?)?$/);
      if (!match) return reply(404,{error:"Not found"});
      const all=JSON.parse(JSON.stringify(await courses()));
      const isLesson=path.includes("/lessons");
      const slug=match[1] && decodeURIComponent(match[1]);
      let course=all.find(c=>c.slug===slug);
      const fail=message=>reply(400,{error:message});
      const text=(key,max,required=true)=>typeof body[key]==="string" && body[key].trim().length<=max && (!required||body[key].trim().length>0);
      if (!text("title",150)) return fail("Title must contain 1–150 characters");
      if (isLesson) {
        if (!course) return reply(404,{error:"Course not found"});
        if (!text("text",100000)) return fail("Lesson text must contain 1–100000 characters");
        const lessonSlug=match[2] ? decodeURIComponent(match[2]) : body.slug;
        let lesson=course.lessons.find(l=>l.slug===lessonSlug);
        if (method==="PUT" && !lesson) return reply(404,{error:"Lesson not found"});
        if (method==="POST") {
          if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(lessonSlug||"") || lessonSlug.length>80) return fail("Use a valid lesson slug");
          if (lesson) return reply(409,{error:"That lesson slug already exists"});
          lesson={id:Date.now(),slug:lessonSlug,sort_order:999};course.lessons.push(lesson);
        }
        const escaped=body.text.trim().replace(/[&<>"']/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
        Object.assign(lesson,{title:body.title.trim(),content:"<p>"+escaped.replaceAll("\n","<br>")+"</p>"});
        localStorage.setItem("heh_demo_catalog",JSON.stringify(all));catalog=Promise.resolve(all);
        return reply(200,{slug:lessonSlug});
      }
      if (!text("category",60)||!text("description",5000,false)) return fail("Provide a category and a description of at most 5000 characters");
      if (method==="PUT" && !course) return reply(404,{error:"Course not found"});
      if (method==="POST") {
        if (slug) return fail("Create a course at /cms/courses");
        if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(body.slug||"") || body.slug.length>80) return fail("Use a valid course slug");
        if (all.some(c=>c.slug===body.slug)) return reply(409,{error:"That course slug already exists"});
        course={id:Date.now(),slug:body.slug,lessons:[]};all.push(course);
      }
      Object.assign(course,{title:body.title.trim(),category:body.category.trim(),description:body.description.trim()});
      localStorage.setItem("heh_demo_catalog",JSON.stringify(all));catalog=Promise.resolve(all);
      return reply(200,{slug:course.slug});
    }

    if (path === "/auth/register" && method === "POST") {
      const username = (body.username || "").trim();
      const email = (body.email || "").trim().toLowerCase();
      const password = body.password || "";
      if (!username || !email || password.length < 8)
        return reply(400, { error: "username, email, and a password of at least 8 characters are required" });
      const users = read(USERS_KEY, []);
      if (users.some((u) => u.username === username || u.email === email))
        return reply(409, { error: "A user with that username or email already exists" });
      const user = {
        id: users.length + 1,
        username,
        email,
        password_hash: await hashPassword(email, password),
        created_at: new Date().toISOString(),
      };
      users.push(user);
      write(USERS_KEY, users);
      return reply(201, { token: "demo." + user.id, user: { id: user.id, username, email } });
    }

    if (path === "/auth/login" && method === "POST") {
      const email = (body.email || "").trim().toLowerCase();
      const user = read(USERS_KEY, []).find((u) => u.email === email);
      if (!user || user.password_hash !== (await hashPassword(email, body.password || "")))
        return reply(401, { error: "Invalid email or password" });
      return reply(200, { token: "demo." + user.id, user: { id: user.id, username: user.username, email } });
    }

    if (path === "/auth/me") {
      const user = currentUser(headers);
      if (!user) return reply(401, { error: "Invalid token" });
      return reply(200, { id: user.id, username: user.username, email: user.email, created_at: user.created_at });
    }

    if (path === "/courses") {
      return reply(200, (await courses()).map(({ id, slug, title, description, category }) => ({ id, slug, title, description, category })));
    }

    if ((m = path.match(/^\/courses\/([^/]+)$/))) {
      const course = (await courses()).find((c) => c.slug === decodeURIComponent(m[1]));
      if (!course) return reply(404, { error: "Course not found" });
      return reply(200, {
        ...course,
        lessons: course.lessons.map(({ id, slug, title, sort_order }) => ({ id, slug, title, sort_order })),
      });
    }

    if ((m = path.match(/^\/courses\/([^/]+)\/lessons\/([^/]+)$/))) {
      const course = (await courses()).find((c) => c.slug === decodeURIComponent(m[1]));
      const lesson = course && course.lessons.find((l) => l.slug === decodeURIComponent(m[2]));
      if (!lesson) return reply(404, { error: "Lesson not found" });
      return reply(200, { ...lesson, course_id: course.id, course_slug: course.slug, course_title: course.title });
    }

    if (path === "/progress" || path.startsWith("/progress/")) {
      const user = currentUser(headers);
      if (!user) return reply(401, { error: "Missing authorization token" });
      const progress = read(PROGRESS_KEY, []);

      if (path === "/progress" && method === "GET") {
        const all = await courses();
        const rows = progress
          .filter((p) => p.user_id === user.id)
          .map((p) => {
            const course = all.find((c) => c.slug === p.course_slug);
            const lesson = course && course.lessons.find((l) => l.slug === p.lesson_slug);
            return lesson && {
              course_slug: course.slug,
              course_title: course.title,
              lesson_slug: lesson.slug,
              lesson_title: lesson.title,
              completed_at: p.completed_at,
            };
          })
          .filter(Boolean)
          .sort((a, b) => b.completed_at.localeCompare(a.completed_at));
        return reply(200, rows);
      }

      if ((m = path.match(/^\/progress\/([^/]+)\/([^/]+)\/complete$/)) && method === "POST") {
        const courseSlug = decodeURIComponent(m[1]);
        const lessonSlug = decodeURIComponent(m[2]);
        const course = (await courses()).find((c) => c.slug === courseSlug);
        if (!course || !course.lessons.some((l) => l.slug === lessonSlug))
          return reply(404, { error: "Lesson not found" });
        // same upsert semantics as ON DUPLICATE KEY UPDATE completed_at
        const rest = progress.filter(
          (p) => !(p.user_id === user.id && p.course_slug === courseSlug && p.lesson_slug === lessonSlug)
        );
        rest.push({ user_id: user.id, course_slug: courseSlug, lesson_slug: lessonSlug, completed_at: new Date().toISOString() });
        write(PROGRESS_KEY, rest);
        return reply(200, { status: "completed" });
      }
    }

    return reply(404, { error: "Not found" });
  }

  window.fetch = function (input, init) {
    init = init || {};
    const url = typeof input === "string" ? input : input.url;
    if (!url.startsWith(API)) return realFetch(input, init);
    let body = {};
    try {
      body = init.body ? JSON.parse(init.body) : {};
    } catch (e) {
      /* non-JSON body */
    }
    const path = url.slice(API.length).split("?")[0];
    return handle(path, (init.method || "GET").toUpperCase(), body, init.headers).catch((e) =>
      reply(500, { error: e.message })
    );
  };

  document.addEventListener("DOMContentLoaded", function () {
    const note = document.createElement("aside");
    note.setAttribute("aria-label", "About this demo");
    note.style.cssText =
      "position:fixed;right:14px;bottom:14px;z-index:9999;max-width:340px;padding:10px 32px 10px 12px;" +
      "border-radius:8px;background:#11161c;color:#cfd8e1;border:1px solid #2a3540;" +
      "font:12.5px/1.5 system-ui,sans-serif;box-shadow:0 6px 20px rgba(0,0,0,.3)";
    note.innerHTML =
      '<strong style="color:#fff">Static demo.</strong> Lessons are exported from the MySQL seed data by CI; ' +
      "the Flask API is emulated in your browser. Accounts, progress, quiz results and CMS edits are saved only on this device. " +
      '<a href="' + REPO_URL + '" style="color:#6ea2ff">Source</a>' +
      '<button aria-label="Dismiss" style="position:absolute;top:4px;right:8px;background:none;border:0;' +
      'color:#8a99a8;font-size:16px;cursor:pointer">&times;</button>';
    note.querySelector("button").onclick = function () {
      note.remove();
    };
    document.body.appendChild(note);
  });
})();
