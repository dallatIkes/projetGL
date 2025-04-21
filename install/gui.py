import ttkbootstrap as ttk
from ttkbootstrap.constants import *
from tkinter import filedialog, messagebox
import webbrowser
import urllib.request
import subprocess
import threading
import os
import zipfile

from unzip import *

APK_URL = "https://github.com/dallatIkes/projetGL/releases/download/alpha/VainquishedRealm_alpha.apk"
DOC_URL = "https://github.com/dallatIkes/projetGL/blob/alpha/README.md#-use-an-already-existing-apk"
MQDH_URL = "https://developers.meta.com/horizon/documentation/unity/ts-mqdh/"
REPO_URL = "https://github.com/dallatIkes/projetGL.git"
README_URL = "https://github.com/dallatIkes/projetGL/blob/alpha/README.md"

FONT_SETTINGS = ("Helvetica", 14)
BUTTON_WIDTH = 25


class InstallerApp(ttk.Window):
    def __init__(self):
        super().__init__(themename="darkly")
        self.title("Vanquished Realm Installation Wizard")
        self.geometry("600x400")
        self.resizable(False, False)

        self.frames = {}
        for F in (StartPage, APKStep1, SourceStep):
            frame = F(self)
            self.frames[F] = frame
            frame.place(relwidth=1, relheight=1)

        self.show_frame(StartPage)

    def show_frame(self, frame_class):
        frame = self.frames[frame_class]
        frame.tkraise()


class StartPage(ttk.Frame):
    def __init__(self, master):
        super().__init__(master)
        ttk.Label(self, text="Welcome! Choose an option:", font=FONT_SETTINGS).pack(pady=30)

        ttk.Button(self, text="Download APK", width=BUTTON_WIDTH,
                   command=lambda: master.show_frame(APKStep1)).pack(pady=10)

        ttk.Button(self, text="Get Source Code", width=BUTTON_WIDTH,
                   command=lambda: master.show_frame(SourceStep)).pack(pady=10)

        ttk.Button(self, text="Quit", width=15, command=self.master.destroy).pack(pady=20)


class APKStep1(ttk.Frame):
    def __init__(self, master):
        super().__init__(master)
        ttk.Label(self, text="Do you have Meta Quest Developer Hub installed?", font=FONT_SETTINGS).pack(pady=30)

        ttk.Button(self, text="Yes, continue", width=BUTTON_WIDTH,
                   command=self.download_and_open_doc).pack(pady=10)

        ttk.Button(self, text="No, install MQDH first", width=BUTTON_WIDTH,
                   command=self.open_mqdh_then_download).pack(pady=10)

        ttk.Button(self, text="Back", width=15,
                   command=lambda: master.show_frame(StartPage)).pack(pady=10)

    def download_and_open_doc(self):
        path = filedialog.asksaveasfilename(defaultextension=".apk", filetypes=[("APK files", "*.apk")])
        if not path:
            return
        threading.Thread(target=self.download_apk, args=(path,)).start()

    def open_mqdh_then_download(self):
        webbrowser.open(MQDH_URL)
        self.download_and_open_doc()

    def download_apk(self, path):
        try:
            urllib.request.urlretrieve(APK_URL, path)
            webbrowser.open(DOC_URL)
            messagebox.showinfo("Success", f"APK downloaded to:\n{path}")
        except Exception as e:
            messagebox.showerror("Error", str(e))


class SourceStep(ttk.Frame):
    def __init__(self, master):
        super().__init__(master)
        ttk.Label(self, text="Clone the source code repository:", font=FONT_SETTINGS).pack(pady=30)

        self.output_label = ttk.Label(self, text="", font=("Courier", 10), wraplength=550, justify="left")
        self.output_label.pack(pady=10)

        ttk.Button(self, text="Clone Git Repository", width=BUTTON_WIDTH,
                   command=self.clone_repo).pack(pady=10)

        ttk.Button(self, text="Back", width=15,
                   command=lambda: master.show_frame(StartPage)).pack(pady=10)

    def clone_repo(self):
        folder = filedialog.askdirectory(title="Choose folder to clone into")
        if not folder:
            return
        threading.Thread(target=self.do_clone, args=(folder,)).start()

    def do_clone(self, folder):
        try:
            os.chdir(folder)
            process = subprocess.Popen(
                ["git", "clone", "--progress", REPO_URL],
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True
            )
            for line in process.stdout:
                self.output_label.config(text=line.strip())
                self.output_label.update_idletasks()

            process.wait()
            if process.returncode != 0:
                raise Exception("Git clone failed")

            project_path = os.path.join(folder, "projetGL")
            self.install_dependencies(project_path)

            webbrowser.open(README_URL)
            messagebox.showinfo("Success", "Repository cloned and dependencies installed.")
        except Exception as e:
            messagebox.showerror("Error", f"Clone failed: {e}")

    def install_dependencies(self, project_path):
        try:
            os.chdir(project_path)
            for item in ZIP_FILES:
                with urllib.request.urlopen(item["url"]) as r:
                    with open(item["name"], 'wb') as out_file:
                        out_file.write(r.read())
                unzip(item["name"], project_path, lambda *_: None)
        except Exception as e:
            messagebox.showerror("Error", f"Installation failed: {e}")