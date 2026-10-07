// Firefox prefs that Firefox Sync does not carry. Sync covers extensions,
// bookmarks, history and its own pref list; this file covers the rest.
// Firefox reapplies it at every start, so change prefs here, not in about:config.

// The previous interface, not the redesign Firefox now turns on by default
user_pref("browser.nova.enabled", false);

// Dark browser and dark pages
user_pref("browser.theme.content-theme", 0);
user_pref("browser.theme.toolbar-theme", 0);
user_pref("layout.css.prefers-color-scheme.content-override", 0);

// Toolbar, sidebar, find bar
user_pref("browser.toolbars.bookmarks.visibility", "always");
user_pref("browser.bookmarks.showMobileBookmarks", true);
user_pref("sidebar.main.tools", "aichat,syncedtabs,history,bookmarks,opentabs");
user_pref("sidebar.visibility", "hide-launcher");
user_pref("findbar.highlightAll", true);

// No Firefox Suggest in the address bar
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);

// No speculative DNS lookups, prefetches or connections
user_pref("network.dns.disablePrefetch", true);
user_pref("network.prefetch-next", false);
user_pref("network.http.speculative-parallel-limit", 0);

// Development
user_pref("devtools.toolbox.host", "right");
user_pref("security.fileuri.strict_origin_policy", false);

user_pref("browser.disableResetPrompt", true);
