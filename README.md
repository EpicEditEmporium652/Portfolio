# Roblox Luau Scripter — Portfolio

> I'm a self-taught Luau scripter specializing in physics simulation, mathematical systems, and game mechanics.

---

## 🎬 Featured Work — Facility Destruction Cinematic

A full cinematic nuclear destruction sequence.

**[▶ Watch the full video](https://youtu.be/gxNwwPd7i8M?si=yhvH5wQOrhx6ykE5)**

**[🎮 Try it live in-game](https://www.roblox.com/games/121525030356323/test-site-for-ABCG-2)**

### What's in it:
- 🔴 Sequential button system with indicator lights and screen display
- 🪪 Keycard scanner, detects equipped item, plays swipe animation on correct axis, returns card to player
- ⌨️ Functional keypad with code validation and indicator feedback
- 💡 Physics-based hanging lamp synced to audio via `PlaybackLoudness`
- 📷 Camera shake driven by real-time audio amplitude every Heartbeat frame
- ⚡ Camera exposure flash (`ExposureCompensation`) for the nuclear blast, not a white overlay, actual lighting
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
| Physics simulation | Drivetrain systems, engine mechanics, gear ratios, torque transfer, realistic vehicle physics |
| Weapon systems | Projectile physics, bullet drop, ballistic trajectory, hitbox detection |
| Vehicle systems | Engine simulation, gearbox, wheel physics, engine sounds |
| Mathematical systems | Custom physics formulas, bounce mechanics, slip ratio detection |
| Custom requests | Not sure if I can build it? Ask me, I'll let you know |

---

## 📁 Scripts

### ✅ Ready to Use
| Script | Description |
|---|---|
| [`Notification.lua`](/Scripts/Usable/Notification.lua) | Plug-and-play notification module. Call `module.sg("text", duration)` from any LocalScript |

### 👁️ Code Showcase
*these are pieces of bigger systems, read the code, or just try it yourself in-game*

| Script | What it does |
|---|---|
| [`shake.lua`](/Scripts/Showcase/shake.lua) | the nuclear explosion client. reads `PlaybackLoudness` every heartbeat frame and offsets the camera in real time, so the shake actually follows the audio. also kicks a physics lamp around and fires `ExposureCompensation` for the flash instead of just slapping a white frame on screen |
| [`proximity.lua`](/Scripts/Showcase/proximity.lua) | full replacement for roblox's default proximity prompt. built the whole UI myself, icon, action text, hold bar that fills on press, highlight on hover, sound on show. detects touch vs keyboard automatically and handles both. assets preload so nothing pops in late |
| [`admin-games.lua`](/Scripts/Showcase/admin-games.lua) | admin system. commands run through chat with a prefix, targets support `me` / `all` / `others` / partial names. bans and ranks save to DataStore so they survive server restarts. has offline ranking too, you can rank someone who isn't even in the game |
| [`main.lua`](/Scripts/Showcase/main.lua) | the main server script for the whole destruction sequence. builds the button, keypad, scanner, indicator lights, and screws entirely in code, nothing placed manually. runs a full state machine through part attributes, handles the keycard swipe, switches every light in the facility to red, locks blast doors and elevators, sequences the music, then resets everything and respawns all players when it's done. ~1000 lines |
| [`p1.lua`](/Scripts/Showcase/p1.lua) | phase 1 client. server fires once, client lights the indicator and flickers the screen display |
| [`p2.lua`](/Scripts/Showcase/p2.lua) | phase 2 client. server sends the timing value, client runs the whole progress bar animation locally, 0% to 100% at whatever speed the server decides |
| [`p3.lua`](/Scripts/Showcase/p3.lua) | phase 3 client. one fire from the server and the client handles everything, activation sound, notification, then a live countdown with a tick every second until FFD is ready |
| [`serverviewer-client.lua`](/Scripts/Showcase/serverviewer-client.lua) | client side of a real-time server state visualizer. toggles a top-down spectator view, clones and hides the local character so you don't visually disappear, streams live CFrame updates from the server every frame and applies them locally. caches resolved part paths so it's not traversing the tree on every update *(code only, no live demo)* |
| [`serverviewer-server.lua`](/Scripts/Showcase/serverviewer-server.lua) | server side of the visualizer. opens a Heartbeat connection per player on toggle, collects CFrame data for every relevant BasePart in the workspace and fires it to the client each frame. connection is stored and disconnected cleanly when the player toggles off *(code only, no live demo)* |

---

## 📦 Delivery

Scripts delivered via **GitHub loader**, one script to your game loads the script automatically. Any updates I push apply to your game instantly without republishing.

Everything is tested before delivery. I stress test edge cases myself so you don't run into bugs after launch. Client and server logic is always separated correctly so nothing can be exploited.

---

## 💰 Pricing

| Job Size | USD |
|---|---|---|
| Small scripts | $5-$10 |
| Larger systems | Discuss in DMs |

## 💳 Payment

- PayPal (preferred)
- Amazon gift card

---

## 📬 Contact

DM me on Discord to discuss your project.

---

*Scripts shown for Showcase purposes only. Do not copy, reuse, or redistribute without permission.*
