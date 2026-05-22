from fastapi import FastAPI, UploadFile, File, Form
import fitz
import shutil
import os

app = FastAPI()

VAULT_PATH = r"C:\Users\admin\Desktop\2026\Semester_8\PRM393\Project\PRM\project_1_prm\ObsidianVault"

@app.post("/extract")
async def extract(
    file: UploadFile = File(...),
    category: str = Form(...)
):

    # Save uploaded PDF temporarily
    pdf_path = file.filename

    with open(pdf_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    # Read PDF
    doc = fitz.open(pdf_path)

    text = ""

    for page in doc:
        text += page.get_text()

    doc.close()

    # Create category folder path
    category_folder = os.path.join(VAULT_PATH, category)

    # Create folder if not exists
    os.makedirs(category_folder, exist_ok=True)

    # Generate .md filename
    output_file = file.filename.replace(".pdf", ".md")
    
    # Full save path
    output_path = os.path.join(category_folder, output_file)

    # Save .mmd file
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(text)

    # Remove temporary PDF
    os.remove(pdf_path)

    return {
        "message": "Saved successfully",
        "category": category,
        "file": output_file
    }

@app.get("/notes")
async def get_notes():

    notes = []

    categories = [
        "AI",
        "ComputerScience",
        "DataScience"
    ]

    for category in categories:

        category_path = os.path.join(
            VAULT_PATH,
            category
        )

        if os.path.exists(category_path):

            for file in os.listdir(category_path):

                if file.endswith(".md"):

                    file_path = os.path.join(
                        category_path,
                        file
                    )

                    with open(
                        file_path,
                        "r",
                        encoding="utf-8"
                    ) as f:

                        content = f.read()

                    notes.append({
                        "category": category,
                        "file": file
                    })

    return notes

@app.get("/read/{category}/{filename}")
async def read_note(category: str, filename: str):

    file_path = os.path.join(
        VAULT_PATH,
        category,
        filename
    )

    with open(
        file_path,
        "r",
        encoding="utf-8"
    ) as f:

        content = f.read()

    return {
        "file": filename,
        "category": category,
        "content": content
    }