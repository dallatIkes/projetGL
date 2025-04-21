import urllib.request
import zipfile

# URLs des fichiers .zip hébergés dans une release GitHub
ZIP_FILES = [
    {
        "url": "https://github.com/dallatIkes/projetGL/releases/download/alpha/3D_Models.zip",
        "name": "3D_Models.zip"
    },
    {
        "url": "https://github.com/dallatIkes/projetGL/releases/download/alpha/addons.zip",
        "name": "addons.zip"
    }
]

def unzip(zip_path, extract_to, progress_callback=None):
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        total = len(zip_ref.infolist())
        for idx, file in enumerate(zip_ref.infolist(), 1):
            zip_ref.extract(file, extract_to)
            if progress_callback:
                progress_callback(idx, total, file.filename)

