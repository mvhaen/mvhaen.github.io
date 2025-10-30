/* Theme toggle with persisted preference and system fallback */
(function () {
  var STORAGE_KEY = 'theme'; // 'light' | 'dark' | 'system'
  var root = document.documentElement; // <html>
  var toggleButtons = [];
  var iconSpans = [];

  function getStoredPreference() {
    try {
      return localStorage.getItem(STORAGE_KEY);
    } catch (_) {
      return null;
    }
  }

  function setStoredPreference(value) {
    try {
      localStorage.setItem(STORAGE_KEY, value);
    } catch (_) {
      /* ignore */
    }
  }

  function clearStoredPreference() {
    try {
      localStorage.removeItem(STORAGE_KEY);
    } catch (_) {
      /* ignore */
    }
  }

  function prefersDark() {
    return window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
  }

  function currentMode() {
    // Priority: stored preference → data-theme → system
    var stored = getStoredPreference();
    if (stored === 'dark' || stored === 'light') return stored;
    var attr = root.getAttribute('data-theme');
    if (attr === 'dark' || attr === 'light') return attr;
    return prefersDark() ? 'dark' : 'light';
  }

  function isSystemMode() {
    var stored = getStoredPreference();
    var attr = root.getAttribute('data-theme');
    return stored === 'system' || !(stored === 'dark' || stored === 'light' || attr === 'dark' || attr === 'light');
  }

  function applyTheme(mode, persist) {
    if (persist) setStoredPreference(mode);
    root.setAttribute('data-theme', mode);
    updateButtonIcons(currentMode());
  }

  function updateButtonIcons(mode) {
    if (!iconSpans.length) return;
    var system = isSystemMode();
    var next = system ? 'light' : (mode === 'dark' ? 'system' : 'dark');
    for (var i = 0; i < iconSpans.length; i++) {
      iconSpans[i].textContent = system ? '🖥️' : (mode === 'dark' ? '🌙' : '☀️');
    }
    for (var j = 0; j < toggleButtons.length; j++) {
      var label = 'Theme: ' + (system ? 'System' : mode.charAt(0).toUpperCase() + mode.slice(1)) + ' — Next: ' + (next.charAt(0).toUpperCase() + next.slice(1));
      toggleButtons[j].setAttribute('aria-label', label);
      toggleButtons[j].setAttribute('title', label);
      toggleButtons[j].setAttribute('data-tooltip', label);
    }
  }

  function init() {
    toggleButtons = Array.prototype.slice.call(document.querySelectorAll('.theme-toggle'));
    if (!toggleButtons.length) return;
    iconSpans = toggleButtons.map(function(btn){ return btn.querySelector('.theme-toggle-icon'); }).filter(Boolean);

    // Initialize based on preference
    var stored = getStoredPreference();
    if (stored === 'dark' || stored === 'light') {
      applyTheme(stored, false);
    } else {
      // No stored pref: don't set attribute, let CSS handle system mode; just set icon accordingly
      updateButtonIcons(currentMode());
    }

    toggleButtons.forEach(function(btn){
      btn.addEventListener('click', function () {
        if (isSystemMode()) {
          // System → Light
          applyTheme('light', true);
          return;
        }
        var mode = currentMode();
        if (mode === 'light') {
          applyTheme('dark', true);
        } else if (mode === 'dark') {
          // Dark → System
          setStoredPreference('system');
          root.removeAttribute('data-theme');
          updateButtonIcons(currentMode());
        } else {
          // Fallback to system
          setStoredPreference('system');
          root.removeAttribute('data-theme');
          updateButtonIcons(currentMode());
        }
      });
    });

    // If user hasn't explicitly chosen and system preference changes, reflect it in the icon
    if (window.matchMedia) {
      var mql = window.matchMedia('(prefers-color-scheme: dark)');
      if (!(getStoredPreference() === 'dark' || getStoredPreference() === 'light')) {
        mql.addEventListener('change', function () {
          updateButtonIcons(currentMode());
        });
      }
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();


