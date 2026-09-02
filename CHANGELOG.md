## Version 12.5.5 - 31/08/2026
### Talent Points

* Fixed the unspent talent points message.

### AFK Warning Improvements

* AFK warning is now delayed by 20 minutes after entering AFK state.
* Warning timer is cancelled automatically when the player becomes active again.
* Replaced chat-message based AFK detection with `PLAYER_FLAGS_CHANGED` / `UnitIsAFK()` state tracking.

### Mailbox Improvements

* Fixed the mail summary popup so it now closes together with the mailbox window, including when closed with Escape.

---

## Version 12.5.6 - 01/09/2026

### Settings Improvements

* Updated `/dbgr config` to open the addon settings directly in the Blizzard Settings panel.
* Fixed compatibility with the current Retail addon settings API by using the registered category ID instead of the category name.

---

## Version 12.5.7 - 02/09/2026

### Visual Refresh

* Replaced the outdated message box background with a cleaner, modern design inspired by the current World of Warcraft interface.
* Improved the frame’s readability while preserving the addon’s original dark style.

### Death Knight Runeforging

* Added a warning when a Death Knight equips a weapon without a rune.
* The warning is automatically cleared after equipping a properly runed weapon.
