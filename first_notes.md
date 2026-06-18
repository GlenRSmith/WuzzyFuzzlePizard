# Idea

Wuzzy Fuzzle Pizard is a puzzle game, triple Spoonerism of Fuzzy Puzzle Wizard.
The player is the puzzle wizard.
The basic concept is that the wizard has a magic pipe that lets them enter "fuzzy" mode so they can gain points by solving puzzles.
Design options:
1. The puzzles can be solved in default mode, but no achievements are earned.
2. The elements of the puzzle can be inspected in default mode, but only manipulated and solved in fuzzy mode.
Interesting option:
* Higher gradations of fuzzy mode act as achievement multipliers.

## Example

Suppose there is a jigsaw puzzle with the image of a pipe-smoking wizard on it.
The player examines the puzzle in its assembled state. When they are ready, they start.
Tthat means that the player character raises a long-stemmed pipe to their lips, takes a big drag, puts the pipe down (maybe coughs a few times), the puzzle gets all fuzzy, the pieces scatter around, and they can begin putting them back together.
Fuzzy might mean that the images on each piece are completely or partially obscured, that the details of the edges (innies and outies that connect the pieces) are obscured, or both.
The player can surrender, then fuzzy mode clears and the pieces animated reassemble into the completed puzzle.

When the game starts, the assembled puzzle, with visible cut lines, is in the left half of the play area. When the player presses START (to be replaced with a thematically suitable word later), the whole gaming chamber fills with smoke, and a wavy animation of the Gaming Wizard fades into superimposition over the board. I'll device a sound effect later. Once the puzzle is obscured, the pieces are shuffled. The wizard disappears in a *puff*, and the player is now free to move the pieces into the right side. There will be a setting that controls whether:
A - When a piece is dropped in the right place in the target grid, the unfuzzy piece is shown
B - No pieces are revealed until they are all in the correct target location.

Some celebration animation will happen when the pieces are correctly placed.

Hopefully I can extend this basic concept into other types of puzzles.

# Gameplay

This is pretty open right now. Simpler to develop and change is better, though.

# Choices

## Framework(s)/platform(s)

* Godot is chosen for the framework initially based on analysis below.
* Something has to manage artwork visual and audio artifacts. Maybe it's the same as the code platform.

### Some options

There are a ton of them listed in the universe.

- Godot
- GDevelop
- Bevy
- O3DE
- Panda3D
- Monogame
- LOVE
- Pygame
- **Defold**
- **Pyxel**
- **raylib
- **Phaser**
- **Ebitengine**


### Some criteria

I'm probably not thinking of all the criteria, bue some are:

* I want to iterate fairly rapidly.
* My strongest development language is python, but I have developed Modula 2, C++, Java, and C# (including XNA game programming for the .Net compact framework), so for a project this size, I can probably adapt to anything.
* I have no plans to monetize this, so features related to copy protection and the like aren't needed.
* I do want it to be dead simple to run on Windows and Mac, hopefully on Linux but that's not as crucial.

### Platform analysis

Comparison focused on a small 2D puzzle game, single developer, rapid iteration, Python-leaning but flexible, easy Win/Mac (Linux nice-to-have), no monetization concerns.

#### Candidates from the initial list

**Godot (4.x, GDScript / C# / Python-ish)**
- Pros:
  - Best all-around fit for a small 2D puzzle game in 2026: mature, huge community, MIT-licensed.
  - Built-in editor manages art, audio, scenes, animation, UI — one tool, no asset-pipeline glue.
  - GDScript is Python-flavored; productive in a day.
  - One-click export to Windows, macOS, Linux, plus Web/Mobile if desired.
  - Excellent shader support for the "fuzzy" effect (blur/distortion on puzzle pieces).
- Cons:
  - Not actual Python (GDScript is similar but not identical; godot-python bindings exist but are second-class).
  - macOS export needs codesigning steps for truly "dead simple" distribution (true of almost everything).

**GDevelop**
- Pros: No-code/visual events; fastest possible prototyping; web + desktop export.
- Cons: Event-system ceiling appears fast for non-trivial mechanics; less control over custom shaders for the fuzzy effect.

**Bevy (Rust)**
- Pros: Modern ECS, great for systems-heavy games, very fast.
- Cons: Rust learning curve + compile times kill rapid iteration; no editor (UI built in code); overkill for a 2D puzzler. Skip unless learning Rust is a goal.

**O3DE**
- Pros: AAA-grade 3D engine, open source.
- Cons: Massive, 3D-focused, heavy build setup. Wildly mismatched to a 2D puzzle game. Skip.

**Panda3D (Python)**
- Pros: Real Python; mature.
- Cons: 3D-oriented; no scene editor; distribution on Mac is fiddly; small community in 2026.

**MonoGame (C#)**
- Pros: Direct heir to XNA experience; clean C#; cross-platform.
- Cons: It's a framework, not an engine — no editor, build everything yourself (asset pipeline, UI, scene management). Slows iteration.

**LÖVE (Lua)**
- Pros: Tiny, fast, fun; great for 2D; trivial to distribute (single .love file).
- Cons: Lua (new language); no editor; assemble own tooling.

**Pygame**
- Pros: Pure Python — strongest language; minimal abstraction.
- Cons: No editor, no scene system, no UI toolkit, software-ish rendering by default. Distributing to Mac as a clean app bundle is painful (PyInstaller + codesigning gymnastics). Iteration is fast at the code level but slow at the "polish a game" level.

**Defold** (Lua, free, source-available): Excellent 2D engine from King; tiny binaries, superb cross-platform export (Win/Mac/Linux/Web all one-click), built-in editor. Strong alternative to Godot for 2D. Lua is the only friction.

**Pyxel** (Python): Retro 8-bit-style. Fun, but the aesthetic constraint (16 colors, low res) probably doesn't suit a "fuzzy jigsaw of a wizard" vibe.

**raylib + Python bindings (pyray / raylib-python-cffi)**: Real Python, simple immediate-mode API. No editor though.

**Phaser** (JS/TS, web): If "runs in a browser" counts as "dead simple on Win/Mac," easiest distribution story possible — send a URL. Strong 2D, huge ecosystem.

**Ebitengine** (Go): Lovely 2D engine, trivial single-binary export to all desktops. Go is easy to pick up.

#### Recommendation

- **Top pick: Godot 4.** Hits every criterion: rapid iteration (editor + hot reload + Python-like scripting), excellent 2D + shaders for the fuzzy effect, trivial multi-platform export, manages art/audio assets natively, strongest open-source engine ecosystem in 2026.
- **Runner-up: Defold** for an even lighter footprint, if Lua is acceptable.
- **Pygame** only if this project should double as a "pure Python, learn-the-fundamentals" exercise rather than the shortest path to a polished game.

