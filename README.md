# DBGR

DBGR is a lightweight World of Warcraft Retail addon that provides a small collection of quality-of-life features and notifications.

It was originally created for personal use and has been developed and maintained over time as a compact utility addon without unnecessary dependencies or large frameworks.

## Features

- Loot message improvements with item icons
- Experience gain information
- Playtime statistics
- Delayed AFK warning
- Auction House notifications
- Mailbox information
- Incoming guild chat message notifications
- Unspent talent point warning
- Death Knight Runeforging warning for weapons without a rune
- Integrated addon settings in the Blizzard Settings panel
- English and Polish localization
- Custom UI message frame
- Optional notification sound

## Supported Game Version

DBGR is intended for the current World of Warcraft Retail client.

The addon may stop working correctly after major game updates if Blizzard changes the related API.

## Installation

Extract the addon into:

```text
World of Warcraft/_retail_/Interface/AddOns/DBGR
```

The final directory should contain files such as:

```text
DBGR.lua
DBGR.toc
MainFrame.xml
SettingsFrame.xml
locale.lua
img/
snd/
```

After installation, restart the game or reload the interface.

## Commands

```text
/dbgr
```

Shows the most recently displayed DBGR message box and its last message.

```text
/dbgr config
```

Opens the addon settings.

```text
/dbgr playtime
```

Displays character playtime statistics.

## Source Code

This repository contains the source code used by the Retail version of DBGR.

The addon is intentionally kept relatively small and easy to inspect.

Binary assets located in the `img` and `snd` directories are part of the addon interface and notification system.

## Issues

If you encounter a bug or incompatibility after a World of Warcraft update, the preferred way to report it is by email:

**debuger@debuger.eu**

When reporting an issue, please include:

- World of Warcraft version
- DBGR version
- What happened
- What you expected to happen
- Any Lua error message, if available

## Download

The recommended way to install and update DBGR is through CurseForge:

https://www.curseforge.com/wow/addons/dbgr

The GitHub repository is primarily intended for source code access and development history.

## Author

**Debuger Software**
