#!/bin/bash
set -e

SHAPES_DIR=/usr/share/dia/shapes/

DIA_SHAPES_HTML=dia-shapes.html


cat dia-shapes.start > "${DIA_SHAPES_HTML}"
  while IFS='' read -r SHAPE_FILE_PATH || [[ -n "${SHAPE_FILE_PATH}" ]]; do
    SHAPE_NAME=$(basename "${SHAPE_FILE_PATH}" | sed 's/\.shape$//')
    ICON_FILE_PATH="$(dirname "${SHAPE_FILE_PATH}")/$(grep -F '<icon>' ${SHAPE_FILE_PATH} | sed 's/.*<icon>\(.*\)<\/icon>.*/\1/')"
    DIA_SHAPE_LABEL=$(grep -F '<name>' ${SHAPE_FILE_PATH} | sed 's/.*<name>\(.*\)<\/name>.*/\1/')
    
    echo "<div><img src="${ICON_FILE_PATH}" />${DIA_SHAPE_LABEL}</div>" >> "${DIA_SHAPES_HTML}"
  done < <( find "${SHAPES_DIR}" -type f -name '*.shape' )
cat dia-shapes.end >> "${DIA_SHAPES_HTML}"