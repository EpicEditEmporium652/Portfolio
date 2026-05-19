# Roblox Luau Scripter — Portfolio

> Self-taught scripter. I build systems that don't just work, but *feel* right.

---

## 🎬 Featured Work — Facility Destruction Cinematic

A full cinematic nuclear destruction sequence.

**[▶ Watch the full video](https://youtu.be/gxNwwPd7i8M?si=yhvH5wQOrhx6ykE5)**

**[🎮 Try it live in-game](https://www.roblox.com/games/121525030356323/test-site-for-ABCG-2)**

### What's in it:
- 🔴 Sequential button system with indicator lights and screen display
- 🪪 Keycard scanner — detects equipped item, plays swipe animation on correct axis, returns card to player
- ⌨️ Functional keypad with code validation and indicator feedback
- 💡 Physics-based hanging lamp synced to audio via `PlaybackLoudness`
- 📷 Camera shake driven by real-time audio amplitude every Heartbeat frame
- ⚡ Camera exposure flash (`ExposureCompensation`) for the nuclear blast — not a white overlay, actual lighting
- 📺 Typewriter broadcast sequence with punctuation-aware timing synced to a clicking sound
- 🖤 Full screen fade from white to black with gradient separator lines
- 🔁 Server-wide respawn on sequence end

---

## 🛠️ What I Can Build

| System | Description |
|---|---|
| Cinematic sequences | Camera effects, screen transitions |
| Interactive mechanics | Buttons, keypads, keycard scanners, doors, levers |
| Custom proximity prompts | Full UI override with hold bar, highlight, touch + keyboard support |
| GUI systems | Notification modules, status displays, HUDs |
| Admin systems | Commands, persistent bans, DataStore ranks, offline ranking |
| DataStore | Save/load player data, persistent bans and ranks |
| Custom requests | Not sure if I can build it? Ask me, I'll let you know |

---

## 📁 Scripts

### ✅ Ready to Use
| Script | Description |
|---|---|
| [`Notification.txt`](/Scripts/Usable/Notification.txt) | Plug-and-play notification module. Call `module.sg("text", duration)` from any LocalScript |

### 👁️ Code Showcase
*Part of larger systems — view the code quality, try the full thing in-game*

| Script | Description |
|---|---|
| [`shake.txt`](/Scripts/Showcase/shake.txt) | Nuclear sequence — PlaybackLoudness camera shake, physics lamp, exposure flash, typewriter broadcast |
| [`proximity.txt`](/Scripts/Showcase/proximity.txt) | Custom ProximityPromptService override — hold bar, highlight, touch and keyboard support, asset preloading |
| [`admin-games.txt`](/Scripts/Showcase/admin-games.txt) | Full admin system — fly, kick, ban, setrank, permrank, offline ranking, server restart, DataStore persistence |
| [`main.txt`](/Scripts/Showcase/main.txt) | Full facility control system — state machine, dynamic world construction, emergency lighting, client replication, keypad, keycard scanner |
| [`p1.txt`](/Scripts/Showcase/p1.txt) | Lever 1 client — fires once, handles indicator light and tween locally |
| [`p2.txt`](/Scripts/Showcase/p2.txt) | Lever 2 client — server sends timing parameter, client runs full progress bar animation locally |
| [`p3.txt`](/Scripts/Showcase/p3.txt) | Nuclear sequence client — server fires once, client handles countdown, lights, sound, notification module |

---

## 📦 Delivery

Scripts delivered via **GitHub loader**, one script to your game loads the script automatically. Any updates I push apply to your game instantly without republishing.

---

## 💰 Pricing

| Job Size | Price |
|---|---|
| Small scripts | $5-$10 |
| Larger systems | Discuss in DMs |

## 💳 Payment

- Paypal
- Robux
- Amazon gift card

---

## 📬 Contact

DM me on Discord to discuss your project.

---

*Scripts shown for Showcase purposes only. Do not copy, reuse, or redistribute without permission.*
