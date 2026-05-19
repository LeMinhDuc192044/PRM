from fastapi import FastAPI, UploadFile
import shutil
import subprocess
import os
import ollama

app = FastAPI()

@app.get("/")
def home():
    return {
        "message": "Backend is running"
    }

UPLOAD_FOLDER = "uploads"
OUTPUT_FOLDER = "output"

os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(OUTPUT_FOLDER, exist_ok=True)


@app.post("/extract")
async def extract(file: UploadFile):

    pdf_path = os.path.join(
        UPLOAD_FOLDER,
        file.filename
    )

    with open(pdf_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    subprocess.run([
        "nougat",
        pdf_path,
        "-o",
        OUTPUT_FOLDER,
        "-m",
        "0.1.0-small"
    ])

    markdown_file = os.path.join(
        OUTPUT_FOLDER,
        file.filename.replace(".pdf", ".mmd")
        
    )

    if not os.path.exists(markdown_file):
        return {
            "content": "Failed to process PDF"
        }

    content = ""

    if os.path.exists(markdown_file):
        with open(
            markdown_file,
            "r",
            encoding="utf-8"
        ) as f:
            content = f.read()

    obsidian_folder = (
        "../ObsidianVault/Papers"
    )

    os.makedirs(obsidian_folder, exist_ok=True)

    obsidian_file = os.path.join(
        obsidian_folder,
        file.filename.replace(".pdf", ".md")
    )

    with open(
        obsidian_file,
        "w",
        encoding="utf-8"
    ) as f:
        f.write(content)


        
    return {
        "content": content
    }