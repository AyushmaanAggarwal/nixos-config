{pkgs, ...}: let
  extension = shortId: uuid: {
    name = uuid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "force_installed";
    };
  };
in {
  programs.firefox.policies = {
    # Find all admin policies options here: https://mozilla.github.io/policy-templates/
    DisableAccounts = false;
    DisableFirefoxAccounts = false;

    DontCheckDefaultBrowser = true;
    DisableTelemetry = true;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableFirefoxScreenshots = true;
    PromptForDownloadLocation = false;
    TranslateEnabled = true;

    OfferToSaveLogins = false;
    PasswordManagerEnabled = false;

    HardwareAcceleration = true;

    # Security
    DisableSecurityBypass = false;
    DisableSetDesktopBackground = true;
    HttpsOnlyMode = "enabled";

    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    CaptivePortal = true;

    OverrideFirstRunPage = "";
    OverridePostUpdatePage = "";
    DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
    DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"

    SearchBar = "unified"; # alternative: "separate"
    SearchEngines = {
      PreventInstalls = true;
      Remove = [
        "Google"
        "Bing"
        "eBay"
        "Amazon.com"
      ];
    };

    UserMessaging = {
      UrlbarInterventions = false;
      SkipOnboarding = true;
    };

    FirefoxSuggest = {
      WebSuggestions = false;
      SponsoredSuggestions = false;
      ImproveSuggest = false;
    };

    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };

    Homepage.StartPage = "previous-session";
    NewTabPage = true;
    FirefoxHome =
      # Make new tab only show search
      {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
      };

    # ---- EXTENSIONS ----
    # Check about:support for extension/add-on ID strings.
    # Valid strings for installation_mode are "allowed", "blocked",
    # "force_installed" and "normal_installed".
    ExtensionSettings = builtins.listToAttrs [
      (extension "ublock-origin" "uBlock0@raymondhill.net")
      (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}") # Bitwarden
      (extension "darkreader" "addon@darkreader.org") # Dark Reader
      # (extension "sidebery" "{3c078156-979c-498b-8990-85f7987dd929}") # Sideberry
    ];

    # ---- PREFERENCES ----
    # Check about:config for options.
    Preferences = {
      # Disable DOH as system has preconfigured dns over https
      "network.trr.mode" = 5;

      #
      "browser.tabs.groups.enabled" = true;
      "browser.toolbarbuttons.introduced.sidebar-button" = true;

      # Disable inspector
      "devtools.inspector.enabled" = false;
      "devtools.inspector.inactive.css.enabled" = false;
      "devtools.inspector.rule-view.focusNextOnEnter" = false;
      "devtools.inspector.three-pane-enabled" = false;
      "devtools.performance.popup.feature-flag" = false;
      "devtools.inspector.draggable_properties" = false;

      # General Browser
      "browser.contentblocking.category" = {
        Value = "strict";
        Status = "locked";
      };
      "extensions.pocket.enabled" = false;
      "extensions.screenshots.disabled" = false;
      "browser.topsites.contile.enabled" = false;
      "browser.search.suggest.enabled" = false;
      "browser.search.suggest.enabled.private" = false;
      "browser.urlbar.suggest.searches" = false;
      "browser.urlbar.showSearchSuggestionsFirst" = true;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "browser.newtabpage.activity-stream.feeds.snippets" = false;
      "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
      "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = true;
      "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = true;
      "browser.newtabpage.activity-stream.section.highlights.includeVisited" = true;

      # Remove Sponsored Ads
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.system.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

      # Remove Telemetry
      "browser.newtabpage.activity-stream.feeds.telemetry" = false;
      "browser.newtabpage.activity-stream.telemetry" = false;
      "browser.newtabpage.activity-stream.telemetry.ut.events" = false;
      "browser.search.serpEventTelemetryCategorization.enabled" = false;
      "browser.search.serpEventTelemetryCategorization.regionEnabled" = false;
      "dom.security.unexpected_system_load_telemetry_enabled" = false;
      "identity.fxaccounts.telemetry.clientAssociationPing.enabled" = false;
      "network.trr.confirmation_telemetry_enabled" = false;
      "nimbus.telemetry.targetingContextEnabled" = false;
      "telemetry.fog.artifact_build" = false;
      "telemetry.fog.init_on_shutdown" = false;
      "toolkit.telemetry.enabled" = false;
      "datareporting.usage.uploadEnabled" = false;

      # Privacy Options
      "privacy.clearOnShutdown.cache" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "privacy.clearOnShutdown.downloads" = false;
      "privacy.clearOnShutdown.formdata" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.sessions" = false;
      "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = false;
      "privacy.clearOnShutdown_v2.cache" = false;
      "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
      "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;
      "privacy.donottrackheader.enabled" = true;
      "privacy.fingerprintingProtection" = true;
      "privacy.globalprivacycontrol.enabled" = true;
      "privacy.globalprivacycontrol.was_ever_enabled" = true;
      "privacy.query_stripping.enabled" = true;
      "privacy.query_stripping.enabled.pbmode" = true;
      "privacy.trackingprotection.emailtracking.enabled" = true;
      "privacy.trackingprotection.enabled" = true;
      "privacy.trackingprotection.socialtracking.enabled" = true;

      # Don't Sync Sensitive Options
      "services.sync.declinedEngines" = "passwords,addresses,creditcards";
      "services.sync.engine.addresses.available" = true;
      "services.sync.engine.passwords" = false;

      # Sidebar Options
      "sidebar.visibility" = "hide-sidebar";
      "sidebar.verticalTabs" = false;
      "sidebar.revamp" = false;
      "browser.aboutConfig.showWarning" = false;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

      # Disable all autofill options
      "browser.formfill.enable" = false;
      "extensions.formautofill.addresses.enabled" = false;
      "extensions.formautofill.addresses.capture.enabled" = false;
      "extensions.formautofill.addresses.experiments.enabled" = false;
      "extensions.formautofill.creditCards.enabled" = false;
      "extensions.formautofill.heuristics.autofillSameOriginWithTop" = false;
      "extensions.formautofill.heuristics.captureOnFormRemoval" = false;
      "extensions.formautofill.heuristics.captureOnPageNavigation" = false;
      "extensions.formautofill.heuristics.detectDynamicFormChanges" = false;
      "extensions.formautofill.heuristics.fillOnDynamicFormChanges" = false;
      "extensions.formautofill.heuristics.refillOnSiteClearingFields" = false;
    };
  };
}
