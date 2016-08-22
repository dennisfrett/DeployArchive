#!/bin/bash

error () {
  printf "\e[0;31m[✖] $1 \e[0m\n"
}

info () {
  printf "\e[0;32m[✔] $1 \e[0m\n"
}

iferrorelse () {
  rc=$?
  if [[ $rc != 0 ]]; then
    error "$1"
    exit
  else
    info "$2"
  fi
}

PROJECT_FILENAME="project.pbxproj"
XCODEPROJ_FILE=$(find . -maxdepth 1 -type d -name '*.xcodeproj' | head -n1)/$PROJECT_FILENAME

info "Found XCode project file: $XCODEPROJ_FILE"

# Check if the project file is in XML format
if grep -q -m 1 "<?xml" $XCODEPROJ_FILE; then
  # File is in XML
  error "Please save project file as JSON"
  exit
else
  # File is not in XML
  BUNDLE_LINE=$(grep -m 1 -re "PRODUCT_BUNDLE_IDENTIFIER" $XCODEPROJ_FILE)
  BUNDLE_ID_TMP=${BUNDLE_LINE#*PRODUCT_BUNDLE_IDENTIFIER = }
  # Remove ;
  BUNDLE_ID=${BUNDLE_ID_TMP%?}
fi

info "Found bundle id: $BUNDLE_ID"

ARCHIVE_PATH="$HOME/Library/Developer/Xcode/Archives/"
LATEST_DATE_PATH=$ARCHIVE_PATH$(ls -1t $ARCHIVE_PATH | head -1)
LATEST_ARCHIVE_PATH=$LATEST_DATE_PATH/$(ls -1t $LATEST_DATE_PATH | head -1)
APP_PATH=$(cd "$LATEST_ARCHIVE_PATH/Products/Applications/" && cd * && pwd)

info "Found archive: $APP_PATH"

ios-deploy --uninstall_only --bundle_id $BUNDLE_ID 1> /dev/null
iferrorelse "Could not uninstall app $BUNDLE_ID from device" "Uninstalled app $BUNDLE_ID from device"

ios-deploy --bundle "$APP_PATH" 1> /dev/null
iferrorelse "Could not deploy app $BUNDLE_ID to device" "Deployed app $BUNDLE_ID to device"
