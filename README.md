**AWS WorkSpaces Creation Script**

**Overview**

This Bash script automates the creation of AWS WorkSpaces for multiple users. 
It provides an interactive macOS-native interface using AppleScript dialogs to select the AWS region, WorkSpaces bundle, and input usernames.

**Features**

- Region Selection: Choose from supported AWS regions.
- Bundle Selection: Select a WorkSpaces bundle from a predefined list per region.
- User Input: Enter multiple usernames in a single line (comma-separated).
- Encryption: Enables encryption for root and user volumes using a predefined encryption key.
- Automated WorkSpaces Creation: Uses AWS CLI to create WorkSpaces based on the user input.

**Requirements**

macOS (due to AppleScript dependency)

**Follow the interactive AppleScript prompts to:**

- Select an AWS region.
- Choose a WorkSpaces bundle.
- Enter usernames.
- Confirm WorkSpaces creation.
- Configuration


Disclaimer

**This script is provided "as-is" without any warranties. Use at your own risk.**
