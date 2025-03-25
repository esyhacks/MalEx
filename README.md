# MalEx - Malware Execution Automation Script

## Overview
**MalEx** is a **malware execution automation script** designed for cybersecurity research. It tests the effectiveness of **antivirus software** by executing malware samples and logging their detection status. Additionally, it includes an **anti-phishing test** to evaluate browser security against malicious URLs. Note that this script itself not malicious. However, you can use this script to execute any file on Windows platform and it basically checks whether the execution was successful or not and continues until the end.

This tool is designed for controlled environments such as **virtual machines** and **sandboxed environments** for cybersecurity research.

## Features
- **Administrator Privileges Request:** Ensures execution with elevated permissions.
- **Anti-Phishing Test:** Downloads and checks phishing URLs.
- **Logging System:** Records execution events and results.
- **Process Management:** Allows termination of malware processes (May not be effective at most cases). 
- **Automation of Execution:** Categorizes and executes malware samples automatically (You need to rename them according to the syntax. The script itself have no logic to determine anything about any executable). 

## Installation
1. Place MalEx in the parent directory of your malware samples.
2. Run `MalEx.bat` with administrative privileges.

## Usage
1. Select test type: `A` for malware execution, `B` for anti-phishing test.
2. Choose the malware category (Ransomware, Trojan, Virus, Worm, or All).
3. Confirm execution.
4. Review the log for results.

- More help is avaliable by pressing `?`

## Logs
- Execution details stored in `%temp%\MalEx\events.log`.
- Phishing URLs stored in `%temp%\MalEx\urls.txt` (Phishing URLs resource: [OpenPhish](https://openphish.com)).

## Warning
- This script executes potentially harmful files. Use in a controlled environment - a VM.
- Ensure proper authorization before running.

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.
