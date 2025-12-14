#!/usr/bin/env bash
set -euo pipefail

SWAPFILE=${1:-/swapfile}
SIZE=${2:-8G}

if [ ! -f "$SWAPFILE" ]; then
  sudo fallocate -l "$SIZE" "$SWAPFILE"
  sudo chmod 600 "$SWAPFILE"
  sudo mkswap "$SWAPFILE"
fi

sudo swapon "$SWAPFILE"
echo "Swap enabled: $SWAPFILE ($SIZE)"
echo "To disable/remove: sudo swapoff $SWAPFILE && sudo rm -f $SWAPFILE"
