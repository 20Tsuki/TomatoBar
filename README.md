# TomatoBar 🍅

A minimalist macOS menu bar Pomodoro timer. Stay focused, take breaks, track your progress.

## Features

- **Pomodoro Timer** — 25 min focus + 5 min short break + long break, fully customizable
- **Menu Bar** — Lives in your menu bar with a live countdown and mode label
- **Notifications + Sound** — System alerts when a session ends
- **Auto-Start** — Optionally start the next round automatically
- **History & Stats** — Daily, weekly, and monthly charts (Swift Charts)
- **Lightweight** — Pure SwiftUI, minimal resource usage

## Usage

1. Click the 🍅 icon in the menu bar to open the panel
2. Tap "Start Focus" to begin your first Pomodoro
3. Break sessions start automatically, or skip manually
4. Switch to the Stats tab to view your history
5. Switch to the Settings tab to customize durations and behavior

## Installation

### Homebrew (recommended)

```bash
brew install 20tsuki/tap/tomatobar
```

### Manual Download

Download the latest version from [Releases](https://github.com/20Tsuki/TomatoBar/releases) and drag `TomatoBar.app` into your `Applications` folder.

### Build from Source

```bash
git clone https://github.com/20Tsuki/TomatoBar.git
cd TomatoBar
open TomatoBar.xcodeproj
```

## Tech Stack

- **SwiftUI** — UI framework
- **SwiftData** — Local persistence
- **Swift Charts** — Statistics charts
- **MenuBarExtra** — Menu bar integration
- **UserNotifications** — System notifications
- **Sparkle 2** — Auto-update
- Minimum: macOS 14

## License

MIT
