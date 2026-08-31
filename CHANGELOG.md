## Version 12.5.5 - 31/08/2026 17:45

### Talent Points

* Fixed the unspent talent points message.

### AFK Warning Improvements

* AFK warning is now delayed by 20 minutes after entering AFK state.
* Warning timer is cancelled automatically when the player becomes active again.
* Replaced chat-message based AFK detection with `PLAYER_FLAGS_CHANGED` / `UnitIsAFK()` state tracking.

### Mailbox Improvements

* Fixed the mail summary popup so it now closes together with the mailbox window, including when closed with Escape.
