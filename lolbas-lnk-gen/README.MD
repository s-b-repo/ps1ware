
# LOLBAS .lnk Generator

This is a Python-based GUI tool that generates `.lnk` (Windows shortcut) files using various https://lolbas-project.github.io/ execution methods. It allows users to specify a payload URL and customize execution behavior with stealth mode, delay, decoy commands, and task scheduling.

---

## 🖥️ Features

- Select from 20+ LOLBAS execution methods
- Obfuscates payload URL and file path using multi-layer base64
- Optional stealth mode (hidden window)
- Optional 1-hour delay before execution
- Optional Windows Task Scheduler integration
- Optional decoy commands to mask execution
- Customizable shortcut name and output location

---

## 📦 Requirements

- Windows OS
- Python 3.8+
- Required Python packages:
  - `pywin32`
  - `winshell`
  - `tkinter` (usually included with Python)

---

## 🔧 Installation

1. **Clone the repository**:

   ```
   git clone https://github.com/yourusername/lolbas-lnk-generator.git
   cd lolbas-lnk-generator
   ```

2. **Install dependencies**:

   ```
   pip install pywin32 winshell
   ```

3. **Run the application**:

   ```
   python main.py
   ```

---

## 🚀 Usage

1. Enter a valid payload URL First to show methods (e.g. `http://example.com/payload.bat`)
2. Select a LOLBAS method from the dropdown
3. Customize options:
   - Stealth mode
   - Delay
   - Task Scheduler
   - Decoy commands
4. Choose a shortcut name
5. Click **Generate .lnk Shortcut**
6. Save the shortcut to your desired location

---

## 📁 Output

The tool creates a `.lnk` file that executes your payload using the selected LOLBAS method and options. The shortcut runs via `cmd.exe` with your constructed command.

---

## ⚠️ Disclaimer

This tool is intended for **educational and research purposes only**. Use responsibly and only in environments where you have explicit permission. The author is not responsible for misuse.
