#!/bin/bash
# Watch both D2 files and auto-regenerate SVGs

echo "👀 Watching D2 files for changes..."
echo "Press Ctrl+C to stop"
echo ""

# Watch detailed diagram
d2 -w --layout elk openshift-bgp-network.d2 openshift-bgp-network.svg &
PID1=$!

# Watch simple diagram
d2 -w simple-bgp-config.d2 simple-bgp-config.svg &
PID2=$!

# Trap Ctrl+C to kill both processes
trap "kill $PID1 $PID2; exit" INT

# Wait for both processes
wait
