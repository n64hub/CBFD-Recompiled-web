<img width="1360" height="768" alt="image" src="https://github.com/user-attachments/assets/abb979d7-24a5-44f8-98d3-088ba2054a74" />

# Conker's Bad Fur Day: Recompiled

> [!WARNING]
> **This is n64hub/CBFD-Recompiled-web, a fork, not Conker's Bad Fur Day: Recompiled.** Its `main` branch builds
> the game into a web page (WebGPU, through [N64Recomp-browser](https://github.com/n64hub/N64Recomp-browser)),
> and everything on that branch past upstream's commits was written by AI (Claude) for this fork. It is not made,
> endorsed or supported by the Conker's Bad Fur Day: Recompiled authors: please don't take issues with this fork to
> them. Building the page: [The web page](#the-web-page).
>
> This port is here to build out and test N64Recomp-browser's web support on another game than the one it was written
> for: what it turns up is fixed there where it can be, so every recomp's page gets the fix.

**Play it in the browser: https://n64hub.com/conker/**, with your own ROM, picked in the
launcher and kept in the browser. It needs WebGPU (Chrome or Edge 113 and up). The page is built from this branch
and published with N64Recomp-browser's `tools/publish_page.sh`, so it can be a commit or two behind.

A native PC port of **Conker's Bad Fur Day** (N64, US version). It's built by
statically recompiling the game with [N64Recomp](https://github.com/N64Recomp/N64Recomp),
starting from the [Conker decompilation](https://github.com/mkst/conker). It runs on
[N64ModernRuntime](https://github.com/N64Recomp/N64ModernRuntime) and is rendered by
[RT64](https://github.com/rt64/rt64).

> **This repository contains no game data.** You need your own legally obtained
> copy of the US ROM. Everything from the game is extracted from that ROM on
> your machine during the build.

## Download

Ready-to-play Windows, Linux and macOS (Apple Silicon, macOS 15 or later) builds
are on the [Releases page](https://github.com/sciaschi/CBFD-Recompiled/releases).
Unpack one anywhere, run `ConkerRecomp`, and pick your US ROM in the launcher the
first time. The packages contain no game data: you still need your own ROM. The
macOS app isn't signed with an Apple developer ID, so the first time, open it and
then choose **Open Anyway** in System Settings > Privacy & Security. To build it
yourself instead, read on.

## Features

- Runs natively on Windows (Direct3D 12 or Vulkan), Linux (Vulkan) and macOS
  (Metal), rendered by RT64. Supports higher resolutions, widescreen,
  anti-aliasing and high frame-rate presentation, with Conker, his shadow and the
  camera interpolated between the game's frames.
- Widescreen across gameplay, menus, cutscenes (or 4:3 cutscenes, with the
  **Cutscene Aspect Ratio** option), split screen and the pause screen, with the
  world drawn and culled for the wider view. **Overscan Borders** hides the N64's
  black border down each side.
- Game controllers and keyboard, with remappable controls (mouse buttons too) and
  rumble settings (motor, style and strength). N64 pads and adapters for real N64
  controllers are built in, and each controller gets its own player in
  multiplayer.
- Mouse and gyro aiming, a free camera on the right stick (or the mouse) that
  stays out of walls, camera turning speed and inversion, and a Field of View
  setting.
- An aiming **Reticle**, a green ring like Live & Reloaded's, and **Swap Sticks**
  and **Lock-On** options for aiming.
- Full audio: music, sound effects and the voice acting.
- Saving (EEPROM), stored per user.
- A launcher with settings, controls and a mod menu (RecompFrontend, as in
  Zelda 64: Recompiled and Banjo: Recompiled).
- The game's reflective surfaces (Conker's glass, the logo's sheen) and its point
  lights (the bar's lantern, the N64 logo), drawn as on the N64.
- **Conker's Detail** keeps Conker on his most detailed model, and **Show FPS**
  puts a frame rate counter in the corner.
- Achievements, the program's own, for reaching the game's scenes.
- ROM hacks that only change the game's assets, such as the uncensored and the
  Russian translation ROMs, with the launcher switching between them.
- Mod support (`.nrm` mods: function patches and hooks). Three mods are
  included: **Skip Intro**, **Skip Any Cutscene** and **Cheats**.
- Texture packs (RT64's `.rtz`, and GLideN64's `.htc`), for HD textures and
  other replacements.
- Save states: save anywhere with F5 and load with F7, in nine slots
  ([how to use them, and how they work](docs/save-states.md)).

## Status

The game is playable, and has been played through to the end. Known issues:

- Widescreen: the pause menu's blurred background is the 4:3 frame scaled up to
  the full width, so its top and bottom are cropped.
- Only the US ROM is supported (and ROM hacks that only change its assets: see
  [ROM hacks](#rom-hacks)).
- Linux: the game is played on Linux with real GPU drivers, the Steam Deck
  included, and the build is tested on Ubuntu 24.04. Reports from other
  distributions and GPUs are welcome, especially about performance or audio.
- macOS: the game is played on Apple Silicon with Metal (the build is tested on
  an Apple M3 Pro with macOS 27 and Xcode 27). It hasn't been confirmed played
  through on macOS yet, and Intel Macs haven't been tried.

If the game crashes on Windows, a report is written to `crash.log` next to the
executable and shown in a message box. On Linux and macOS, the crash report is printed
to the terminal. Please include it when reporting a problem.

## What you need to build it

- The **US** ROM of Conker's Bad Fur Day in big-endian `.z64` format, with
  SHA-1 `4cbadd3c4e0729dec46af64ad018050eada4f47a`. It is never committed: the
  build extracts what it needs from your copy.
- A folder path without an apostrophe (`'`) to clone into. Some of RT64's build
  steps break on one.

Then follow the guide for your system: [Windows](#building-on-windows),
[Linux](#building-on-linux) or [macOS](#building-on-macos). Each is one command
once the tools are installed. The first full build takes a while, because the
recompiled game is a lot of C code.

## Building on Windows

Windows 10 or 11 (x64). Everything builds natively; `build.cmd` does all of it.

### 1. Install the tools (once)

- [Git for Windows](https://git-scm.com/download/win).
- [Python 3](https://www.python.org/downloads/). In the installer, tick *Add
  python.exe to PATH*.
- **Visual Studio 2022 or later** with the *Desktop development with C++*
  workload. The free *Build Tools for Visual Studio* edition is enough.

### 2. Get the code and build

In a Command Prompt, in the folder you want it in (for example `D:\Games`), with
the path to your ROM:

```bat
git clone --recursive https://github.com/sciaschi/CBFD-Recompiled.git
cd CBFD-Recompiled
build.cmd "C:\path\to\your\conker.z64"
```

The first build takes a while. When it's done, the game is
`host\build-win\ConkerRecomp.exe` (see [Playing](#playing)).

### Updating

```bat
git pull
build.cmd
```

The script updates the submodules and their patches, and only rebuilds what
changed.

## Building on Linux

Tested on Ubuntu 24.04 (x86-64). You need a Vulkan driver: Mesa's, which most
distributions install by default, or NVIDIA's.

```sh
git clone --recursive https://github.com/sciaschi/CBFD-Recompiled.git
cd CBFD-Recompiled
./build.sh ~/path/to/your/conker.z64
```

On Ubuntu and Debian, the script lists the packages it's missing and offers to
install them. On other distributions, install the equivalents of `git python3
cmake ninja-build clang pkg-config libsdl2-dev libdbus-1-dev libfreetype-dev`
yourself. When it's done, run `host/build/ConkerRecomp` (see [Playing](#playing)).

To update: `git pull`, then `./build.sh` again.

## Building on macOS

macOS on Apple Silicon or Intel. The game renders with Metal. `build.sh` does all
of it, as on Linux.

### 1. Install the tools (once)

- **Xcode**, from the App Store. The Command Line Tools alone aren't enough: RT64
  compiles its shaders with Xcode's Metal compiler. Open Xcode once to finish its
  setup. If `xcode-select -p` doesn't print a path inside `Xcode.app`, run
  `sudo xcode-select -s /Applications/Xcode.app`.
- [**Homebrew**](https://brew.sh).
- Optionally, for building mods: `brew install llvm` (Apple's clang can't compile
  for the N64's MIPS processor).

### 2. Get the code and build

In Terminal, in the folder you want it in, with the path to your ROM:

```sh
git clone --recursive https://github.com/sciaschi/CBFD-Recompiled.git
cd CBFD-Recompiled
./build.sh ~/path/to/your/conker.z64
```

Put the ROM's path in quotes if it has spaces or an apostrophe, for example
`./build.sh "$HOME/Downloads/Conker's Bad Fur Day (USA).z64"`.

The first build takes a while. If some tools are missing, the script lists the
Homebrew packages (`cmake ninja pkg-config sdl2 freetype`) and offers to install
them. It also offers to download Xcode's Metal Toolchain (about 850 MB), which
Xcode 26 and later install separately. When it's done, the game is
`host/build/ConkerRecomp` (see [Playing](#playing)).

To turn it into a standalone `ConkerRecomp.app` that runs without Homebrew (as the
release workflow does), run `sh host/package_macos.sh` after `brew install
dylibbundler`. The app ends up in `host/build/`.

### Updating

```sh
git pull
./build.sh
```

The script updates the submodules and their patches, and only rebuilds what
changed.

## The web page

This fork's `main` branch also builds with [Emscripten](https://emscripten.org) into a page, `ConkerRecomp.html`, that
draws through WebGPU. `tools/N64Recomp`, `tools/N64ModernRuntime`, `tools/rt64` and `tools/RecompFrontend` are
upstream's own submodules at upstream's commits, and [N64Recomp-browser](https://github.com/n64hub/N64Recomp-browser)
(`tools/N64Recomp-browser`) adds the web support: `build.sh` applies its `patches/` on top of this game's patches in
`recomp/` (all of it behind `__EMSCRIPTEN__` or `__wasm__`, so the native game builds as before), and it makes the game a
page. `tools/web_patch.sh` applies them a project at a time, with three files left out where this game's patches change
the same lines: N64Recomp's `src/analysis.cpp`, whose change, finding a jump table in another section,
`recomp/n64recomp.patch` already makes its own way, rt64's `src/hle/rt64_game_frame.h`, whose one line
(`buildCallHashMap` taking a sorted vector) `tools/web_rt64_game_frame.patch` puts beside `recomp/rt64.patch`'s, and
the runtime's `ultramodern/src/timer.cpp`, which `recomp/n64modernruntime.patch` rewrites: `tools/web_timer.patch`
polls for a timer less than 2 ms away there, since the page's timed waits can end late (in Firefox on Windows, on the
system timer's 15.6 ms tick), as the web's runtime patch does upstream's. Those three are the web's change as the
N64Recomp-browser commit the script names had it, and what the web has changed in them since is merged in
(`apply.cmake --since`), so a later web change reaches the page; one that meets this game's lines stops the build.
timer.cpp's merge starts at a later commit: the web's change there keeps upstream's set of timers in order, and this
game's list under a lock has no order to lose. Mods
are off on the page: the runtime can't recompile a mod's code there. So are save states: the runtime tells where each
game thread waits by its native call stack, which wasm can't walk at every wait, so `tools/web_save_states.patch` builds
that file without one and the page sets no save state keys (`host/src/frontend.cpp`).

Build and recompile with `build.sh` first (Linux, macOS, or WSL on Windows), with your ROM: the page needs the code
the patched N64Recomp writes, and `build.cmd` doesn't apply N64Recomp-browser's patches. Then, with the Emscripten SDK installed and activated and [naga](https://github.com/gfx-rs/wgpu/tree/trunk/naga)
installed (`cargo install naga-cli`):

```sh
embuilder build sdl2-mt freetype-legacysjlj      # once
emcmake cmake -S host -B host/build-web -G Ninja -DCMAKE_BUILD_TYPE=Release -DRT64_NAGA_EXECUTABLE=<naga>
cmake --build host/build-web
```

With [ccache](https://ccache.dev) on `PATH`, a second build directory inside the checkout compiles almost nothing
again. `host/build-web` then holds `ConkerRecomp.html`, `.js`, `.wasm`, `.data` and `coi_serviceworker.js`. The page needs a
browser with WebGPU (Chrome or Edge 113 and up) and must be cross-origin isolated: serve the folder with
`Cross-Origin-Opener-Policy: same-origin` and `Cross-Origin-Embedder-Policy: require-corp`, or on a host that can't set
headers, as is, and `coi_serviceworker.js` sets them after one reload. The player picks their ROM in the launcher; it,
the settings and the saves are kept in the browser's IndexedDB for that origin.

The game's code runs at TLB-mapped addresses, and some of it reads tables in its own code pages, which the host copies
to RDRAM + 0x95000000 and + 0x96000000 (`host/src/overlays.cpp`). Natively that is inside the runtime's 4 GB
reservation; on a page RDRAM is an allocation in the wasm heap, so the host moves the heap's break past those addresses
and the page's memory grows to about 2.5 GB of address space, most of it never touched. A fixed 3 GB heap (no growth)
measured no faster, and `-sGROWABLE_ARRAYBUFFERS=2` stops at the first compute pass: emdawnwebgpu passes WebGPU views
of the heap, which the browser refuses over a growable buffer. So it grows.

RT64's render to RAM draws each frame a second time at the N64's resolution and reads it back into RDRAM. It stays on,
on the page too: the camera reads a row of the depth buffer to step aside from walls, and the lens flares read it to
hide behind them. Without it both read only the game's own "far" fill. A display list that waited for that readback
took two to three times as long, so the page copies the frame into RDRAM a list late
(`recompui::renderer::set_render_to_ram_late`): the copy lands while the next list is drawn, and no list waits.
The camera steps aside from walls the same way with it. Measured on 2026-10-12 in headless Chrome at 960x720, the bar after Start Game, 60 s a run, runs interleaved,
under heavy load from other work (CPU 100%, GPU 20-35%). Per list is the wall time of RT64's work on a
display list, median:

```
                     lists/s   per list   the browser's CPU
render to RAM on      19-28     20-27 ms   2.6-2.9 cores
render to RAM off     24-30      7-11 ms   2.4-2.5 cores (one run 4.0)
```

One of the five runs with it on stopped drawing three seconds into the game, which none of the five with it off did.
This hasn't been looked into.

With the copy a list late, measured on 2026-10-13 in headless Chrome 155 at 960x720, Windy walked and turned in for
about 100 s a run, three runs of each interleaved, with the host ~60% busy with other work:

```
                            lists/s   per list
copy before the list ends      30     14.8-16.4 ms
copy a list late               30     10.7-11.8 ms
```

The code leaves a function by jumping to another one, which the recompiled C writes as a call and a return. Natively
the compiler makes that a jump again; in WebAssembly it stays a call unless it is a wasm tail call, so the game's
chains of them grew the browser's stack until the page stopped ("Maximum call stack size exceeded", leaving the bar
after the intro). The page is built with `-mtail-call`, and N64Recomp-browser's patch to N64Recomp writes each one as a forced tail call then.
Sound plays through N64Recomp-browser's AudioWorklet output on the browser's audio thread, resampled to its rate
(`host/src/audio_output.cpp`): SDL2's port plays from the page's thread, where WebGPU's work runs.

The page builds the shaders the game uses from a list, `host/rt64_shaders.txt` (specialized and run through spirv-opt
when the page is built; N64Recomp-browser and its rt64), so no scene draws with the slow ubershader. The list is in sections: the first, the intro and the bar's menus (85
shaders, 75 pipelines), then one a chapter (It's War has two) and one a multiplayer mode. In Chrome the whole list is
built in the background, the first section and the first chapter's first on half the host's cores, then the rest one
at a time with a section the game has reached moved to the front, and the game waits only when a frame wants 4 or more of a
section's shaders that aren't built yet, under a small "Preparing graphics" indicator in a corner. Firefox builds a
pipeline in line with the rest of its GPU work, so there the first section is built before the game passes its first
frame and each of the others when the game first draws with it, the game waiting. Before N64Recomp-browser v0.27.0
Chrome waited the same way: in headless Chrome on a desktop GPU (2026-10-13, RTX 2070, under heavy load from other
work) the first took 5.4 s on a first visit and 0.2 s
on the next (2.3-3.9 s once a visit to the chapters had filled Chrome's pipeline cache, 6 MB for every site together),
and a chapter's 4.6 s (Windy, 82 pipelines) to 6.1 s (Uga Buga, 116) on a first visit. A shader the list misses is
built behind the game, and the page remembers it (`localStorage`) and builds it with its section on the next visit.
The list is recorded by code, not by playing: `bash tools/record_shaders.sh <build dir> <ROM>` (its header says how;
about 55 minutes) has `tools/shader_survey.js` start every chapter's places from the game's own checkpoint table, and
each multiplayer mode, in headless Chrome, and the list's header says what it covers. `tools/play_plan.json` plays
the page as a player would, for N64Recomp-browser's `tools/play_page.mjs`, in 2-3 minutes: the intro, then Windy's
first checkpoint, started by the same script, its cutscene skipped, and Conker on foot. `tools/play_plan_extended.json`,
for when a longer play is needed, goes on to Bats Tower's, Sloprano's and Uga Buga's first checkpoints in the same load,
each about 15 s, in at most 5 minutes (their headers say more).

Firefox refuses a view of more than 2 GB of memory as a WebGPU argument, and Conker's heap grows past that, so the page
starts there only since rt64-web c3d781a, which copies `setBindGroup`'s dynamic offsets out of the heap. Before
plume-web 97f4e64, Firefox also lost the WebGPU device ("Out of Memory") in Windy, about 18 s after the shader plan's
skip to checkpoint 33. What lost it was the bind groups RT64 makes as it rewrites its texture sets every frame,
4,000-14,000 a second at checkpoint 33, which a browser frees only when JavaScript collects them; plume-web 97f4e64
keeps them by what they bind, and the live ones stay at about 4,500.

With the copy a list late, the CPU writes to a framebuffer whose copy is pending about ten times in Windy's first
checkpoints, and each write is kept (the console reports them). The pause menu draws over a garish, smeared copy of the
scene: that is the game's own pause background, not corruption, in both browsers, and the game plays on once unpaused.

Upstream's 0.1.6, merged in, makes room in the frame's display lists, which crashed leaving Spooky and ran the heap out
in Windy (#98), and drops sprite pieces under a pixel across, which crashed by Windy's beehive. A route by checkpoint
(`startCheckpoint` from `tools/shader_survey.js`) through Spooky's Zombie Grave Shoot, Count Batula, Zombie Fest and
Haunted Barrel Roll, the bank and Windy's The Queen's lost her Home! reaches neither crash, and the page before the
merge plays it without one too: upstream's route that halted is the barrel up Windy's water, the money and out to
Birdy, and the beehive's crash comes after the Queen Bee.

How the page plays, in each browser and on which GPU, is recorded in N64Recomp-browser's
[plays.jsonl](https://github.com/n64hub/N64Recomp-browser/blob/main/plays.jsonl) and its
[games table](https://github.com/n64hub/N64Recomp-browser#games).

## What the build does

`build.sh` holds the full sequence, if you'd rather run the steps yourself:

1. Checks your ROM (copied to `conker/baserom.us.z64`) and applies the patches in
   `recomp/` to N64Recomp, N64ModernRuntime, RT64 and RecompFrontend, and then (in
   `build.sh`) N64Recomp-browser's web support on top ([The web page](#the-web-page)).
2. Builds N64Recomp.
3. Runs `recomp/recompile.py`, which unpacks the game's code from your ROM and
   recompiles it into `RecompiledFuncs/`. Which functions there are, and where,
   comes from `recomp/conker.us.syms.toml`: names, addresses and sizes, but no
   code. The code itself only ever comes from your ROM.
4. Builds the game (`host/`) with CMake.

### Working on the decompilation

`recomp/conker.us.syms.toml` (and `mods/syms/`) are generated from the
decompilation in `conker/`, which needs its own Linux tools: IDO, which runs
through the MIPS binutils, and the Python packages in `requirements.txt`. On
Linux, macOS, or in WSL on Windows, `./build.sh --decomp` builds the decompilation
too, checks that it rebuilds your ROM's code byte for byte, and regenerates those
files from it (`recomp/run.sh`). The decompilation is a work in progress, and
most of the code is still the original assembly.
[DevOldSchool's conkers-bfd-decomp](https://github.com/DevOldSchool/conkers-bfd-decomp)
is further along, and this project follows its progress
([issue #57](https://github.com/sciaschi/CBFD-Recompiled/issues/57)).

On macOS, `--decomp` also needs `coreutils` and `mips-linux-gnu-binutils` from
Homebrew (the script offers to install them). The decompilation comes with two
Linux programs, the IDO compiler and a patched gzip that compresses exactly as the
original game's did, so the script puts macOS replacements in `tools/macos/`:
IDO's macOS build from
[ido-static-recomp](https://github.com/decompals/ido-static-recomp), and GNU gzip
1.10 built with the same one-line change.

## Playing

Run `host/build/ConkerRecomp` (Linux and macOS) or `host\build-win\ConkerRecomp.exe`
(Windows). The first time, pick **Load ROM** in the launcher and select your ROM
(the same `baserom.us.z64` works). After that it's remembered, so just choose
**Start Game**.

- **Settings** (in the launcher, or Esc / the controller's menu button in game)
  has its options by tab: General (deadzone, rumble), Camera (turning, the free
  camera, field of view, aiming with the stick), Mouse & Gyro, Graphics
  (resolution, aspect ratio, anti-aliasing, frame rate, texture packs), Controls,
  Sound, Achievements and Mods. The tabs scroll sideways when they don't all fit.
- **Achievements** are the program's own, for reaching the game's scenes (the
  ones its Chapters menu lists), from the first death to the end credits. They're
  kept on this computer, in `achievements.txt` with the settings, and the
  Achievements tab lists them. Only what you do in play counts: scenes a save
  had already reached unlock when a new game reaches them.
- Saves, settings and the stored ROM live in `~/.config/ConkerRecompiled` on
  Linux, `~/Library/Application Support/ConkerRecompiled` on macOS and
  `%LOCALAPPDATA%\ConkerRecompiled` on Windows. Put an empty `portable.txt` next
  to the executable to keep them there instead.
- **Save states**: F5 saves the game exactly as it is, F7 loads it back, F6
  picks the next of the nine slots. They never touch the game's own saves. See
  [docs/save-states.md](docs/save-states.md).
- Default keyboard controls: move with WASD, A = Space, B = Left Shift,
  Z = Q, L = E, R = R, Start = Enter, C buttons = arrow keys, D-pad = IJKL.
  Everything can be remapped in Controls.
- N64 pads and adapters for real N64 controllers (raphnet-tech's, Mayflash,
  Hyperkin, the NSO and 8BitDo 64 controllers) are mapped from
  `assets/controllerdb.txt`, with the C buttons as the right stick. A controller
  SDL doesn't know can be given a mapping in the `SDL_GAMECONTROLLERCONFIG`
  environment variable, which takes precedence.

## ROM hacks

A ROM hack that only changes the game's assets (its audio, textures, models or
text), such as an uncensored patch that restores the bleeped words, plays like the
US ROM. The recompiled code only comes from the ROM's code, which has to be the US
ROM's, so hacks that change the game's code are refused. A hack that repacks the
game's compressed code without changing it, as the Russian fan translation does, is
checked unpacked and plays too (**Version: US Russian**).

The launcher's **Version** option says which ROM is in play, with its region (for
example **Version: US Original** or **Version: US Uncensored**), and so does the
window's title. **Add ROM** loads another: pick the hack's `.z64`, and it's put in
play. After that, selecting Version switches between the ROMs you've loaded. Other
regions' ROMs (such as the European one) are refused, with a message naming the
region. Each is kept in `rom_versions/` in the data
folder (64 MB apiece). Saves are shared between them.

## Mods

Mods are `.nrm` files. Install one by copying it into the `mods` folder of the
data folder above (or dropping it onto the Mods menu), then enable it in the
**Mods** menu. Some mods have options there too.

Each release has the included mods built, in its `Mods` zip (the same `.nrm`
files work on every system). Their source is in `mods/`. Build one on Linux, macOS
(which also needs `brew install llvm lld`, as Apple's clang can't compile for MIPS)
or in WSL, from the repository root, after `recomp/run.sh`. It links with `ld.lld`
(`sudo apt install lld`), or GNU ld (`mips-linux-gnu-ld`) where there's none, but
GNU ld can't link a mod that calls the game's functions, such as Skip Intro:

```sh
sh mods/build_mod.sh mods/skip_cutscenes
```

The `.nrm` ends up in the mod's `build/` folder.

- **Skip Intro** (`mods/skip_intro`): boots straight to the main menu, skipping
  the notices, logos and the chainsaw opening.
- **Skip Any Cutscene** (`mods/skip_cutscenes`): L skips a cutscene even the
  first time you see it. An option also allows skipping the ones the game never
  lets you skip.
- **Cheats** (`mods/cheats`): infinite health, infinite lives and a full wallet,
  each toggled in the mod's options.

Writing your own is covered in [recomp/README.md](recomp/README.md#mods).

### Texture packs

Texture packs replace the game's textures with new ones, such as HD textures.
They're RT64 texture packs, the same format as Zelda 64: Recompiled's and Banjo:
Recompiled's: an `rt64.json` listing each texture's hash and its replacement
image. Install a `.rtz` pack like a mod (the `mods` folder, or dropped onto the
Mods menu), then pick it in **Settings > Graphics > Texture Pack**, which turns it on and
the other packs off. Packs installed while the game runs are listed there from
the next start. Its default, **Set in the Mods Menu**, leaves them to the
**Mods** menu instead, where several can be on at once (later ones in the list
take precedence).

GLideN64 texture packs (for Project64 and RetroArch) work too. Install the
pack's `.htc` file the same way (**Install Mods** or dropped onto the Mods menu),
or put it in the `mods` folder and start the game or press the Mods menu's
refresh button: it's unpacked, once, into a pack folder beside it, with its
progress shown (a large pack takes a minute or so), and turned on. It's then in
the **Mods** menu, and listed in **Settings > Graphics > Texture Pack**. GLideN64 names each texture by a
different hash than RT64 (Rice's), which the game's RT64 works out as each
texture is loaded. Only packs stored as RGBA8 are unpacked (not those built with
texture compression).

[`tools/texture_packs/gliden64_to_rt64.py`](tools/texture_packs/gliden64_to_rt64.py)
makes a `.rtz` from a GLideN64 pack (a `.htc`, or a folder of
`...#crc#format#size_all.png` files) to share:

```sh
python tools/texture_packs/gliden64_to_rt64.py pack.htc --out my_pack --name "My Pack" --author Me --rtz my_pack.rtz
```

Given folders of textures dumped while playing (RT64's developer mode, below:
F1, **Start dumping textures**), it instead lists the dumped textures with
RT64's hashes, as RT64 without live matching needs (see the tool).

To make a pack from scratch, put a folder in `mods` with a `mod.json` (`"game_id": "conker"`,
plus an `id`, `version`, `display_name`, `authors` and `minimum_recomp_version`)
and an `rt64.json`:

```json
{ "configuration": { "configurationVersion": 3, "hashVersion": 5 }, "textures": [] }
```

With it enabled, and RT64's developer mode on (`"developer_mode": true` in
`graphics.json` in the data folder), RT64's inspector (F1) shows each draw's
texture hash and has a **Replace** button that picks an image and adds it to the
folder's `rt64.json`. Zip the folder's contents (without `mod.json`) and rename
it to `.rtz` to share it.

## How it works

[recomp/README.md](recomp/README.md) documents the whole pipeline:

- how the decomp's ELF is prepared for N64Recomp (`recomp/prepare_elf.py`);
- the recompiler configuration and hooks (`conker.toml`);
- the audio microcode;
- the changes to N64Recomp, N64ModernRuntime and RT64 (Conker's graphics
  microcode, widescreen);
- the host application in `host/`;
- debugging tools.

## AI assistance

This project was made with heavy use of an AI coding assistant (Claude, through
Claude Code). That covers the recompilation setup, the patches to the tools, the
host application, the mods, and the functions decompiled to C in this repository.

What's checked, and how:

- **Decompiled C** is only kept when it compiles to exactly the original
  instructions. The build fails unless the rebuilt code is byte-for-byte
  identical to the ROM's.
- **The port** is checked by playing it, and by comparing its behaviour with
  the original running in an emulator.

What isn't checked: names, types and comments don't change the compiled bytes,
so a byte-for-byte match says nothing about whether they're right. Names that
end in an address (for example `resetSlotState_150104F0`) are best guesses based
on what the code appears to do. Treat them as hints, not established facts.

This is an independent project. The AI-assisted work here isn't part of the
upstream decompilation, and the people behind that project and other N64
decompilation communities aren't responsible for it. Please report problems here,
not to them.

## Contributing

Bug reports, fixes and patches are welcome: see [CONTRIBUTING.md](CONTRIBUTING.md).

## Credits

- The [Conker's Bad Fur Day decompilation](https://github.com/mkst/conker) project,
  whose work this is built on.
- The macOS port, and support for ROM hacks, by
  [nitrostemp](https://github.com/nitrostemp).
- [N64Recomp](https://github.com/N64Recomp/N64Recomp),
  [N64ModernRuntime](https://github.com/N64Recomp/N64ModernRuntime) and
  [RecompFrontend](https://github.com/N64Recomp/RecompFrontend) by Wiseguy and
  contributors.
- [RT64](https://github.com/rt64/rt64) by Darío and contributors.
- [ConkerBFDReloaded](https://github.com/DahSidiAbdallah/ConkerBFDReloaded) by
  dahmedvall95, whose widescreen pause background led to this project's.
- The mod headers follow the
  [Banjo: Recompiled mod template](https://github.com/BanjoRecomp/BKRecompModTemplate).
- Fonts: [Inter](https://rsms.me/inter/), [Noto Emoji](https://fonts.google.com/noto/specimen/Noto+Emoji)
  and [promptfont](https://shinmera.github.io/promptfont/).

## License

This project's own code is under the [MIT License](LICENSE). The submodules keep
their own licenses, and a build combines them:

- N64ModernRuntime (librecomp and ultramodern) is under the
  [GPL, version 3](tools/N64ModernRuntime/COPYING). As the program includes it,
  the program as a whole is distributed under the GPL version 3, which gives
  everyone who gets it the right to its source: this repository, at the release's
  tag. The release packages include the GPL's text (`LICENSE-GPL-3.0.txt`) and
  [`LICENSES.txt`](.github/release/LICENSES.txt), which lists them.
- RT64 is under the MIT License, but the live texture pack matching that
  [`recomp/rt64.patch`](recomp/rt64.patch) adds (`src/hle/rt64_rice_hash.cpp`) is
  under the GPL, version 2 or later: it imitates the Rice texture hashing of
  GlideHQ (Hiroshi Morii, as in GLideN64) and Rice Video, both under the GPL
  version 2 or later ([recomp/README.md](recomp/README.md#local-changes-to-the-tools)).
  That's compatible with the GPL version 3.
- The macOS linker wrapper, [`host/macos/ld64`](host/macos/ld64), which lets mods
  patch the program's code there, follows Banjo: Recompiled's
  ([github.com/BanjoRecomp/BanjoRecomp](https://github.com/BanjoRecomp/BanjoRecomp),
  `.github/macos/ld64`) and is under the GPL, version 3, as that is. It's only
  used to build, and isn't part of the program.

The game itself is not included and not covered by them.

Conker's Bad Fur Day is © Rare Ltd. This project is not affiliated with or
endorsed by Rare, Microsoft or Nintendo.
