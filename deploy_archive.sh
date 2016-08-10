#!/bin/bash
PROJECT_FILENAME="project.pbxproj"
XCODEPROJ_FILE=$(find . -maxdepth 1 -type d -name '*.xcodeproj' | head -n1)/$PROJECT_FILENAME

echo "Location of XCode project file: $XCODEPROJ_FILE"

# Check if the project file is in XML format
if grep -q -m 1 "<?xml" $XCODEPROJ_FILE; then
  # File is in XML
  echo "Please save project file as JSON"
  exit
else
  # File is not in XML
  BUNDLE_LINE=$(grep -m 1 -re "PRODUCT_BUNDLE_IDENTIFIER" $XCODEPROJ_FILE)
  BUNDLE_ID_TMP=${BUNDLE_LINE#*PRODUCT_BUNDLE_IDENTIFIER = }
  # Remove ;
  BUNDLE_ID=${BUNDLE_ID_TMP%?}
fi

echo "Found bundle id: $BUNDLE_ID"

ARCHIVE_PATH="$HOME/Library/Developer/Xcode/Archives/"
LATEST_DATE_PATH=$ARCHIVE_PATH$(ls -1t $ARCHIVE_PATH | head -1)
LATEST_ARCHIVE_PATH=$LATEST_DATE_PATH/$(ls -1t $LATEST_DATE_PATH | head -1)

echo "Archive path: $LATEST_ARCHIVE_PATH"

IPA_PATH="$HOME/Desktop/bundle"
# Remove ipa
rm $IPA_PATH.ipa

xcodebuild -exportArchive -archivePath "$LATEST_ARCHIVE_PATH" -exportPath $IPA_PATH -exportFormat ipa -exportProvisioningProfile "iOS Team Provisioning Profile: $BUNDLE_ID" 1> /dev/null
ios-deploy --bundle $IPA_PATH.ipa  1> /dev/null
