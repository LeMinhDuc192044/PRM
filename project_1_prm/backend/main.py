from fastapi import FastAPI, UploadFile, File, Form
import shutil
import re
import os
import requests
from bs4 import BeautifulSoup

app = FastAPI()

BASE_DIR = os.path.dirname(
    os.path.abspath(__file__)
)

PROJECT_DIR = os.path.dirname(
    BASE_DIR
)

VAULT_PATH = os.path.join(
    PROJECT_DIR,
    "ObsidianVault"
)

os.makedirs(
    VAULT_PATH,
    exist_ok=True
)

GROBID_URL = "http://localhost:8070/api/processFulltextDocument"


@app.post("/extract")
async def extract(
    file: UploadFile = File(...),
    category: str = Form(...)
):

    # Save temporary PDF
    pdf_path = file.filename

    with open(pdf_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    # Send PDF to GROBID
    with open(pdf_path, "rb") as pdf_file:

        response = requests.post(
            GROBID_URL,
            files={
                "input": pdf_file
            }
        )

    # Parse XML
    soup = BeautifulSoup(
        response.text,
        "xml"
    )

    # =========================
    # TITLE
    # =========================

    title = "Unknown Title"

    title_tag = soup.find("title")

    if title_tag:
        title = title_tag.text.strip()

    # =========================
    # ABSTRACT
    # =========================

    abstract = ""

    abstract_tag = soup.find("abstract")

    if abstract_tag:
        abstract = abstract_tag.text.strip()

    # =========================
    # DOI
    # =========================

    doi = "Unknown DOI"

    doi_match = None

    # Try normal DOI extraction first
    doi_tag = soup.find(
        "idno",
        type="DOI"
    )

    if doi_tag:

        doi = doi_tag.text.strip()

    else:

        # Extract all XML text
        all_text = soup.get_text()

        # Regex DOI fallback
        doi_match = re.search(
            r'10\.\d{4,9}/[-._;()/:A-Z0-9]+',
            all_text,
            re.IGNORECASE
        )

    if doi_match:

        doi = doi_match.group(0)

    # =========================
    # AUTHORS
    # =========================

    authors = []

    for author in soup.find_all("author"):

        pers_name = author.find("persName")

        if pers_name:

            first = pers_name.find("forename")
            last = pers_name.find("surname")

            first_name = (
                first.text.strip()
                if first else ""
            )

            last_name = (
                last.text.strip()
                if last else ""
            )

            full_name = (
                first_name + " " + last_name
            ).strip()

            if full_name:
                authors.append(full_name)

    # =========================
    # SECTIONS
    # =========================

    sections = ""

    for div in soup.find_all("div"):

        head = div.find("head")

        if head:

            section_title = head.text.strip()

            paragraphs = div.find_all("p")

            section_text = ""

            for p in paragraphs:
                section_text += p.text.strip()
                section_text += "\n\n"

            sections += f"# {section_title}\n\n"
            sections += section_text
            sections += "\n"

    # =========================
    # REFERENCES
    # =========================

    references = ""

    refs = soup.find_all("biblStruct")

    for i, ref in enumerate(refs):

        ref_title = ref.find("title")

        if ref_title:

            references += (
                f"{i+1}. "
                f"{ref_title.text.strip()}\n"
            )

    # =========================
    # BUILD MARKDOWN
    # =========================

    markdown_content = f"""
# {title}

## DOI

{doi}

## Authors

{", ".join(authors)}

## Abstract

{abstract}

## Content

{sections}

## References

{references}
"""

    # =========================
    # SAVE TO OBSIDIAN
    # =========================

    category_folder = os.path.join(
        VAULT_PATH,
        category
    )

    os.makedirs(
        category_folder,
        exist_ok=True
    )

    output_file = file.filename.replace(
        ".pdf",
        ".md"
    )

    output_path = os.path.join(
        category_folder,
        output_file
    )

    with open(
        output_path,
        "w",
        encoding="utf-8"
    ) as f:

        f.write(markdown_content)

    # Remove temp PDF
    os.remove(pdf_path)

    return {
        "message": "Saved successfully",
        "category": category,
        "file": output_file,
        "title": title,
        "doi": doi,
        "authors": authors
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

                    notes.append({
                        "category": category,
                        "file": file
                    })

    return notes


@app.get("/read/{category}/{filename}")
async def read_note(
    category: str,
    filename: str
):

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