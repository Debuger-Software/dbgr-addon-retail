# DBGR

DBGR is a lightweight World of Warcraft Retail addon that provides a small collection of quality-of-life features and notifications.

It was originally created for personal use and has been developed and maintained over time as a compact utility addon without unnecessary dependencies or large frameworks.

## Features

- Loot message improvements with item icons
- Experience gain information
- Playtime statistics
- AFK warning
- Auction House notifications
- Mailbox information
- Unspent talent point warning
- Basic addon settings panel
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

Opens the main DBGR window.

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

If you encounter a bug or incompatibility after a World of Warcraft update, please report it through the repository issue tracker or the CurseForge project page.

When reporting an issue, please include:

- World of Warcraft version
- DBGR version
- What happened
- What you expected to happen
- Any Lua error message, if available

## Download

The recommended way to install and update DBGR is through CurseForge:

https://www.curseforge.com/wow/addons/dbgr

The GitHub repository is primarily intended for source code access, development history and issue tracking.

## Author

**Debuger Software**
