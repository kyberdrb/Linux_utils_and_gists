```
Updated: Nov 19, 2020
Chromium: 87.0.4280.66 (Official Build) (64-bit)
OS: Linux 5.3.0-64-generic (Ubuntu 19.10)
```

# Override software rendering list - `Enabled`

Overrides the built-in software rendering list and enables GPU-acceleration on unsupported system configurations. – Mac, Windows, Linux, Chrome OS, Android

[#ignore-gpu-blacklist](chrome://flags/#ignore-gpu-blacklist)


# Enable Reader Mode - `Enabled`
Allows viewing of simplified web pages by selecting 'Customize and control Chrome'>'Distill page' – Mac, Windows, Linux, Chrome OS

[#enable-reader-mode](chrome://flags/#enable-reader-mode)


# Smooth Scrolling - `Enabled`
Animate smoothly when scrolling page content. – Windows, Linux, Chrome OS, Android

[#smooth-scrolling](chrome://flags/#smooth-scrolling)


# Experimental QUIC protocol - `Enabled`
Enable experimental QUIC protocol support. – Mac, Windows, Linux, Chrome OS, Android

[#enable-quic](chrome://flags/#enable-quic)


# Experimental WebAssembly - `Enabled`
Enable web pages to use experimental WebAssembly features. – Mac, Windows, Linux, Chrome OS, Android

[#enable-experimental-webassembly-features](chrome://flags/#enable-experimental-webassembly-features)


# WebAssembly baseline compiler - `Enabled`
Enables WebAssembly baseline compilation and tier up. – Mac, Windows, Linux, Chrome OS, Android

[#enable-webassembly-baseline](chrome://flags/#enable-webassembly-baseline)


# WebAssembly lazy compilation - `Enabled`
Enables lazy (JIT on first call) compilation of WebAssembly modules. – Mac, Windows, Linux, Chrome OS, Android

[#enable-webassembly-lazy-compilation](chrome://flags/#enable-webassembly-lazy-compilation)


# WebAssembly SIMD support - `Enabled`
Enables support for the WebAssembly SIMD proposal. – Mac, Windows, Linux, Chrome OS, Android

[#enable-webassembly-simd](chrome://flags/#enable-webassembly-simd)


# WebAssembly threads support - `Enabled`
Enables support for the WebAssembly Threads proposal. Implies #shared-array-buffer and #enable-webassembly. – Mac, Windows, Linux, Chrome OS, Android

[#enable-webassembly-threads](chrome://flags/#enable-webassembly-threads)


# WebAssembly tiering - `Enabled`
Enables tiered compilation of WebAssembly (will tier up to TurboFan if #enable-webassembly-baseline is enabled). – Mac, Windows, Linux, Chrome OS, Android

[#enable-webassembly-tiering](chrome://flags/#enable-webassembly-tiering)


# GPU rasterization - `Enabled`
Use GPU to rasterize web content. Requires impl-side painting. – Mac, Windows, Linux, Chrome OS, Android

[#enable-gpu-rasterization](chrome://flags/#enable-gpu-rasterization)


# Out of process rasterization - `Enabled`
Perform Ganesh raster in the GPU Process instead of the renderer. Must also enable GPU rasterization – Mac, Windows, Linux, Chrome OS, Android

[#enable-oop-rasterization](chrome://flags/#enable-oop-rasterization)


# Out of process rasterization using DDLs - `Enabled`
Use Skia Deferred Display Lists when performing rasterization in the GPU process Must also enable OOP rasterization – Mac, Windows, Linux, Chrome OS, Android

[#enable-oop-rasterization-ddl](chrome://flags/#enable-oop-rasterization-ddl)


# WebGL 2.0 Compute - `Enabled`
Enable the use of WebGL 2.0 Compute API. – Windows, Linux, Chrome OS

[#enable-webgl2-compute-context](chrome://flags/#enable-webgl2-compute-context)


# WebGL Draft Extensions - `Enabled`
Enabling this option allows web applications to access the WebGL Extensions that are still in draft status. – Mac, Windows, Linux, Chrome OS, Android

[#enable-webgl-draft-extensions](chrome://flags/#enable-webgl-draft-extensions)


# Zero-copy rasterizer - `Enabled`
Raster threads write directly to GPU memory associated with tiles. – Mac, Windows, Linux, Chrome OS, Android

[#enable-zero-copy](chrome://flags/#enable-zero-copy)


# Force Dark Mode for Web Contents - `Enabled`
Automatically render all web contents using a dark theme. – Mac, Windows, Linux, Android

[#enable-force-dark](chrome://flags/#enable-force-dark)


# Tab Groups - `Enabled`
Allows users to organize tabs into visually distinct groups, e.g. to separate tabs associated with different tasks. – Mac, Windows, Linux, Chrome OS

[#tab-groups](chrome://flags/#tab-groups)


# Tab Groups Collapse - `Enabled`
Allows a tab group to be collapsible and expandable, if tab groups are enabled. – Mac, Windows, Linux, Chrome OS

[#tab-groups-collapse](chrome://flags/#tab-groups-collapse)


# Tab Groups Collapse Freezing - `Enabled`
Experimental tab freezing upon collapsing a tab group. – Mac, Windows, Linux, Chrome OS

[#tab-groups-collapse-freezing](chrome://flags/#tab-groups-collapse-freezing)


# Parallel downloading - `Enabled`
Enable parallel downloading to accelerate download speed. – Mac, Windows, Linux, Chrome OS, Android

[#enable-parallel-downloading](chrome://flags/#enable-parallel-downloading)


# Enable lazy image loading - `Enabled`
Defers the loading of images marked with the attribute 'loading=lazy' until the page is scrolled down near them. – Mac, Windows, Linux, Chrome OS, Android

[#enable-lazy-image-loading](chrome://flags/#enable-lazy-image-loading)


# Enable lazy frame loading - `Enabled`
Defers the loading of iframes marked with the attribute 'loading=lazy' until the page is scrolled down near them. – Mac, Windows, Linux, Chrome OS, Android

[#enable-lazy-frame-loading](chrome://flags/#enable-lazy-frame-loading)


# Skia API for compositing - `Enabled`
If enabled, the display compositor will use Skia as the graphics API instead of OpenGL ES. – Windows, Linux, Android

[#enable-skia-renderer](chrome://flags/#enable-skia-renderer)


# YUV decoding for JPEG - `Enabled`
Decode and render 4:2:0 formatted jpeg images from YUV instead of RGB.This feature requires GPU or OOP rasterization to also be enabled. – Mac, Windows, Linux, Chrome OS, Android

[#decode-jpeg-images-to-yuv](chrome://flags/#decode-jpeg-images-to-yuv)


# YUV Decoding for WebP - `Enabled`
Decode and render lossy WebP images from YUV instead of RGB. You must also have GPU rasterization or OOP rasterization. – Mac, Windows, Linux, Chrome OS, Android

[#decode-webp-images-to-yuv](chrome://flags/#decode-webp-images-to-yuv)


# Heavy Ad Intervention - `Enabled`
Unloads ads that use too many device resources. – Mac, Windows, Linux, Chrome OS, Android

[#enable-heavy-ad-intervention](chrome://flags/#enable-heavy-ad-intervention)
