import ttkbootstrap as ttk
from ttkbootstrap.constants import *
from tkinter import filedialog, messagebox, scrolledtext
import webbrowser
import urllib.request
import subprocess
import threading
import os

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


class LoadingPage(ttk.Frame):
    def __init__(self, master, title, message):
        super().__init__(master)
        ttk.Label(self, text=message, font=FONT_SETTINGS).pack(pady=10)
        self.progress = ttk.Progressbar(self, mode="determinate", length=300)
        self.progress.pack(pady=10)
        self.label = ttk.Label(self, text="0%", font=FONT_SETTINGS)
        self.label.pack(pady=10)

    def update_progress(self, percent):
        self.progress['value'] = percent
        self.label.config(text=f"{percent}%")


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
        self.show_loading_page("Downloading APK", "Downloading APK, please wait...", path)

    def open_mqdh_then_download(self):
        webbrowser.open(MQDH_URL)
        self.download_and_open_doc()

    def show_loading_page(self, title, message, path):
        page = LoadingPage(self.master, title, message)
        self.master.frames[LoadingPage] = page
        page.place(relwidth=1, relheight=1)
        self.master.show_frame(LoadingPage)
        threading.Thread(target=self.download_apk, args=(path, page)).start()

    def download_apk(self, path, loading_page):
        try:
            def reporthook(block_num, block_size, total_size):
                read_so_far = block_num * block_size
                if total_size > 0:
                    percent = int(read_so_far * 100 / total_size)
                    loading_page.update_progress(percent)

            urllib.request.urlretrieve(APK_URL, path, reporthook)
            webbrowser.open(DOC_URL)
            messagebox.showinfo("Success", f"APK downloaded to:\n{path}")
        except Exception as e:
            messagebox.showerror("Error", str(e))
        finally:
            self.master.show_frame(StartPage)


class SourceStep(ttk.Frame):
    def __init__(self, master):
        super().__init__(master)
        ttk.Label(self, text="Clone the source code repository:", font=FONT_SETTINGS).pack(pady=30)

        ttk.Button(self, text="Clone Git Repository", width=BUTTON_WIDTH,
                   command=self.clone_repo).pack(pady=10)

        ttk.Button(self, text="Back", width=15,
                   command=lambda: master.show_frame(StartPage)).pack(pady=10)

    def clone_repo(self):
        folder = filedialog.askdirectory(title="Choose folder to clone into")
        if not folder:
            return
        self.show_loading_page("Cloning Repository", "Cloning repository, please wait...", folder)

    def show_loading_page(self, title, message, folder):
        page = LoadingPage(self.master, title, message)
        self.master.frames[LoadingPage] = page
        page.place(relwidth=1, relheight=1)
        self.master.show_frame(LoadingPage)
        threading.Thread(target=self.task_clone, args=(folder,)).start()

    def task_clone(self, folder):
        try:
            # Crée et affiche l'écran de chargement
            loading_page = LoadingPage(self.master, "Installing Dependencies", "Installing dependencies, please wait...")
            self.master.frames[LoadingPage] = loading_page
            loading_page.place(relwidth=1, relheight=1)
            self.master.show_frame(LoadingPage)

            # Clone
            os.chdir(folder)
            subprocess.run(["git", "clone", REPO_URL], check=True)
            project_path = os.path.join(folder, "projetGL")
            os.chdir(project_path)

            total_files = 0
            file_counts = []

            # Compter les fichiers pour toutes les archives
            for item in ZIP_FILES:
                with urllib.request.urlopen(item["url"]) as r:
                    with open(item["name"], 'wb') as out_file:
                        out_file.write(r.read())

                with zipfile.ZipFile(item["name"], 'r') as zip_ref:
                    count = len(zip_ref.infolist())
                    file_counts.append(count)
                    total_files += count

            current_file = 0

            # Fonction de progression cumulée
            def combined_progress(done, total, current_filename):
                nonlocal current_file, total_files
                current_file += 1
                percent = int((current_file / total_files) * 100)
                loading_page.update_progress(percent)

            # Extraction
            for item in ZIP_FILES:
                unzip(item["name"], project_path, combined_progress)

            webbrowser.open(README_URL)
            messagebox.showinfo("Success", "Repository cloned and dependencies installed.")
        except Exception as e:
            messagebox.showerror("Error", f"Error: {e}")
        finally:
            self.master.show_frame(StartPage)

