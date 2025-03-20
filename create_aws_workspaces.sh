#!/bin/bash
# This script creates AWS WorkSpaces. To add multiple users, list them in a single line, separated by commas. 
# Note: !!! This script is compatible with macOS only !!!
# Written by: topalovic@gmail.com
# Powered by: GenAI
# Date: Mar 12 2024

# Define Encryption Key (common for all regions)
ENCRYPTION_KEY="alias/aws/workspaces"

# Select AWS Region using an AppleScript dropdown
REGION=$(osascript -e 'choose from list {"ap-south-1", "eu-west-1", "us-west-2", "us-east-1"} with prompt "Select an AWS Region:"')

# Check if a region was selected
if [[ "$REGION" == "false" || -z "$REGION" ]]; then
    echo "No region selected. Exiting."
    exit 1
fi

echo "Selected AWS Region: $REGION"

# Set DIRECTORY_ID, BUNDLE_IDS, and BUNDLE_NAMES based on the selected region
case "$REGION" in
    "ap-south-1")
        DIRECTORY_ID="d-123456789"    # Replace with your actual DIRECTORY_ID for ap-south-1
        BUNDLE_IDS=("wsb-2xxx1123" "wsb-2xxx1123" "wsb-2xxx1123" "wsb-2xxx1123")  
        BUNDLE_NAMES=("Linux Standard" "Linux ENG" "Windows Standard" "Windows ENG")
        ;;
    "eu-west-1")
        DIRECTORY_ID="d-123456789"    # Replace with your actual DIRECTORY_ID for eu-west-1
        BUNDLE_IDS=("wsb-2xxx1123" "wsb-2xxx1123" "wsb-2xxx1123" "wsb-2xxx1123")
	BUNDLE_NAMES=("Linux Standard" "Linux ENG" "Windows Standard" "Windows ENG")
        ;;
    "us-west-2")
        DIRECTORY_ID="d-123456789"    # Replace with your actual DIRECTORY_ID for us-west-2
        BUNDLE_IDS=("wsb-2xxx1123" "wsb-2xxx1123t" "wsb-2xxx1123" "wwsb-2xxx1123")
	BUNDLE_NAMES=("Linux Standard" "Linux ENG" "Windows Standard" "Windows ENG")
        ;;
    "us-east-1")
        DIRECTORY_ID="d-123456789"    # Replace with your actual DIRECTORY_ID for eu-west-1
        BUNDLE_IDS=("wsb-2xxx1123" "wsb-2xxx1123")
	BUNDLE_NAMES=("Windows Standard" "Windows ENG")
        ;;
    *)
        echo "Unknown region. Exiting."
        exit 1
        ;;
esac

# Build a comma-separated list of friendly bundle names for AppleScript
BUNDLE_LIST=""
for name in "${BUNDLE_NAMES[@]}"; do
    BUNDLE_LIST+="\"$name\", "
done
BUNDLE_LIST=${BUNDLE_LIST%, }  # Remove trailing comma and space

# Prompt for bundle selection using friendly names via AppleScript dropdown
SELECTED_BUNDLE_FRIENDLY=$(osascript -e "choose from list {$BUNDLE_LIST} with prompt \"Select a bundle for region $REGION:\"")

# Check if a bundle was selected
if [[ "$SELECTED_BUNDLE_FRIENDLY" == "false" || -z "$SELECTED_BUNDLE_FRIENDLY" ]]; then
    echo "No bundle selected. Exiting."
    exit 1
fi

echo "Selected Bundle (friendly name): $SELECTED_BUNDLE_FRIENDLY"

# Determine the corresponding bundle ID from the friendly name selection
SELECTED_BUNDLE=""
for i in "${!BUNDLE_NAMES[@]}"; do
    if [[ "${BUNDLE_NAMES[$i]}" == "$SELECTED_BUNDLE_FRIENDLY" ]]; then
        SELECTED_BUNDLE="${BUNDLE_IDS[$i]}"
        break
    fi
done

if [[ -z "$SELECTED_BUNDLE" ]]; then
    echo "Error mapping friendly name to bundle ID. Exiting."
    exit 1
fi

echo "Mapped Bundle ID: $SELECTED_BUNDLE"

# Prompt for usernames (comma-separated)
USERS_INPUT=$(osascript -e 'display dialog "Enter the usernames in one line (comma-separated):" default answer ""' -e 'text returned of result')

# Check if input is empty
if [[ -z "$USERS_INPUT" ]]; then
    echo "No usernames entered. Exiting."
    exit 1
fi

# Convert input to an array (split by comma)
IFS=',' read -r -a USERS_ARRAY <<< "$USERS_INPUT"

# Trim spaces from each username
for i in "${!USERS_ARRAY[@]}"; do
    USERS_ARRAY[$i]=$(echo "${USERS_ARRAY[$i]}" | sed 's/^ *//;s/ *$//')
done

# Confirm before proceeding
CONFIRM=$(osascript -e "display dialog \"Are you sure you want to create WorkSpaces for ${#USERS_ARRAY[@]} users in region $REGION with bundle '$SELECTED_BUNDLE_FRIENDLY'?\" buttons {\"Cancel\", \"Proceed\"} default button \"Proceed\"")

if [[ "$CONFIRM" != *"Proceed"* ]]; then
    echo "Operation canceled."
    exit 1
fi

# Loop through each user and create a WorkSpace
for USER_NAME in "${USERS_ARRAY[@]}"
do
    echo "Creating WorkSpace for user: $USER_NAME in region $REGION using bundle '$SELECTED_BUNDLE_FRIENDLY' (ID: $SELECTED_BUNDLE)"

    aws workspaces create-workspaces --workspaces '[
        {
          "DirectoryId": "'"$DIRECTORY_ID"'",
          "UserName": "'"$USER_NAME"'",
          "BundleId": "'"$SELECTED_BUNDLE"'",
          "RootVolumeEncryptionEnabled": true,
          "UserVolumeEncryptionEnabled": true,
          "VolumeEncryptionKey": "'"$ENCRYPTION_KEY"'",
          "WorkspaceProperties": {
            "RunningMode": "AUTO_STOP",
            "RootVolumeSizeGib": 175,
            "UserVolumeSizeGib": 100
          }
        }
    ]' --region "$REGION"
done

echo "WorkSpaces creation process completed."

