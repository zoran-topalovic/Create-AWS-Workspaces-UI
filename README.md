AWS WorkSpaces Creation Script

Overview

This Bash script automates the creation of AWS WorkSpaces for multiple users. It provides an interactive macOS-native interface using AppleScript dialogs to select the AWS region, WorkSpaces bundle, and input usernames.

Features

Region Selection: Choose from supported AWS regions.

Bundle Selection: Select a WorkSpaces bundle from a predefined list per region.

User Input: Enter multiple usernames in a single line (comma-separated).

Encryption: Enables encryption for root and user volumes using a predefined encryption key.

Automated WorkSpaces Creation: Uses AWS CLI to create WorkSpaces based on the user input.

Requirements

Operating System

macOS (due to AppleScript dependency)

Dependencies

Ensure the following tools are installed and configured:

AWS CLI (configured with necessary permissions)

Bash (default in macOS)

Installation

Clone this repository:

git clone https://github.com/your-username/aws-workspaces-script.git
cd aws-workspaces-script

Ensure the script is executable:

chmod +x create_workspaces.sh

Usage

Run the script:

./create_workspaces.sh

Follow the interactive AppleScript prompts to:

Select an AWS region.

Choose a WorkSpaces bundle.

Enter usernames.

Confirm WorkSpaces creation.

Configuration

Modify the script to:

Update DIRECTORY_ID values for your AWS environment.

Adjust BUNDLE_IDS and BUNDLE_NAMES as per your organization's WorkSpaces setup.

Notes

The script is currently macOS-only due to its reliance on AppleScript for user interaction.

Ensure you have the correct AWS permissions before running the script.

WorkSpaces will be created with AUTO_STOP running mode by default.

License

This project is licensed under the MIT License - see the LICENSE file for details.

Author

topalovic@gmail.com

Disclaimer

This script is provided "as-is" without any warranties. Use at your own risk.
