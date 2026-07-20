async function renderDashboard() {
  const container = document.querySelector("#dashboard-content");
  if (!container) return;

  if (!isLoggedIn()) {
    window.location.href = "login.html";
    return;
  }

  const user = getStoredUser();
  const greeting = document.querySelector("#dashboard-greeting");
  if (greeting && user) {
    greeting.textContent = `Welcome back, ${user.username}!`;
  }

  try {
    const progress = await apiRequest("/progress", { auth: true });

    if (!progress.length) {
      container.innerHTML =
        '<p class="empty-state">You haven\'t completed any lessons yet — head to the <a href="courses.html">course catalog</a> to get started.</p>';
      return;
    }

    container.innerHTML = `
      <table class="progress-table">
        <thead>
          <tr>
            <th>Course</th>
            <th>Lesson</th>
            <th>Completed</th>
          </tr>
        </thead>
        <tbody>
          ${progress
            .map(
              (row) => `
              <tr>
                <td><a href="course.html?slug=${encodeURIComponent(row.course_slug)}">${row.course_title}</a></td>
                <td>${row.lesson_title}</td>
                <td>${new Date(row.completed_at).toLocaleDateString()}</td>
              </tr>
            `
            )
            .join("")}
        </tbody>
      </table>
    `;
  } catch (err) {
    container.innerHTML = `<p class="empty-state">Could not load your progress: ${err.message}</p>`;
  }
}

document.addEventListener("DOMContentLoaded", renderDashboard);
