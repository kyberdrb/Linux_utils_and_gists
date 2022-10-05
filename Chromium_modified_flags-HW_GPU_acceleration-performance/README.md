# Chromium - faster and more efficient

## Usage

`chromium-flags.conf` file is used to [preserve changes](https://wiki.archlinux.org/index.php/Chromium#Making_flags_persistent) without typing it directly to the terminal as options when launching `chromium` each time I want to browse. The type of configuration file depends on your GPU.

First, back up current chromium configuration, if any:

    cp ~/.config/chromium-flags.conf ~/.config/chromium-flags.conf.bak

### Intel GPU

Link or Copy new configuration file

    ln -sf REPO_LOCATION/Chromium_modified_flags-HW_GPU_acceleration-performance/chromium-flags.conf.intel_gpu ~/.config/chromium-flags.conf
    
or

    cp REPO_LOCATION/Chromium_modified_flags-HW_GPU_acceleration-performance/chromium-flags.conf.intel_gpu ~/.config/chromium-flags.conf
    
### AMG GPU

Link or Copy new configuration file

    ln -sf REPO_LOCATION/Chromium_modified_flags-HW_GPU_acceleration-performance/chromium-flags.conf.amd_gpu ~/.config/chromium-flags.conf
    
or

    cp REPO_LOCATION/Chromium_modified_flags-HW_GPU_acceleration-performance/chromium-flags.conf.amd_gpu ~/.config/chromium-flags.conf

Configurationsl were tested on Intel iGPU HD Graphics 520 of i5-6300U (Skylake) and AMD Radeon 8400/AMD Radeon R3 of AMD Athlon 5350 APU (Kabini)

- If screen tearing is still present, sometimes `--use-gl=desktop` can fixes the tearing. Source: [Arch Linux - Chromium](https://wiki.archlinux.org/index.php/Chromium#)
    - [`MojoVideoDecoder`, i. e. VAAPI acceleration in Chromium](https://github.com/saiarcot895/chromium-ubuntu-build/issues/98#issuecomment-711220942) is in the Chromium v88.0.4324 enabled by default without the need of a `--use-gl` flag on AMD Radeon R3/8400 and, apparently Intel GPUs, although mine HD 520 worked out of the box with Chromium [and Firefox], and libva hybrid drivers or intel media drivers for VAAPI acceleration. `--use-gl=egl` doesn't work either, as it doesn't enable the MojoVideoDecoder. Only deleting the flag `--use-gl` enables the GPU video decoding with MojoVideoDecoder.
    - `--enable-oop-rasterization` enables `Out-of-process Rasterization: Hardware accelerated` in `chrome://gpu` - [Chromium flags](https://www.reddit.com/r/vscode/comments/fp6zao/how_do_i_pass_chromium_flags_to_vs_code/)
    - `--disable-gpu-driver-bug-workarounds` sometimes lowers the CPU strain at video playback - [Chromium screen tearing fix](https://www.reddit.com/r/archlinux/comments/8n5w7z/chromiumchrome_full_screen_videos_screen_tearing/), [Chromium screen tearing fix - original answer](https://bbs.archlinux.org/viewtopic.php?pid=1788065#p1788065)
    - `--enable-zero-copy` changes `Tile Update Mode` from `One-copy` to `Zero-copy` - faster rendering - [Source](https://www.ghacks.net/2017/01/31/chromes-rendering-gets-faster-here-is-what-google-does-not-tell-you/)
    - `--enable-native-gpu-memory-buffers` - [Source](https://software.intel.com/content/www/us/en/develop/articles/zero-copy-texture-uploads-in-chrome-os.html)
    - `--force-gpu-rasterization` - [Description](https://www.chromium.org/developers/design-documents/chromium-graphics/how-to-get-gpu-rasterization)
    - `--enable-impl-side-painting` - [Explanation](http://www.chromium.org/developers/design-documents/impl-side-painting) - [Is it already enabled by default?](https://codereview.chromium.org/830273003/)
    - `--disable-software-rasterizer` - ?
    - `--disable-gpu-driver-workarounds` - ?
    - `--disable-features=UseChromeOSDirectVideoDecoder` - ?
    - `--enable-accelerated-2d-canvas` - sets `Canvas:` to `Hardware accelerated`
    - `--enable-accelerated-video-decode` - ?
    - `--enable-accelerated-mjpeg-decode` - ?
    - `--enable-drdc` - sets `Direct Rendering Display Compositor:` to `Enabled`

    - `--enable-features=ParallelDownloading,UnexpireFlagsM90,VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization,RawDraw,EnableDrDc`
    - `VaapiVideoDecoder` sets `Video Decode:` to `Hardware accelerated` from `Software only. Hardware acceleration disabled`
    - `VaapiVideoEncoder` sets `Video Encode:` to `Hardware accelerated` from `Software only. Hardware acceleration disabled`

    - `--enable-gpu-compositing` - sets `Compositing:` to `Hardware accelerated`
    - `--enable-native-gpu-memory-buffers` - ?
    - `--enable-gpu-rasterization` - sets `Rasterization:` to `Hardware accelerated`
    - `--enable-oop-rasterization` - sets `Canvas out-of-process rasterization:` to `Enabled`
    - `--enable-raw-draw` - sets `Raw Draw:` to `Enabled`
    - `--ignore-gpu-blocklist` - ?
    - `--num-raster-threads=6` - sets `Multiple Raster Threads:` to `Force enabled`?


## Sources

- [Chromium modified flags - Source](https://gist.github.com/ibLeDy/1495735312943b9dd646fd9ddf618513)
- Example of `chromium-flags.conf` for full HW video acceleration - https://bbs.archlinux.org/viewtopic.php?pid=1868591#p1868591
- egl backend broken :( - using `--use-gl=desktop` instead - https://bbs.archlinux.org/viewtopic.php?pid=1923456#p1923456
- desktop backend possibly working - https://bbs.archlinux.org/viewtopic.php?pid=1923532#p1923532
- [Chromium is intermittently very choppy](https://bbs.archlinux.org/viewtopic.php?pid=1788065#p1788065)
- [VAAPI/Intel acceleration in Chromium 87 on Ubuntu 20.04 broken on initialization with `VDA Error 4` #98](https://github.com/saiarcot895/chromium-ubuntu-build/issues/98#issuecomment-711220942)
- Google: --enable-dr-dc --enable-raw-draw chrome
- https://forum.manjaro.org/t/howto-enable-hardware-video-acceleration-video-decode-in-google-chrome-brave-vivaldi-and-opera-browsers/51895/51
- https://www.chromium.org/developers/how-tos/run-chromium-with-flags/
- https://peter.sh/experiments/chromium-command-line-switches/
