# Contributing to OpenShift BGP Network Diagrams

This document provides guidance for developers who want to modify or extend the network diagrams.

## Prerequisites

### Install D2 (Diagram as Code)

**macOS:**
```bash
brew install d2
```

**Linux:**
```bash
curl -fsSL https://d2lang.com/install.sh | sh -s --
```

**Other platforms:**
See https://d2lang.com/tour/install

### VS Code Extension (Recommended)

Install the official D2 extension for live preview:
1. Open VS Code Extensions (Cmd+Shift+X)
2. Search for "D2"
3. Install **"D2" by Terrastruct**

## Development Setup

### 1. Enable Git Hooks

To prevent accidentally committing generated files locally:

```bash
git config core.hooksPath .githooks
```

This enables a pre-commit hook that blocks commits of generated SVG/PNG/PDF files.

### 2. Start Watch Mode

For live diagram updates while editing:

**Watch all diagrams:**
```bash
make watch-all
# or
./watch-all.sh
```

This starts local preview servers:
- Detailed diagram: http://127.0.0.1:49387
- Simple diagram: http://127.0.0.1:49388

**Watch from VS Code:**
- Open Command Palette (Cmd/Ctrl+Shift+P)
- Run: "Tasks: Run Task" → "D2: Watch All Diagrams"

## Generating Diagrams

### Using Make

```bash
# Generate SVG (default)
make svg

# Generate simple diagram
make simple

# Generate PNG
make png

# Generate PDF
make pdf

# Generate all formats
make all-formats

# Clean generated files
make clean

# Open diagram in browser (macOS)
make open
```

### Manual Generation

**Generate SVG (recommended):**
```bash
d2 openshift-bgp-network.d2 openshift-bgp-network.svg
```

**Generate PNG:**
```bash
d2 openshift-bgp-network.d2 openshift-bgp-network.png
```

**Generate PDF:**
```bash
d2 openshift-bgp-network.d2 openshift-bgp-network.pdf
```

**Different layouts:**
```bash
# ELK layout (good for hierarchical networks)
d2 --layout elk openshift-bgp-network.d2 output.svg

# TALA layout (default, good for general diagrams)
d2 --layout tala openshift-bgp-network.d2 output.svg

# Dagre layout (good for directed graphs)
d2 --layout dagre openshift-bgp-network.d2 output.svg
```

## Customization Guide

### Modify AS Numbers

Edit the AS number in switch/node definitions:

```d2
switch1: "ToR Switch\nAS 65001\n10.0.1.1\nBGP: neighbor default-originate" {
  shape: rectangle
  style.fill: "#1976d2"
  style.font-color: white
}
```

### Add More Nodes

```d2
worker4: "Worker 4\n10.0.1.24\nBGP: AS 64512\n📦 VMs: 2 | 🔷 UDN Pods: 4" {
  shape: rectangle
  style.fill: "#388e3c"
  style.font-color: white
}
```

### Add BGP Connections

```d2
switch_layer.switch1 -> worker_layer.worker4: "eBGP\n← UDN Routes\n→ neighbor default-originate" {
  style.stroke: "#4caf50"
  style.stroke-width: 3
}
```

### Change Colors

Modify `style.fill` and `style.stroke` values using hex colors:

```d2
worker1: "Worker 1" {
  style.fill: "#388e3c"      # Background color
  style.stroke: "#2e7d32"    # Border color
  style.font-color: white     # Text color
}
```

### Add Annotations

```d2
note: "Important information here" {
  near: top-right
  shape: text
  style.fill: "#fff9c4"
}
```

## Git Workflow

### Important: Generated Files

Generated files (*.svg, *.png, *.pdf) are in `.gitignore` to prevent accidental local commits. **Only GitHub Actions should commit these files.**

### Development Workflow

1. **Edit `.d2` files** locally using your preferred editor
2. **Preview changes** using watch mode or VS Code extension
3. **Commit only `.d2` files**:
   ```bash
   git add *.d2
   git commit -m "Update network diagram: add new worker nodes"
   ```
4. **Push to GitHub**:
   ```bash
   git push
   ```
5. **GitHub Actions** automatically generates and commits SVG/PNG/PDF

### If You Need Local Images

Generate them locally for testing, but don't commit:

```bash
make all-formats
# Test/review the images
make clean  # Clean up before committing
```

## GitHub Actions

The `.github/workflows/generate-diagrams.yml` workflow:
- Triggers on any `.d2` file changes pushed to main/master
- Installs D2 and generates all formats (SVG, PNG, PDF)
- Force-commits generated files using `git add -f` (overrides .gitignore)
- Adds `[skip ci]` to commit message to prevent infinite loops

## D2 Syntax Tips

### Comments
```d2
# This is a comment
node1: Node 1  # Inline comment
```

### Containers/Layers
```d2
layer_name: Layer Label {
  style.fill: "#e3f2fd"
  node1: Node 1
  node2: Node 2
}
```

### Connections
```d2
node1 -> node2: Label {
  style.stroke: "#4caf50"
  style.stroke-width: 3
  style.stroke-dash: 4  # Dashed line
}
```

### Shapes
```d2
node: {
  shape: rectangle   # rectangle, cylinder, oval, circle, etc.
}
```

### Text Formatting
```d2
node: "Line 1\nLine 2\nLine 3"  # Multi-line text
```

## Architecture Design Principles

When modifying diagrams, follow these principles:

1. **Color Coding**: Use consistent colors for similar components
   - Green (#388e3c): BGP-enabled workers
   - Red/Pink (#e57373): Non-BGP workers
   - Blue (#1976d2): Network switches
   - Purple (#7b1fa2): Control plane

2. **Visual Hierarchy**: Important components should be visually prominent

3. **Connection Types**: 
   - Solid lines: BGP peering
   - Dashed lines: Network-only connections

4. **Labels**: Include critical information (IPs, AS numbers, BGP config)

5. **Workload Indicators**: Use emojis for quick identification
   - 📦 VMs
   - 🔷 UDN Pods
   - ❌ Not available

## Questions or Issues?

- D2 Documentation: https://d2lang.com/
- File issues in this repository's issue tracker
