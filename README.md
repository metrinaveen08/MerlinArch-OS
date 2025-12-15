# MerlinArch

MerlinArch is an Arch Linux–based operating system I am developing that combines Arch's rolling-release base with curated defaults, automated image tooling, and reproducible build scripts to make a powerful, customizable desktop system easier to install and maintain.

**Project Structure**
- **airootfs/**: Base root filesystem used for building live images and ISOs.
- **work/**: Build scripts and helper tasks used to assemble images and packages (image generation lives here).
- [packages.x86_64](packages.x86_64): Default package list for x86_64 ISOs.
- [pacman.conf](pacman.conf): ISO/pacman configuration used during builds.
- [build.sh](build.sh): Primary build entrypoint for creating images.
- [clean.sh](clean.sh), [custombuild.sh](custombuild.sh): Helpers for cleaning and custom builds.
- **efiboot/**, **grub/**, **syslinux/**: Bootloader and image assets used when creating ISOs.

**Summary**
- **Purpose:** Provide a reproducible, configurable Arch-derived desktop with sensible defaults so users can get a working system quickly while retaining full control.
- **Audience:** Enthusiasts and power users who want Arch's flexibility with curated defaults and automated image tooling.

**Key Features**
- Rolling-release Arch base with pacman compatibility.
- Scripted ISO and EFI image generation using the modular `airootfs` layout.
- Curated package lists and preconfigured desktop/user experience.
- Reproducible build scripts and a focus on clear customization points.

**Development**
- To explore or build locally, inspect the main scripts and the `work/` directory for build steps and helpers.
- Typical development workflow:
  - Edit package lists and configuration in [packages.x86_64](packages.x86_64) and [airootfs/](airootfs/).
  - Use `./build.sh` to start a build (review the script for required environment or privileges).
  - Use `./clean.sh` to remove build artifacts.
- Inspect `work/` for granular tasks (image assembly, airootfs preparation, squashfs creation, and ISO packaging).

**Contributing**
- File issues to track bugs or feature requests, and open merge requests with focused changes.
- When contributing code or scripts:
  - Keep changes small and focused.
  - Update `packages.x86_64` or `airootfs/` only when necessary and document why.
  - Test image builds locally and include reproduction steps in the PR description.
- If you add new packages, document the reason and any post-install configuration required.

**Testing & Validation**
- Builds rely on the scripts in `work/` and `build.sh`; review them before running.
- Test generated ISOs in a VM (QEMU/VirtualBox) before using on real hardware.

**License & Contact**
- For questions or collaboration, open an issue or add contact details to this file.

---
