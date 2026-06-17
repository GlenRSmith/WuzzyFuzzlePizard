# Initial Project Setup — Wuzzy Fuzzle Pizard (Godot 4)

Goal: stand up an empty, version-controlled Godot 4 project for **Wuzzy Fuzzle Pizard** with all dependencies sandboxed to the project directory (no global installs where avoidable). Targets: Windows + macOS (Linux as a bonus).

## 1. What Godot needs (and doesn't)

Godot is refreshingly lightweight compared to most engines:

- **No SDK install, no package manager, no compiler toolchain** required for GDScript-only development.
- The Godot editor is a single self-contained executable (~100 MB). It bundles its own scripting runtime, asset importer, and exporter.
- Export templates (the engine binaries shipped inside your final game) are downloaded once from inside the editor.
- The only real "dependency" is the editor binary itself. We'll keep it inside the project tree so the whole thing is portable.

This means "sandboxing" mostly means: don't install Godot system-wide, keep the editor + export templates + any third-party addons local to the repo.

## 2. Directory layout

Create this structure under `d:\Projects\WuzzyFuzzlePizard\`:

```
WuzzyFuzzlePizard/
├── first_notes.md
├── init_project_instructions.md
├── .gitignore
├── .gitattributes
├── README.md                 (optional, later)
├── tools/                    (sandboxed binaries — gitignored)
│   └── godot/                (the editor lives here)
└── game/                     (the actual Godot project)
    ├── project.godot         (created by the editor on first run)
    ├── addons/               (third-party GDScript addons, vendored)
    ├── assets/               (art, audio, fonts — source-of-truth)
    │   ├── art/
    │   ├── audio/
    │   └── fonts/
    ├── scenes/               (.tscn scene files)
    ├── scripts/              (.gd script files)
    └── shaders/              (.gdshader files — the fuzzy effect lives here)
```

Rationale: keeping `tools/` outside `game/` means the editor binary, export templates, and any future helper utilities never get picked up by Godot's asset importer.

## 3. Install Godot (sandboxed)

### Windows

1. Download **Godot 4.x Standard (not .NET)** from https://godotengine.org/download/windows/ — pick the Windows 64-bit ZIP.
   - Use Standard unless you specifically want C# scripting. GDScript is recommended for this project.
2. Extract the ZIP into `d:\Projects\WuzzyFuzzlePizard\tools\godot\`. You should end up with `tools\godot\Godot_v4.x.x-stable_win64.exe`.
3. (Optional) Rename the exe to `godot.exe` for convenience.
4. Launch it by double-clicking — it requires no installation, no admin rights, no registry entries. All editor settings are stored in `%APPDATA%\Godot\` by default; see step 5 to redirect them.

### macOS

1. Download the macOS Universal `.app.zip` from the same page.
2. Extract into `tools/godot/`. You'll have `tools/godot/Godot.app`.
3. First launch: right-click → Open (to bypass Gatekeeper for the unsigned binary), or run `xattr -dr com.apple.quarantine tools/godot/Godot.app` from Terminal.

### Linux (optional)

1. Grab the Linux x86_64 ZIP, extract to `tools/godot/`, `chmod +x` the binary.

### Step 5 — Make editor settings project-local (true sandbox)

Godot supports "self-contained mode": if a file named `._sc_` (or `_sc_`) exists next to the editor binary, Godot stores all editor config, cache, and templates **next to the binary** instead of in `%APPDATA%` / `~/Library`.

From `d:\Projects\WuzzyFuzzlePizard\tools\godot\`:

```powershell
New-Item -ItemType File -Name "._sc_"
```

Now everything — editor settings, downloaded export templates, recent project list — lives inside `tools/godot/`. Delete that folder and Godot leaves zero trace on the machine.

## 4. Create the empty project

1. Launch the Godot editor.
2. Project Manager → **New Project**.
   - Project Name: `Wuzzy Fuzzle Pizard`
   - Project Path: `d:\Projects\WuzzyFuzzlePizard\game`
   - Renderer: **Forward+** (good shader support for the fuzzy effect; switch to Compatibility later if targeting low-end machines).
   - Version Control Metadata: **Git**
3. Click **Create & Edit**. Godot generates `project.godot`, `icon.svg`, and `.godot/` (import cache).
4. Quit the editor once, so all files are flushed to disk.

## 5. Download export templates (sandboxed)

Needed only when you want to ship a build; safe to do now.

1. In the editor: **Editor → Manage Export Templates → Download and Install**.
2. Because self-contained mode is on, templates land in `tools/godot/editor_data/export_templates/` instead of `%APPDATA%`.

## 6. Git setup

From `d:\Projects\WuzzyFuzzlePizard\`:

```powershell
git init
git branch -M main
```

Create `.gitignore`:

```gitignore
# Sandboxed tools — never commit the editor or templates
/tools/

# Godot import cache and per-user state
game/.godot/
game/.import/

# Exported builds
/builds/
game/export_presets.cfg

# OS / editor cruft
.DS_Store
Thumbs.db
*.swp
.vscode/
.idea/
```

Create `.gitattributes` (Godot files are text; force LF and mark binaries):

```gitattributes
* text=auto eol=lf
*.png binary
*.jpg binary
*.ogg binary
*.wav binary
*.ttf binary
*.otf binary
```

Then:

```powershell
git add .
git commit -m "Initial Godot 4 project scaffold for Wuzzy Fuzzle Pizard"
```

## 7. Recommended editor settings

Inside the editor (**Editor → Editor Settings**):

- **Interface → Editor → Save On Focus Loss**: on (helps with hot reload).
- **Text Editor → Behavior → Files → Trim Trailing Whitespace on Save**: on.
- **Network → HTTP Proxy**: leave default unless behind a corporate proxy.

Inside the project (**Project → Project Settings**):

- **Application → Config → Name**: `Wuzzy Fuzzle Pizard`
- **Display → Window → Size**: `1280 x 720` (good starting resolution; easy to scale).
- **Display → Window → Stretch → Mode**: `canvas_items` (clean 2D scaling).
- **Rendering → Textures → Canvas Textures → Default Texture Filter**: `Linear` (smoother for puzzle piece blurs).

## 8. Optional third-party addons (vendored under `game/addons/`)

None required to start. Candidates to consider later, all installed by copying their folder into `game/addons/` (no package manager):

- **Dialogue Manager** — if the wizard ever needs to talk.
- **Phantom Camera** — smooth 2D camera control.
- **GUT** (Godot Unit Test) — unit tests for puzzle logic.

The Godot **Asset Library** tab inside the editor downloads these directly into the project — no global install.

## 9. Smoke test

1. Reopen the editor, load the project.
2. Scene → New Scene → 2D Scene. Add a `Label` node, set text to `Wuzzy Fuzzle Pizard`.
3. Save as `scenes/main.tscn`.
4. Project → Project Settings → Application → Run → Main Scene → pick `scenes/main.tscn`.
5. Press **F5**. A window should appear with the label. Sandbox confirmed.

## 10. Uninstall / move

Because nothing is installed globally and self-contained mode is on:

- **Move to another machine**: zip the whole `WuzzyFuzzlePizard/` folder (including `tools/`) and unzip elsewhere. It just runs.
- **Uninstall**: delete the folder. Done.
