# MSX Cartridge - Simple CPLD-Based MegaROM Mapper

A minimalist MSX cartridge design based on the Xilinx XC9536XL CPLD, implementing a standard MegaROM mapper for bank-switched ROM cartridges.

[![Build CPLD Firmware](https://github.com/terriblefire/msxcart/workflows/Build%20CPLD%20Firmware/badge.svg)](https://github.com/USER/msxcart/actions)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

---

## Discord

https://discord.gg/aXGkKWJQ

## ⚠️ Project Status - SUPERSEDED

**This project has been superseded by the RISKYMSX project** ([arkadiuszmakarenko/RISKYMSX](https://github.com/arkadiuszmakarenko/RISKYMSX)).

### 🎯 **We recommend building RISKYMSX instead**

RISKYMSX is a modern, feature-rich MSX cartridge solution that offers significant advantages over this simple CPLD design:

### Why Choose RISKYMSX

| Feature | RISKYMSX (Recommended) | MSX Cartridge (This Project) |
|---------|------------------------|------------------------------|
| **ROM Loading** | USB pen drive, hot-swappable | Requires ROM programmer |
| **ROM Capacity** | Up to 256KB | Up to 256KB |
| **SCC Support** | Software SCC emulation | None |
| **Convenience** | Change ROMs instantly via USB | Must reprogram ROM chip |
| **Modern MCU** | RISC-V CH32V303 | Legacy CPLD |
| **Firmware Updates** | USB or WCH-LinkE | JTAG programmer |
| **Mapper Support** | Konami, ASCII 8K/16K, Neo, SCC | Basic MegaROM only |
| **User Experience** | Plug and play with USB drive | Requires hardware tools |

**👉 For new builds, please use [RISKYMSX](https://github.com/arkadiuszmakarenko/RISKYMSX)** - it provides better functionality, easier ROM management, and a superior user experience.

### About This Archive

This repository remains available for:
- Historical reference
- Educational purposes (learning CPLD design)
- Users who already built this hardware
- Those who need the absolute simplest possible design

However, for any new MSX cartridge project, RISKYMSX is the superior choice.

---

## Features

- **Xilinx XC9536XL CPLD** - Small, reliable, low-cost programmable logic
- **Standard MegaROM Mapper** - 4 switchable ROM pages (8KB each)
- **MSX Compatible** - Works with all MSX computers
- **Simple Design** - Minimal component count, easy to build
- **Open Source** - GPL v3 licensed hardware and HDL
- **Automated Build System** - Docker-based builds for firmware and PCB manufacturing files

## Hardware Specifications

- **Target Device**: Xilinx XC9536XL-10-VQ44 CPLD
- **Interface**: MSX cartridge slot (Z80 bus compatible)
- **Memory Mapping**: 4 page registers for bank switching
- **ROM Size**: Supports up to 512KB (limited by CPLD I/O)
- **Power**: 5V from MSX cartridge slot

## Memory Map

The mapper implements standard MSX MegaROM banking:

| Address Range | Page | Function |
|---------------|------|----------|
| `0x4000-0x5FFF` | 0 | Fixed to bank 0 |
| `0x6000-0x7FFF` | 1 | Switchable (register 1) |
| `0x8000-0x9FFF` | 2 | Switchable (register 2) |
| `0xA000-0xBFFF` | 3 | Switchable (register 3) |

Bank switching is performed by writing to specific memory addresses during M1 cycle.

## Building

### Prerequisites

- Docker (for building firmware and PCB files)
- Git (for version control)
- Make (for build automation)

### Build Firmware

```bash
# Build CPLD firmware
make -C boards

# Output: boards/msxcart_YYYY_MM_DD_GITHASH.zip
```

### Generate PCB Manufacturing Files

```bash
# Generate Gerber files
make -C eagle gerbers

# Generate BOM and CPL for assembly
make -C eagle assembly

# Generate PDF schematic
make -C eagle pdf
```

## Manufacturing

### PCB Fabrication

1. Use the Gerber ZIP from `eagle/tfcart_*.zip` to order PCBs from your preferred manufacturer (JLCPCB, PCBWay, etc.)
2. The design is a 4-layer board optimized for standard PCB processes

### PCB Assembly

1. Use `eagle/tfcart_bom.csv` (Bill of Materials) for component ordering
2. Use `eagle/tfcart_cpl.csv` (Component Placement List) if using assembly services
3. Alternatively, hand-solder components - the board is designed for easy assembly

### Programming the CPLD

1. Connect a JTAG programmer to the CPLD
2. Flash the `.jed` file from `boards/msxcartr1/msxcartr1_top.jed`
3. Use Xilinx iMPACT or xc3sprog for programming

### Programming the ROM

1. Program your ROM chip with the desired MSX ROM image
2. Install the ROM chip in the socket
3. Insert into MSX cartridge slot

## Project Structure

```
msxcart/
├── rtl/                    # Verilog HDL source files
│   ├── msxcart_top.v      # Top-level module
│   └── mapper.v           # Memory mapper logic
├── boards/                 # CPLD build configuration
│   ├── msxcartr1/         # Revision 1 board files
│   │   ├── Makefile       # Board-specific build
│   │   └── msxcartr1.ucf  # Pin constraints
│   ├── Makefile           # Top-level build
│   ├── Makefile.inc       # Docker environment
│   └── Makefile.cpld      # Xilinx ISE flow
├── eagle/                  # PCB design files
│   ├── tfcart.brd         # Eagle board file
│   ├── tfcart.sch         # Eagle schematic
│   ├── Makefile           # PCB build automation
│   ├── extract_bom.py     # BOM extraction script
│   └── extract_cpl.py     # CPL extraction script
└── .github/workflows/      # CI/CD automation
    ├── actions.yml         # Firmware build
    ├── gerbers.yml         # Gerber generation
    ├── generate_assembly.yml # BOM/CPL generation
    ├── schematic-pdf.yml   # PDF schematic
    └── release.yml         # Release packaging
```

## Development

### Build System

The project uses Docker containers for reproducible builds:

- `terriblefire78/xilinx:v1` - Xilinx ISE 10.1 for CPLD synthesis
- `terriblefire78/eagle:v1` - Eagle CAM for Gerber generation
- `terriblefire78/eagle-pdf` - PDF schematic generation

### Modifying the Design

1. Edit Verilog files in `rtl/`
2. Adjust pin assignments in `boards/msxcartr1/msxcartr1.ucf`
3. Build and test: `make -C boards`
4. The build system automatically handles Docker environment

### Testing

Flash the generated `.jed` file to your CPLD and test with an MSX computer. The mapper should properly switch ROM banks when games access the appropriate memory addresses.

## GitHub Actions

The repository includes automated workflows:

- **Firmware Build** - Builds CPLD firmware on code changes
- **Gerber Generation** - Creates PCB manufacturing files
- **Assembly Files** - Generates BOM and CPL
- **Schematic PDF** - Produces documentation
- **Release Packaging** - Creates complete release bundles

Releases are automatically created when you push a git tag:

```bash
git tag -a v1.0 -m "Release version 1.0"
git push origin v1.0
```

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

Copyright (C) 2021-2025 Stephen J. Leary

## Acknowledgments

- Original design concept by Stephen J. Leary
- Build system based on [tf536_public](https://github.com/terriblefire/tf536_public)
- Inspired by the MSX community's dedication to preserving retro computing

## Related Projects

- **[RISKYMSX](https://github.com/arkadiuszmakarenko/RISKYMSX)** - Feature-rich USB-programmable MSX cartridge with SCC emulation

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## Support

For questions, issues, or discussions:

1. Open an issue on GitHub
2. Check existing issues for solutions
3. Review the MSX community forums for related discussions

---

**Note**: This is a hardware project. Users must have appropriate skills for PCB assembly and CPLD programming. This design is provided as-is for educational and hobbyist purposes.


