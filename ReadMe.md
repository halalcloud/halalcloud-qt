# halalcloud-qt

Customized version of Qt 6.x source code used in the multi-platform client of
Halal Cloud.

## Features

- Based on Qt 6.8.3 with only provide qtbase, qtsvg, qttools and qttranslations
  for smaller binary size. Also, qttools is standalone part because not all
  targets need that.
- Use Secure Channel (Schannel) and Windows GDI only for smaller size.
- Use [Mile.Windows.UniCrt](https://github.com/ProjectMile/Mile.Windows.UniCrt)
  toolchain to make the binary size smaller.
- Use [qtbase patch 695987](https://codereview.qt-project.org/c/qt/qtbase/+/695987)
  for solving build issues with DirectWrite disabled.
- Use [qtbase patch 699009](https://codereview.qt-project.org/c/qt/qtbase/+/699009)
  for solving build issues with Visual Studio 2026 C++ projects.

## Usage

Run onekey-build-*.bat which you want.

> [!IMPORTANT]  
> You need ARM64 Windows if you want to build ARM64 targets.

## System Requirements

- Supported OS: Windows 10 (Build 19041) or later
- Supported Platforms: x86, x86-64(AMD64) and ARM64.

## Documents

- [License](License.md)

## Acknowledgment

Thanks to Yuhang Zhao (https://github.com/wangwenx190) for guiding me how to
submit patches to Qt community, and how to use customized VCRT in Qt build
configurations.
