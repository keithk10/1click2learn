# 1Click2Learn

A 2010 Flash learning game, playable in a modern browser.

**Play:** https://keithk10.github.io/1click2learn/

The original Flash files (`.swf`) run through [Ruffle](https://ruffle.rs), a Flash Player emulator built with WebAssembly. No Flash plugin is needed.

The first load downloads about 50 MB, so it may take a moment on a slow connection.

## Files

- `index.html`: the player page
- `Introduction*.swf`: the game (the main file loads the others)
- `ruffle/`: Ruffle 0.8.0-nightly.2026.10.15 (MIT / Apache-2.0, see the licence files in that folder)
