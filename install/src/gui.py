import ttkbootstrap as ttk
from ttkbootstrap.constants import *
from tkinter import filedialog, messagebox
from PIL import Image, ImageTk, ImageDraw
import webbrowser
import subprocess
import threading
import os
from pathlib import Path
import sys
from unzip import *

APK_URL = "https://github.com/dallatIkes/projetGL/releases/latest/download/VainquishedRealm.apk"
DOC_URL = "https://github.com/dallatIkes/projetGL/blob/release/README.md#-use-an-already-existing-apk"
MQDH_URL = "https://developers.meta.com/horizon/documentation/unity/ts-mqdh/"
REPO_URL = "https://github.com/dallatIkes/projetGL.git"
README_URL = "https://github.com/dallatIkes/projetGL/blob/release/README.md"
FONT_SETTINGS = ("Helvetica", 16)
BUTTON_WIDTH = 25

BASE_PATH = Path(__file__).parent
INSTALL_PATH = BASE_PATH.parent

def resource_path(relative_path):
    """Permet d'accéder aux fichiers inclus même dans l'exécutable PyInstaller."""
    if hasattr(sys, '_MEIPASS'):
        return os.path.join(sys._MEIPASS, relative_path)
    return os.path.join(os.path.abspath("."), relative_path)

class ArchiveCleaner:
    def __init__(self, files):
        self.files = files

    def delete_archives(self):
        for file in self.files:
            try:
                os.remove(file)
                print(f"Deleted: {file}")
            except Exception as e:
                print(f"Failed to delete {file}: {e}")

def add_rounded_corners(image_path, size, radius=30, bg_color=(255, 255, 255)):
    image = Image.open(image_path).convert("RGBA").resize(size)
    corner_mask = Image.new("L", size, 0)
    draw = ImageDraw.Draw(corner_mask)
    draw.rounded_rectangle([0, 0, size[0], size[1]], radius=radius, fill=255)
    white_bg = Image.new("RGBA", size, bg_color + (0,))
    white_bg.paste(Image.new("RGBA", size, bg_color + (255,)), mask=corner_mask)
    return Image.alpha_composite(white_bg, image)

class InstallerApp(ttk.Window):
    def __init__(self):
        super().__init__(themename="darkly")
        self.title("Vanquished Realm Installation Wizard")
        self.geometry("650x850")

        self.resizable(False, False)
        self.frames = {}
        for F in (StartPage, APKStep1, SourceStep, GitOutputPage, DownloadPage, UnzipPage, APKDownloadProgress):
            frame = F(self)
            self.frames[F] = frame
            frame.place(relwidth=1, relheight=1)
        self.show_frame(StartPage)

    def show_frame(self, frame_class):
        self.frames[frame_class].tkraise()

class StartPage(ttk.Frame):
    def __init__(self, master):
        super().__init__(master)
        ttk.Label(self, text="Welcome to our game's installation wizard!", font=FONT_SETTINGS).pack(pady=30)
        image = Image.open(resource_path('assets/wizard.png')).resize((420, 450))
        self.image = ImageTk.PhotoImage(image)
        ttk.Label(self, image=self.image).pack()
        ttk.Label(self, text="Please choose an option:", font=FONT_SETTINGS).pack(pady=30)
        ttk.Button(self, text="Download APK", width=BUTTON_WIDTH, command=lambda: master.show_frame(APKStep1)).pack(pady=10)
        ttk.Button(self, text="Get Source Code", width=BUTTON_WIDTH, command=lambda: master.show_frame(SourceStep)).pack(pady=10)
        ttk.Button(self, text="Quit", width=15, command=self.master.destroy).pack(pady=20)

class APKStep1(ttk.Frame):
    def __init__(self, master):
        super().__init__(master)
        ttk.Label(self, text="Do you have Meta Quest Developer Hub installed?", font=FONT_SETTINGS).pack(pady=30)
        rounded_image = add_rounded_corners(resource_path("assets/meta.png"), size=(500, 370))
        self.rounded_photo = ImageTk.PhotoImage(rounded_image)
        ttk.Label(self, image=self.rounded_photo).pack(pady=80)
        ttk.Button(self, text="Yes, continue", width=BUTTON_WIDTH, command=self.download_and_open_doc).pack(pady=10)
        ttk.Button(self, text="No, install MQDH first", width=BUTTON_WIDTH, command=self.open_mqdh_then_download).pack(pady=10)
        ttk.Button(self, text="Back", width=15, command=lambda: master.show_frame(StartPage)).pack(pady=10)

    def download_and_open_doc(self):
        path = filedialog.asksaveasfilename(defaultextension=".apk", filetypes=[("APK files", "*.apk")])
        if path:
            threading.Thread(target=self.download_apk, args=(path,)).start()

    def open_mqdh_then_download(self):
        webbrowser.open(MQDH_URL)
        self.download_and_open_doc()

    def download_apk(self, path):
        progress_frame = self.master.frames[APKDownloadProgress]
        self.master.show_frame(APKDownloadProgress)
        def report_hook(block_num, block_size, total_size):
            downloaded = block_num * block_size
            percent = min(100, downloaded * 100 / total_size)
            downloaded_mb = downloaded / (1024 * 1024)
            total_mb = total_size / (1024 * 1024)
            progress_frame.update_progress(percent, downloaded_mb, total_mb, total_size)
        try:
            urllib.request.urlretrieve(APK_URL, path, reporthook=report_hook)
            messagebox.showinfo("Success", f"APK downloaded to:\n{path}")
        except Exception as e:
            messagebox.showerror("Error", str(e))
        finally:
            self.master.show_frame(StartPage)
            webbrowser.open(DOC_URL)

class APKDownloadProgress(ttk.Frame):
    def __init__(self, master):
        super().__init__(master)
        image = Image.open(resource_path('assets/download.png')).resize((420, 450))
        self.image = ImageTk.PhotoImage(image)
        ttk.Label(self, image=self.image).pack(pady=60)
        ttk.Label(self, text="Downloading APK...", font=FONT_SETTINGS).pack(pady=20)
        self.progress = ttk.Progressbar(self, mode="determinate", length=400)
        self.progress.pack(pady=20)
        self.status_label = ttk.Label(self, text="", font=("Helvetica", 12))
        self.status_label.pack()

    def update_progress(self, percent, downloaded_mb, total_mb, total_bytes):
        self.progress["value"] = percent
        self.status_label.config(text=f"{downloaded_mb:.1f} MB / {total_mb:.1f} MB ({percent:.1f}%)")
        self.update_idletasks()

class SourceStep(ttk.Frame):
    def __init__(self, master):
        super().__init__(master)
        ttk.Label(self, text="Clone the source code repository:", font=FONT_SETTINGS).pack(pady=30)
        rounded_image = add_rounded_corners(resource_path("assets/github.png"), size=(500, 500))
        self.rounded_photo = ImageTk.PhotoImage(rounded_image)
        ttk.Label(self, image=self.rounded_photo).pack(pady=50)
        ttk.Button(self, text="Clone Git Repository", width=BUTTON_WIDTH, command=self.clone_repo).pack(pady=10)
        ttk.Button(self, text="Back", width=15, command=lambda: master.show_frame(StartPage)).pack(pady=10)

    def clone_repo(self):
        folder = filedialog.askdirectory(title="Choose folder to clone into")
        if folder:
            self.master.show_frame(GitOutputPage)
            threading.Thread(target=self.do_clone, args=(folder,)).start()

    def do_clone(self, folder):
        try:
            os.chdir(folder)
            process = subprocess.Popen(["git", "clone", "--progress", REPO_URL, "--depth", "5"], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
            git_page = self.master.frames[GitOutputPage]
            output = ""
            for line in process.stdout:
                output += line
                git_page.update_output(output)
            process.wait()
            if process.returncode != 0:
                raise Exception("Git clone failed")
            project_path = os.path.join(folder, "projetGL")
            self.master.show_frame(DownloadPage)
            threading.Thread(target=self.download_zips, args=(project_path,)).start()
        except Exception as e:
            messagebox.showerror("Error", f"Clone failed: {e}")

    def download_zips(self, project_path):
        page = self.master.frames[DownloadPage]
        page.progress_label = ttk.Label(page, text="", font=("Helvetica", 12))
        page.progress_label.pack()
        try:
            os.chdir(project_path)
            for idx, item in enumerate(ZIP_FILES):
                with urllib.request.urlopen(item["url"]) as r:
                    total_size = int(r.headers.get("Content-Length", 0))
                    downloaded = 0
                    chunk_size = 8192
                    with open(item["name"], 'wb') as out_file:
                        while True:
                            chunk = r.read(chunk_size)
                            if not chunk:
                                break
                            out_file.write(chunk)
                            downloaded += len(chunk)
                            percent = (idx + downloaded / total_size) / len(ZIP_FILES) * 100
                            page.update_progress(percent)
                            page.progress_label.config(text=f"{downloaded / (1024*1024):.2f} MB / {total_size / (1024*1024):.2f} MB ({downloaded/total_size*100:.1f}%)")
            self.master.show_frame(UnzipPage)
            threading.Thread(target=self.unzip_zips, args=(project_path,)).start()
        except Exception as e:
            messagebox.showerror("Error", f"Download failed: {e}")

    def unzip_zips(self, project_path):
        page = self.master.frames[UnzipPage]
        archive_paths = [os.path.join(project_path, item["name"]) for item in ZIP_FILES]
        try:
            for idx, item in enumerate(ZIP_FILES):
                unzip(item["name"], project_path, lambda *_: None)
                page.update_progress((idx + 1) / len(ZIP_FILES) * 100)
            ArchiveCleaner(archive_paths).delete_archives()
            
            messagebox.showinfo("Success", "Repository cloned and dependencies installed.")
        except Exception as e:
            messagebox.showerror("Error", f"Unzip failed: {e}")
        finally:
            self.master.show_frame(StartPage)
            webbrowser.open(README_URL)

class GitOutputPage(ttk.Frame):
    def __init__(self, master):
        super().__init__(master)
        ttk.Label(self, text="Cloning Repository (Console Output):", font=FONT_SETTINGS).pack(pady=10)
        self.output_text = ttk.Text(self, wrap="word", font=("Courier", 10))
        self.output_text.pack(fill=BOTH, expand=True, padx=10, pady=10)

    def update_output(self, text):
        self.output_text.delete("1.0", "end")
        self.output_text.insert("1.0", text)
        self.output_text.see("end")
        self.update_idletasks()

class DownloadPage(ttk.Frame):
    def __init__(self, master):
        super().__init__(master)
        image = Image.open(resource_path('assets/download.png')).resize((420, 450))
        self.image = ImageTk.PhotoImage(image)
        ttk.Label(self, image=self.image).pack(pady=60)
        ttk.Label(self, text="Downloading Required Files...", font=FONT_SETTINGS).pack(pady=20)
        self.progress = ttk.Progressbar(self, length=500, mode='determinate')
        self.progress.pack(pady=20)

    def update_progress(self, value):
        self.progress['value'] = value
        self.update_idletasks()

class UnzipPage(ttk.Frame):
    def __init__(self, master):
        super().__init__(master)
        image = Image.open(resource_path('assets/unzip.png')).resize((420, 450))
        self.image = ImageTk.PhotoImage(image)
        ttk.Label(self, image=self.image).pack(pady=60)
        ttk.Label(self, text="Unzipping Files...", font=FONT_SETTINGS).pack(pady=20)
        self.progress = ttk.Progressbar(self, length=500, mode='determinate')
        self.progress.pack(pady=20)

    def update_progress(self, value):
        self.progress['value'] = value
        self.update_idletasks()
