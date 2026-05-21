from fastapi import FastAPI, UploadFile, File
import fitz
import shutil
import os

app = FastAPI()

@app.post("/extract")
async def extract(file: UploadFile = File(...)):

    # Save uploaded PDF
    pdf_path = file.filename

    with open(pdf_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    # Open PDF
    doc = fitz.open(pdf_path)

    text = ""

    # Extract text
    for page in doc:
        text += page.get_text()

    # Clean unwanted characters
    text = text.replace("(cid:13)", "")
    text = text.replace("(cid:80)", "")

    # Create .mmd filename
    output_file = pdf_path.replace(".pdf", ".mmd")

    # Save .mmd file
    with open(output_file, "w", encoding="utf-8") as f:
        f.write(text)

    # Close PDF
    doc.close()

    # Delete uploaded PDF
    os.remove(pdf_path)

    return {
        "message": ".mmd created successfully",
        "file": output_file
    }