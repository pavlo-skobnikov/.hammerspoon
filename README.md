# Personal Hammerspoon Configuration README

> **> [!IMPORTANT]**
> The repository is archived, as I've decided to stop using Hammerspoon in favor of simple
> configuration via Karabiner-Elements and native macOS Shortcuts. The repository is kept for
> reference purposes only.

<!--toc:start-->
- [Personal Hammerspoon Configuration README](#personal-hammerspoon-configuration-readme)
  - [Overview](#overview)
  - [Configuration Details](#configuration-details)
    - [Window Management (`Hyper + v`)](#window-management-hyper-v)
    - [Application Switching (`Hyper + s`)](#application-switching-hyper-s)
    - [Internet Browsing Profiles (`Hyper + b`)](#internet-browsing-profiles-hyper-b)
    - [System Controls (`Hyper + c`)](#system-controls-hyper-c)
    - [Screen Capture (`Hyper + z`)](#screen-capture-hyper-z)
    - [Miscellaneous Commands (`Hyper + x`)](#miscellaneous-commands-hyper-x)
    - [Alerts](#alerts)
<!--toc:end-->

## Overview

This README outlines the personal configuration for Hammerspoon, a powerful automation tool for
macOS. This configuration focuses on creating efficient workflows using `Hyper` sub-layer key
bindings, enhancing productivity and ease of use.

## Configuration Details

### Window Management (`Hyper + v`)

- **Half Screen Placement**:
  - `h`: Left half
  - `l`: Right half
  - `j`: Bottom half
  - `k`: Top half
- **Third Screen Placement**:
  - `n`: Left third
  - `m`: Middle third
  - `','`: Right third
- **Quarter Screen Placement**:
  - `y`: Top left quarter
  - `u`: Bottom left quarter
  - `i`: Bottom right quarter
  - `o`: Top right quarter
- **Other Actions**:
  - `p`: Maximize current window
  - `';'`: Center current window on screen

### Application Switching (`Hyper + s`)

Key bindings for quick application launching/focusing:

- `y`: Youtube Music
- `u`: Slack
- `i`: IntelliJ IDEA
- `o`: Finder
- `p`: NordPass
- `h`: Hammerspoon
- `j`: Mail
- `k`: Kitty
- `l`: Todoist
- `';'`: MacOS Calendar
- `n`: Obsidian
- `m`: Telegram

### Internet Browsing Profiles (`Hyper + b`)

Quickly open different Chrome profiles:

- `h`: Incognito
- `i`: Innovecs
- `p`: Personal
- `m`: Miro

### System Controls (`Hyper + c`)

Manage system controls like sound and brightness:

- `h`: Previous track
- `j`: Sound down
- `k`: Sound up
- `l`: Next track
- `';'`: Mute
- `u`: Brightness down
- `i`: Brightness up
- `o`: Fast forward
- `y`: Rewind
- `p`: Lock screen
- `'.'`: Play/Pause

### Screen Capture (`Hyper + z`)

Convenient screen capture shortcuts:

- `u`: Capture entire screen
- `i`: Capture entire screen to clipboard
- `j`: Capture area of screen
- `k`: Capture area of screen to clipboard
- `o`: Capture window

### Miscellaneous Commands (`Hyper + x`)

Various utility functions:

- `k`: Kill frontmost application
- `l`: Reload Hammerspoon configuration
- `m`: Open emoji picker

### Alerts

- On successful configuration load, a message 'Configuration reloaded' is displayed.
- When a sub-layer is triggered, a message with the sub-layer's name is shown.
- When `Esc` is pressed while in a sub-layer, a message is shown `Exiting [SUB-LAYER] mode`.

**Note:** The 'Hyper' key is a modifier key setup in mapped to a combination of the
`cmd+alt+ctrl+shift` keys. Thanks to `Karabiner Elements` this modifier combination is triggered
on a single key press of a specified key.
