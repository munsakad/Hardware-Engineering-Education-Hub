async function renderCourseCatalog() {
  const grid = document.querySelector("#course-grid");
  if (!grid) return;

  try {
    const courses = await apiRequest("/courses");
    if (!courses.length) {
      grid.innerHTML = '<p class="empty-state">No courses yet — check back soon.</p>';
      return;
    }

    grid.innerHTML = courses
      .map(
        (course) => `
        <a class="card" href="course.html?slug=${encodeURIComponent(course.slug)}">
          <span class="tag">${course.category}</span>
          <h3>${course.title}</h3>
          <p>${course.description || ""}</p>
        </a>
      `
      )
      .join("");
  } catch (err) {
    grid.innerHTML = `<p class="empty-state">Could not load courses: ${err.message}</p>`;
  }
}

async function renderCourseDetail() {
  const container = document.querySelector("#course-detail");
  if (!container) return;

  const params = new URLSearchParams(window.location.search);
  const slug = params.get("slug");
  const lessonSlug = params.get("lesson");

  if (!slug) {
    container.innerHTML = '<p class="empty-state">No course selected.</p>';
    return;
  }

  let course;
  try {
    course = await apiRequest(`/courses/${encodeURIComponent(slug)}`);
  } catch (err) {
    container.innerHTML = `<p class="empty-state">Could not load course: ${err.message}</p>`;
    return;
  }

  let completedSlugs = new Set();
  if (isLoggedIn()) {
    try {
      const progress = await apiRequest("/progress", { auth: true });
      completedSlugs = new Set(
        progress.filter((p) => p.course_slug === slug).map((p) => p.lesson_slug)
      );
    } catch (err) {
      // Progress is a nice-to-have here; ignore failures so the lesson list still renders.
    }
  }

  const activeLessonSlug = lessonSlug || (course.lessons[0] && course.lessons[0].slug);

  document.title = `${course.title} — Hardware Engineering Education Hub`;

  container.innerHTML = `
    <h1>${course.title}</h1>
    <p>${course.description || ""}</p>
    <div class="course-layout">
      <ul class="lesson-list">
        ${course.lessons
          .map(
            (lesson) => `
            <li>
              <a href="course.html?slug=${encodeURIComponent(slug)}&lesson=${encodeURIComponent(lesson.slug)}"
                 class="${lesson.slug === activeLessonSlug ? "active" : ""}">
                <span>${lesson.title}</span>
                ${completedSlugs.has(lesson.slug) ? '<span class="done-mark">&#10003;</span>' : ""}
              </a>
            </li>
          `
          )
          .join("")}
      </ul>
      <div class="lesson-content" id="lesson-content">
        <p class="empty-state">Select a lesson to get started.</p>
      </div>
    </div>
  `;

  if (activeLessonSlug) {
    renderLesson(slug, activeLessonSlug, completedSlugs.has(activeLessonSlug));
  }
}

async function renderLesson(courseSlug, lessonSlug, alreadyCompleted) {
  const lessonContentEl = document.querySelector("#lesson-content");
  if (!lessonContentEl) return;

  try {
    const lesson = await apiRequest(
      `/courses/${encodeURIComponent(courseSlug)}/lessons/${encodeURIComponent(lessonSlug)}`
    );

    lessonContentEl.innerHTML = `
      <h2>${lesson.title}</h2>
      <div class="lesson-body">${lesson.content || ""}</div>
      <div class="lesson-actions">
        ${
          isLoggedIn()
            ? `<button class="btn btn-primary" id="complete-btn" ${alreadyCompleted ? "disabled" : ""}>
                ${alreadyCompleted ? "Completed" : "Mark as complete"}
              </button>`
            : `<p class="empty-state"><a href="login.html">Log in</a> to track your progress.</p>`
        }
      </div>
    `;

    const completeBtn = document.querySelector("#complete-btn");
    if (completeBtn) {
      completeBtn.addEventListener("click", async () => {
        completeBtn.disabled = true;
        try {
          await apiRequest(`/progress/${courseSlug}/${lessonSlug}/complete`, {
            method: "POST",
            auth: true,
          });
          completeBtn.textContent = "Completed";
        } catch (err) {
          completeBtn.disabled = false;
          completeBtn.textContent = "Mark as complete";
          alert(`Could not save progress: ${err.message}`);
        }
      });
    }
  } catch (err) {
    lessonContentEl.innerHTML = `<p class="empty-state">Could not load lesson: ${err.message}</p>`;
  }
}

document.addEventListener("DOMContentLoaded", () => {
  renderCourseCatalog();
  renderCourseDetail();
});
