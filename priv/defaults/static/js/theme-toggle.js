// Theme and highlight switcher (combined)
document.addEventListener('DOMContentLoaded', function () {
  const themeToggle = document.getElementById('theme-toggle');
  const themeIcon = document.getElementById('theme-icon');
  const highlightLink = document.getElementById('highlight-theme');
  const sunSVG = `<svg width="24" height="24" viewBox="0 0 24 24"><circle cx="12" cy="12" r="5" fill="orange"/><g stroke="orange" stroke-width="2"><line x1="12" y1="1" x2="12" y2="4"/><line x1="12" y1="20" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="6.34" y2="6.34"/><line x1="17.66" y1="17.66" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="4" y2="12"/><line x1="20" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="6.34" y2="17.66"/><line x1="17.66" y1="6.34" x2="19.78" y2="4.22"/></g></svg>`;
  const moonSVG = `<svg width="24" height="24" viewBox="0 0 24 24"><ellipse cx="12" cy="12" rx="10" ry="10" fill="gray"/><ellipse cx="16" cy="10" rx="9" ry="10" fill="white" transform="rotate(-15 16 10)"/></svg>`;
  const autoSVG = `<svg width="24" height="24" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10" fill="none" stroke="currentColor" stroke-width="2"/><path d="M12 2 A10 10 0 0 1 12 22 Z" fill="currentColor"/></svg>`;

  // Get theme names from data attributes on the html element
  const htmlElement = document.documentElement;
  const lightTheme = htmlElement.dataset.lightTheme || 'github';
  const darkTheme = htmlElement.dataset.darkTheme || 'github-dark';

  function setHighlightTheme(theme) {
    if (!highlightLink) return;
    if (theme === 'dark') {
      highlightLink.href = `https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/${darkTheme}.min.css`;
    } else {
      highlightLink.href = `https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/${lightTheme}.min.css`;
    }
  }

  function getSystemTheme() {
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  }

  function setTheme(mode, persist = true) {
    let actualTheme;
    if (mode === 'auto') {
      actualTheme = getSystemTheme();
      if (persist) localStorage.setItem('themeMode', 'auto');
    } else {
      actualTheme = mode;
      if (persist) localStorage.setItem('themeMode', mode);
    }

    document.documentElement.setAttribute('data-theme', actualTheme);
    setHighlightTheme(actualTheme);

    if (themeIcon) {
      if (mode === 'auto') {
        themeIcon.innerHTML = autoSVG;
      } else if (actualTheme === 'dark') {
        themeIcon.innerHTML = sunSVG;
      } else {
        themeIcon.innerHTML = moonSVG;
      }
    }
  }

  function initializeTheme() {
    const savedMode = localStorage.getItem('themeMode');
    if (savedMode === 'light' || savedMode === 'dark' || savedMode === 'auto') {
      setTheme(savedMode, false);
    } else {
      setTheme('auto', false);
    }
  }

  if (themeToggle) {
    themeToggle.addEventListener('click', function () {
      const currentMode = localStorage.getItem('themeMode') || 'auto';
      let newMode;
      if (currentMode === 'light') {
        newMode = 'dark';
      } else if (currentMode === 'dark') {
        newMode = 'auto';
      } else {
        newMode = 'light';
      }
      setTheme(newMode, true);
    });
  }

  // Inicialización: respeta preferencia previa o sistema
  initializeTheme();

  // También responde a cambios del sistema si está en modo auto
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
    const currentMode = localStorage.getItem('themeMode');
    if (currentMode === 'auto' || !currentMode) {
      setTheme('auto', false);
    }
  });

  hljs.highlightAll();
});
