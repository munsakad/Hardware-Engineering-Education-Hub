document.addEventListener("DOMContentLoaded", async () => {
  const catalog = document.querySelector("#quiz-catalog");
  if (catalog) {
    try {
      const courses = await apiRequest("/courses");
      catalog.innerHTML = courses.map(c => `<a class="card" href="quiz.html?slug=${encodeURIComponent(c.slug)}"><span class="tag">${escapeText(c.category)}</span><h2>${escapeText(c.title)}</h2><p>Test your understanding and review each answer.</p></a>`).join("");
    } catch (e) { catalog.textContent = e.message; }
  }
  const quiz = document.querySelector("#quiz-content");
  if (quiz) {
    const slug = new URLSearchParams(location.search).get("slug");
    if (!slug) { quiz.innerHTML = '<p>Select a quiz from the <a href="quizzes.html">quiz catalog</a>.</p>'; return; }
    try {
      const [course, data] = await Promise.all([apiRequest(`/courses/${encodeURIComponent(slug)}`), apiRequest(`/quizzes/${encodeURIComponent(slug)}`)]);
      document.querySelector("h1").textContent = `${course.title}: knowledge check`;
      if (!isLoggedIn()) { quiz.innerHTML = '<p><a href="login.html">Log in</a> or <a href="register.html">create an account</a> to take quizzes and save your results.</p>'; return; }
      quiz.innerHTML = `<form id="quiz-form">${data.questions.map((q,i) => `<fieldset class="quiz-question"><legend>${i+1}. ${escapeText(q.prompt)}</legend>${q.options.map((o,j) => `<label class="quiz-option"><input type="radio" name="q${i}" value="${j}" required> ${escapeText(o)}</label>`).join("")}</fieldset>`).join("")}<button class="btn btn-primary">Submit answers</button><p id="quiz-error" role="alert"></p></form><section id="quiz-result" aria-live="polite" tabindex="-1"></section>`;
      document.querySelector("#quiz-form").onsubmit = async event => {
        event.preventDefault();
        const form = event.currentTarget, button = form.querySelector("button");
        button.disabled = true;
        const answers = data.questions.map((_,i) => Number(new FormData(form).get(`q${i}`)));
        try {
          const result = await apiRequest(`/quizzes/${encodeURIComponent(slug)}/attempts`, {method:"POST", auth:true, body:{answers}});
          const target = document.querySelector("#quiz-result");
          target.innerHTML = `<h2>Score: ${result.score} / ${result.total} (${Math.round(result.score/result.total*100)}%)</h2>${result.review.map((q,i) => `<article class="answer-review"><h3>${answers[i]===q.answer ? "Correct" : "Review"}: ${escapeText(q.prompt)}</h3><p>Your answer: ${escapeText(q.options[answers[i]])}</p><p>Correct answer: ${escapeText(q.options[q.answer])}</p><p>${escapeText(q.explanation)}</p></article>`).join("")}<p><a href="dashboard.html">View saved results</a> · <a href="course.html?slug=${encodeURIComponent(slug)}">Review lessons</a></p><button type="button" class="btn btn-secondary" id="retry-quiz">Try again</button>`;
          form.hidden = true;
          target.focus();
          document.querySelector("#retry-quiz").onclick = () => location.reload();
        } catch(e) { document.querySelector("#quiz-error").textContent=e.message; button.disabled=false; }
      };
    } catch(e) { quiz.textContent=e.message; }
  }
  const history = document.querySelector("#quiz-history");
  if (history && isLoggedIn()) {
    try {
      const attempts = await apiRequest("/quiz-attempts",{auth:true});
      history.innerHTML = attempts.length ? `<table class="progress-table"><thead><tr><th>Course</th><th>Score</th><th>Date</th></tr></thead><tbody>${attempts.map(a => `<tr><td><a href="quiz.html?slug=${encodeURIComponent(a.course_slug)}">${escapeText(a.course_slug.replaceAll("-"," "))}</a></td><td>${a.score} / ${a.total}</td><td>${escapeText(new Date(a.completed_at).toLocaleString())}</td></tr>`).join("")}</tbody></table>` : '<p>No quiz attempts yet. <a href="quizzes.html">Take your first quiz</a>.</p>';
    } catch(e) { history.textContent=e.message; }
  }
});
