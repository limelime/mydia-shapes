#!/bin/bash
set -e

SHAPES_DIR=/usr/share/dia/shapes/

DIA_SHAPES_HTML=dia-shapes.html

ICON_DIR=icon
mkdir -p "${ICON_DIR}"

cat dia-shapes.start > "${DIA_SHAPES_HTML}"
  while IFS='' read -r SHAPE_FILE_PATH || [[ -n "${SHAPE_FILE_PATH}" ]]; do
    SHAPE_NAME=$(basename "${SHAPE_FILE_PATH}" | sed 's/\.shape$//')
    ICON_FILE_PATH="$(dirname "${SHAPE_FILE_PATH}")/$(grep -F '<icon>' ${SHAPE_FILE_PATH} | sed 's/.*<icon>\(.*\)<\/icon>.*/\1/' | xargs)"
    
    yes | cp -a "${ICON_FILE_PATH}" "${ICON_DIR}"
    DIA_SHAPE_LABEL=$(grep -F '<name>' ${SHAPE_FILE_PATH} | sed 's/.*<name>\(.*\)<\/name>.*/\1/')
    
    ICON_HTML_PATH="${ICON_DIR}/$(basename ${ICON_FILE_PATH})"
    echo "<div><img src="${ICON_HTML_PATH}" />${DIA_SHAPE_LABEL}</div>" >> "${DIA_SHAPES_HTML}"
  done < <( find "${SHAPES_DIR}" -type f -name '*.shape' )
cat dia-shapes.end >> "${DIA_SHAPES_HTML}"