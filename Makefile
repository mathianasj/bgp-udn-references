.PHONY: all svg png pdf clean watch watch-all simple

# Default target
all: svg

# Generate SVG (best for web/viewing)
svg:
	d2 --layout elk openshift-bgp-network.d2 openshift-bgp-network.svg
	@echo "✓ Generated openshift-bgp-network.svg"

# Generate simple diagram
simple:
	d2 simple-bgp-config.d2 simple-bgp-config.svg
	@echo "✓ Generated simple-bgp-config.svg"

# Generate PNG
png:
	d2 --layout elk openshift-bgp-network.d2 openshift-bgp-network.png
	@echo "✓ Generated openshift-bgp-network.png"

# Generate PDF
pdf:
	d2 --layout elk openshift-bgp-network.d2 openshift-bgp-network.pdf
	@echo "✓ Generated openshift-bgp-network.pdf"

# Generate all formats
all-formats: svg png pdf simple
	@echo "✓ Generated all diagram formats"

# Watch for changes and auto-regenerate (detailed diagram only)
watch:
	d2 -w --layout elk openshift-bgp-network.d2 openshift-bgp-network.svg

# Watch all diagrams (both detailed and simple)
watch-all:
	./watch-all.sh

# Clean generated files
clean:
	rm -f *.svg *.png *.pdf
	@echo "✓ Cleaned generated files"

# Open the SVG in default browser (macOS)
open: svg
	open openshift-bgp-network.svg

# Show help
help:
	@echo "OpenShift BGP Network Diagrams - Make Targets"
	@echo ""
	@echo "Available targets:"
	@echo "  make svg          - Generate detailed SVG diagram (default)"
	@echo "  make simple       - Generate simplified SVG diagram"
	@echo "  make png          - Generate PNG diagram"
	@echo "  make pdf          - Generate PDF diagram"
	@echo "  make all-formats  - Generate all formats"
	@echo "  make watch        - Watch detailed diagram and auto-regenerate"
	@echo "  make watch-all    - Watch all diagrams and auto-regenerate"
	@echo "  make open         - Generate and open SVG"
	@echo "  make clean        - Remove generated files"
	@echo ""
	@echo "For development setup and customization, see CONTRIBUTING.md"
