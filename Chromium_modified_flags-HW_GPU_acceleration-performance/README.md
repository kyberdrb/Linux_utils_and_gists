# Chromium - faster and more efficient

## `chromium-flags.conf`

What to do with the `chromium-flags.conf.*` files? Choose the one corresponding to the manufacturer of your GPU and rename it to `*.conf`, i.e. remove the suffix, and copy to `$HOME/.config/` to [preserve changes](https://wiki.archlinux.org/index.php/Chromium#Making_flags_persistent)

Configurationsl were tested on Intel iGPU HD Graphics 520 of i5-6300U (Skylake) and AMD Radeon 8400/AMD Radeon R3 of AMD Athlon 5350 APU (Kabini)

- If screen tearing is still present, sometimes `--use-gl=desktop` can fixes the tearing. Source: https://wiki.archlinux.org/index.php/Chromium#
    - `--enable-oop-rasterization` enables `Out-of-process Rasterization: Hardware accelerated` in `chrome://gpu` - [Chromium flags](https://www.reddit.com/r/vscode/comments/fp6zao/how_do_i_pass_chromium_flags_to_vs_code/)
    - `--disable-gpu-driver-bug-workarounds` sometimes lowers the CPU strain at video playback - [Chromium screen tearing fix](https://www.reddit.com/r/archlinux/comments/8n5w7z/chromiumchrome_full_screen_videos_screen_tearing/), [Chromium screen tearing fix - original answer](https://bbs.archlinux.org/viewtopic.php?pid=1788065#p1788065)
    - `--enable-zero-copy` changes `Tile Update Mode` from `One-copy` to `Zero-copy` - faster rendering - [Source](https://www.ghacks.net/2017/01/31/chromes-rendering-gets-faster-here-is-what-google-does-not-tell-you/)
    - `--enable-native-gpu-memory-buffers` - [Source](https://software.intel.com/content/www/us/en/develop/articles/zero-copy-texture-uploads-in-chrome-os.html)
    - `--force-gpu-rasterization` - [Description](https://www.chromium.org/developers/design-documents/chromium-graphics/how-to-get-gpu-rasterization)
    - `--enable-impl-side-painting` - [Explanation](http://www.chromium.org/developers/design-documents/impl-side-painting) - [Is it already enabled by default?](https://codereview.chromium.org/830273003/)


## Sources

[Chromium modified flags - Source](https://gist.github.com/ibLeDy/1495735312943b9dd646fd9ddf618513)

Example of `chromium-flags.conf` for full HW video acceleration - https://bbs.archlinux.org/viewtopic.php?pid=1868591#p1868591

egl backend broken - https://bbs.archlinux.org/viewtopic.php?pid=1923456#p1923456

desktop backend possibly working - https://bbs.archlinux.org/viewtopic.php?pid=1923532#p1923532

