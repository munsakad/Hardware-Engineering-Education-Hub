function showFormMessage(el, message, type) {
  el.textContent = message;
  el.className = `form-message ${type || ""}`.trim();
}

function initRegisterForm() {
  const form = document.querySelector("#register-form");
  if (!form) return;
  const messageEl = form.querySelector("[data-form-message]");

  form.addEventListener("submit", async (event) => {
    event.preventDefault();
    const formData = new FormData(form);
    const username = formData.get("username").trim();
    const email = formData.get("email").trim();
    const password = formData.get("password");

    try {
      const data = await apiRequest("/auth/register", {
        method: "POST",
        body: { username, email, password },
      });
      setSession(data.token, data.user);
      window.location.href = "dashboard.html";
    } catch (err) {
      showFormMessage(messageEl, err.message, "error");
    }
  });
}

function initLoginForm() {
  const form = document.querySelector("#login-form");
  if (!form) return;
  const messageEl = form.querySelector("[data-form-message]");

  form.addEventListener("submit", async (event) => {
    event.preventDefault();
    const formData = new FormData(form);
    const email = formData.get("email").trim();
    const password = formData.get("password");

    try {
      const data = await apiRequest("/auth/login", {
        method: "POST",
        body: { email, password },
      });
      setSession(data.token, data.user);
      window.location.href = "dashboard.html";
    } catch (err) {
      showFormMessage(messageEl, err.message, "error");
    }
  });
}

document.addEventListener("DOMContentLoaded", () => {
  initRegisterForm();
  initLoginForm();
});
