#!/usr/bin/env bash

BOOKNOTES_DIR="${HOME}/Dropbox/BookNotes"

function ocr() {
  local img="${1}"
  local out="${img}.txt"
  local workdir=$(dirname "${img}")
  local ocr_bin="/usr/local/bin/tesseract"
  (cd ${workdir};
    [[ ! -f "${out}" ]] && ${ocr_bin} "${img}" "${img}")
}

export -f ocr

find "${BOOKNOTES_DIR}"  \
  -type f \
  \( -iname '*.png' -o \
  -iname '*.jpg' -o \
  -iname '*.jpeg' \) \
  -exec bash -c "ocr '{}' " \;
