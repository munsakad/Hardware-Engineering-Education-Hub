// Shared text escaping for learner and editor interfaces.
function escapeText(value) {
  return String(value ?? "").replace(/[&<>"']/g, c => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
}

function renderNavAuthState() {
  const authSlot = document.querySelector("[data-nav-auth]");
  if (!authSlot) return;

  authSlot.innerHTML = "";
  const pagePrefix = window.location.pathname.endsWith("/") || window.location.pathname.endsWith("/index.html") ? "pages/" : "";

  if (isLoggedIn()) {
    const user = getStoredUser();
    const dashboardLink = document.createElement("a");
    dashboardLink.href = pagePrefix + "dashboard.html";
    dashboardLink.textContent = user ? `Hi, ${user.username}` : "Dashboard";

    const logoutLink = document.createElement("a");
    logoutLink.href = "#";
    logoutLink.textContent = "Log out";
    logoutLink.addEventListener("click", (event) => {
      event.preventDefault();
      clearSession();
      window.location.href = pagePrefix ? "index.html" : "../index.html";
    });

    authSlot.append(dashboardLink, logoutLink);
  } else {
    const loginLink = document.createElement("a");
    loginLink.href = pagePrefix + "login.html";
    loginLink.textContent = "Log in";

    const registerLink = document.createElement("a");
    registerLink.href = pagePrefix + "register.html";
    registerLink.className = "btn btn-primary";
    registerLink.style.padding = "0.35rem 0.9rem";
    registerLink.textContent = "Sign up";

    authSlot.append(loginLink, registerLink);
  }
}

function highlightActiveNavLink() {
  const currentPage = window.location.pathname.split("/").pop() || "index.html";
  document.querySelectorAll(".nav-links a[data-page]").forEach((link) => {
    if (link.dataset.page === currentPage) {
      link.classList.add("active");
    }
  });
}

document.addEventListener("DOMContentLoaded", () => {
  renderNavAuthState();
  highlightActiveNavLink();
});
