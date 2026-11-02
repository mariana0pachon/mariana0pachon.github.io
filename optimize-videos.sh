#!/bin/bash
# Re-encodes every video asset for web delivery: caps resolution at 1600px
# on the long edge, drops bitrate via CRF, strips audio (all videos are
# muted in the page anyway), and adds faststart for instant playback.
# Each file is re-encoded to a temp file, then swapped in at the SAME path
# (same name, same case) so no HTML changes are needed afterward.
#
# Review the before/after sizes it prints, then spot-check a few videos
# in the browser before committing.

set -e

FILES=(
  "assets/bg/video.mp4"
  "assets/experiments/burbufonos/02.MOV"
  "assets/experiments/burbufonos/03.MOV"
  "assets/experiments/burbufonos/05.mov"
  "assets/experiments/burbufonos/07.MP4"
  "assets/experiments/burbufonos/08.MOV"
  "assets/experiments/burbufonos/09.MOV"
  "assets/experiments/burbufonos/10.MOV"
  "assets/experiments/circuit_bending/01.mov"
  "assets/experiments/circuit_bending/02.mov"
  "assets/experiments/circuit_bending/03.mov"
  "assets/experiments/circuit_bending/04.mov"
  "assets/experiments/memorias/01.MOV"
  "assets/experiments/noise_boxes/01.MOV"
  "assets/experiments/noise_boxes/02.MOV"
  "assets/experiments/shrinking_theatre/01.mov"
  "assets/experiments/shrinking_theatre/02.MOV"
  "assets/experiments/shrinking_theatre/03.MOV"
  "assets/experiments/shrinking_theatre/04.mov"
  "assets/experiments/shrinking_theatre/05.MOV"
  "assets/installations/flora/1.mov"
  "assets/installations/flora/8.MP4"
  "assets/playground/caleidoscopio/cover/01.mp4"
  "assets/playground/corrientes/cover/01.mp4"
  "assets/playground/invitacion28/cover/01.mp4"
)

for f in "${FILES[@]}"; do
  if [ ! -f "$f" ]; then
    echo "SKIP (not found): $f"
    continue
  fi
  before=$(stat -f "%z" "$f")
  tmp="${f}.optimized.mp4"

  ffmpeg -y -i "$f" \
    -vf "scale='if(gt(iw,ih),min(1600,iw),-2)':'if(gt(iw,ih),-2,min(1600,ih))'" \
    -c:v libx264 -crf 26 -preset slow -pix_fmt yuv420p \
    -an -movflags +faststart \
    "$tmp" -loglevel error

  after=$(stat -f "%z" "$tmp")
  mv "$tmp" "$f"

  before_mb=$(echo "scale=1; $before/1024/1024" | bc)
  after_mb=$(echo "scale=1; $after/1024/1024" | bc)
  echo "$f: ${before_mb}MB -> ${after_mb}MB"
done

echo "Done."
