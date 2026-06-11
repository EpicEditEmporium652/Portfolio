[![Portfolio Rated 86/100 - Gold](https://rohire.dev/api/portfolio-rater/badge/128?style=modern&v=rohire-modern-v8)](https://rohire.dev/portfolio-rater?id=128)

# Roblox Luau Scripter

> Self-taught Luau scripter. I build fully-coded systems, cinematic sequences, game mechanics, physics simulations, admin tools, DataStore. Everything in code, nothing placed manually. All done on mobile.

---

## 🎬 Projects

### 🖥️ Facility Destruction Cinematic

A full cinematic nuclear destruction sequence, ~1000 lines, built entirely in code.



![FFD](https://github.com/user-attachments/assets/62122a23-64f6-4223-9d9c-ea46e132d387)



**[▶ Watch the full video](https://youtu.be/gxNwwPd7i8M?si=yhvH5wQOrhx6ykE5)**  
**[🎮 Try it live in-game](https://www.roblox.com/games/121525030356323/test-site-for-ABCG-2)**

#### What's in it:
- 🔴 Sequential button system with indicator lights and screen display, built entirely in code, nothing placed in Studio
- 🪪 Keycard scanner, detects equipped item, plays swipe animation on correct axis, returns card to player
- ⌨️ Functional keypad with code validation and indicator feedback
- 💡 Physics-based hanging lamp synced to audio via `PlaybackLoudness`
- 📷 Camera shake driven by real-time audio amplitude every Heartbeat frame
- ⚡ Camera exposure flash (`ExposureCompensation`) for the nuclear blast, not a white overlay, actual lighting
- 📺 Typewriter broadcast sequence with punctuation-aware timing synced to a clicking sound
- 🖤 Full screen fade from white to black with gradient separator lines
- 🔁 Server-wide respawn on sequence end

---

### 🚗 Inline-4 Engine Simulation with Gear Drivetrain

A physically accurate engine and drivetrain simulation built entirely in Roblox.



![I4-Engine](https://github.com/user-attachments/assets/a26e141b-a83e-4c60-bd12-2911264848db)



**[▶ Watch the video](https://youtu.be/ZObuodU8pMo?si=Bjxd609wfaKOoHQU)**

#### What's in it:
- 🔩 Crankshaft and piston motion built entirely with Roblox physics constraints, not animated or tweened
- 🔊 Combustion audio triggered per cylinder in 1-3-4-2 firing order, timed by script
- ⚙️ Gear ratios calculated mathematically from part size, tooth mesh collision is unreliable at speed so the math drives it instead
- 🔄 Bevel gear direction change from engine to axle
- 🚗 Fully working wheel drivetrain

---

## 🛠️ What I Can Build

| System | Description | Proof |
|---|---|---|
| Cinematic sequences | Camera effects, screen transitions, exposure flash, typewriter broadcasts | [Shake.lua](/Scripts/Showcase/Shake.lua), [Main.lua](/Scripts/Showcase/Main.lua) |
| Interactive mechanics | Buttons, keypads, keycard scanners, doors, levers | [Main.lua](/Scripts/Showcase/Main.lua) |
| Custom proximity prompts | Full UI override with hold bar, highlight, touch and keyboard support | [ProximityPrompt.lua](/Scripts/Showcase/ProximityPrompt.lua) |
| GUI systems | Notification modules, status displays, HUDs | [Notification.lua](/Scripts/Usable/Notification.lua) |
| Admin systems | Commands, persistent bans, DataStore ranks, offline ranking | [Admin.lua](/Scripts/Showcase/Admin.lua) |
| DataStore | Save/load player data, persistent stats, persistent bans | [Admin.lua](/Scripts/Showcase/Admin.lua) |
| Vehicle simulation | Engine simulation, drivetrain, gear ratios, torque transfer, wheel physics, engine sounds | I4 Engine project above |
| Realistic physics | Physics constraints, audio-driven impulse, rope constraints | [Shake.lua](/Scripts/Showcase/Shake.lua), [Main.lua](/Scripts/Showcase/Main.lua) |
| Combat systems | Projectile physics, bullet drop, ballistic trajectory, hitbox detection | *Available on request* |
| Bug fixing | I work inside existing codebases, test edge cases, find what breaks before you do | |
| Custom requests | Not sure if I can do it? Ask me, I'll let you know | |

---

## 📁 Scripts

### ✅ Ready to Use
| Script | Description |
|---|---|
| [`Notification.lua`](/Scripts/Usable/Notification.lua) | Plug-and-play notification module. Call `module.sg("text", duration)` from any LocalScript |

### 👁️ Code Showcase
*These are pieces of bigger systems, read the code, or try it yourself in-game*

| Script | What it does |
|---|---|
| [`Main.lua`](/Scripts/Showcase/Main.lua) | The main server script for the whole destruction sequence. Builds the button, keypad, scanner, indicator lights, and screws entirely in code, nothing placed manually. Runs a full state machine through part attributes, handles the keycard swipe, switches every light in the facility to red, locks blast doors and elevators, sequences the music, then resets everything and respawns all players when done. ~1000 lines |
| [`Shake.lua`](/Scripts/Showcase/Shake.lua) | The nuclear explosion client. Reads `PlaybackLoudness` every Heartbeat frame and offsets the camera in real time, so the shake actually follows the audio. Also kicks a physics lamp around and fires `ExposureCompensation` for the flash instead of just slapping a white frame on screen |
| [`ProximityPrompt.lua`](/Scripts/Showcase/ProximityPrompt.lua) | Full replacement for Roblox's default proximity prompt. Built the whole UI from scratch, icon, action text, hold bar that fills on press, highlight on hover, sound on show. Detects touch vs keyboard automatically and handles both. Assets preload so nothing pops in late |
| [`Admin.lua`](/Scripts/Showcase/Admin.lua) | Admin system. Commands run through chat with a prefix, targets support `me` / `all` / `others` / partial names. Bans and ranks save to DataStore so they survive server restarts. Includes offline ranking, you can rank someone who isn't even in the game |
| [`Phase1.lua`](/Scripts/Showcase/Phase1.lua) | Phase 1 client. Server fires once, client lights the indicator and flickers the screen display |
| [`Phase2.lua`](/Scripts/Showcase/Phase2.lua) | Phase 2 client. Server sends the timing value, client runs the whole progress bar animation locally, 0% to 100% at whatever speed the server decides |
| [`Phase3.lua`](/Scripts/Showcase/Phase3.lua) | Phase 3 client. One fire from the server and the client handles everything, activation sound, notification, then a live countdown with a tick every second until FFD is ready |
| [`Serverviewer_client.lua`](/Scripts/Showcase/Serverviewer_client.lua) | Client side of a real-time server state visualizer. Toggles a top-down spectator view, clones and hides the local character so you don't visually disappear, streams live CFrame updates from the server every frame and applies them locally. Caches resolved part paths so it's not traversing the tree on every update *(code only, no live demo)* |
| [`Serverviewer_server.lua`](/Scripts/Showcase/Serverviewer_server.lua) | Server side of the visualizer. Opens a Heartbeat connection per player on toggle, collects CFrame data for every relevant BasePart in the workspace and fires it to the client each frame. Connection is stored and disconnected cleanly when the player toggles off *(code only, no live demo)* |

---

## 📦 Delivery

Scripts delivered via file.

Everything is tested before delivery. I test edge cases myself so you don't run into bugs after launch. Client and server logic is always separated correctly so exploiters can't abuse server-side behavior.

---

## 💰 Pricing

| Job Size | USD |
|---|---|
| Small scripts | $5–$25 |
| Larger systems | Starting from $30, discuss in DMs |

**💳 Payment:** PayPal

---

## 📬 Contact

Have a project in mind? **DM me on Discord, I typically reply within 24 hours.**

**Discord:** @epiceditemporium  
**Email:** epiceditemporium@proton.me

---

*Code shown for portfolio purposes only.*
