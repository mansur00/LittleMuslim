import os
import glob
import re
import json

def build_full_audit():
    root = os.path.abspath(".")
    docs_dir = os.path.join(root, "docs")
    os.makedirs(docs_dir, exist_ok=True)
    out_path = os.path.join(docs_dir, "i18n-audit.md")

    dart_files = sorted(glob.glob("lib/**/*.dart", recursive=True))

    bangla_re = re.compile(r'[\u0980-\u09FF]')
    devanagari_letters_re = re.compile(r'[\u0904-\u0939\u093D-\u0963\u0966-\u097F]')
    danda_re = re.compile(r'[\u0964\u0965]')
    inter_re = re.compile(r'(\"[^\"]*?\$\{?[a-zA-Z0-9_.]+\}?[^\"]*?\"|\x27[^\x27]*?\$\{?[a-zA-Z0-9_.]+\}?[^\x27]*?\x27)')

    # ARB stats
    arb_dir = os.path.join(root, "assets", "l10n")
    arb_stats = {}
    for lang in ["en", "bn", "hi", "it"]:
        path = os.path.join(arb_dir, f"app_{lang}.arb")
        if os.path.exists(path):
            with open(path, "r", encoding="utf-8") as f:
                d = json.load(f)
                arb_stats[lang] = len([k for k in d.keys() if not k.startswith("@")])

    file_analysis = {}

    for fpath in dart_files:
        rel_path = os.path.relpath(fpath, root)
        with open(fpath, "r", encoding="utf-8") as f:
            lines = f.readlines()

        b_lines = []
        h_lines = []
        d_lines = []
        i_lines = []
        dialogs = []
        snackbars = []
        buttons = []
        inputs = []
        texts = []

        for idx, line in enumerate(lines, 1):
            s = line.strip()

            if bangla_re.search(line):
                b_lines.append((idx, s))

            if devanagari_letters_re.search(line):
                h_lines.append((idx, s))

            if danda_re.search(line):
                d_lines.append((idx, s))

            # Interpolations
            m = inter_re.findall(line)
            if m:
                for match_item in m:
                    if not any(k in match_item for k in ["assets/", "images/", "http", "package:", "dart:"]):
                        i_lines.append((idx, match_item))

            if any(term in line for term in ["showDialog", "AlertDialog", "showModalBottomSheet"]):
                dialogs.append((idx, s))

            if "SnackBar(" in line:
                snackbars.append((idx, s))

            if any(term in line for term in ["DuolingoButton(", "ElevatedButton(", "TextButton(", "OutlinedButton("]):
                buttons.append((idx, s))

            if any(term in line for term in ["TextField(", "TextFormField(", "hintText:", "labelText:", "helperText:"]):
                inputs.append((idx, s))

            if any(term in line for term in ["Text(", "LocalizedText(", "context.uiText("]):
                texts.append((idx, s))

        file_analysis[rel_path] = {
            "total_lines": len(lines),
            "bangla": b_lines,
            "hindi": h_lines,
            "danda": d_lines,
            "interpolations": i_lines,
            "dialogs": dialogs,
            "snackbars": snackbars,
            "buttons": buttons,
            "inputs": inputs,
            "texts": texts,
        }

    return file_analysis, arb_stats, out_path

file_analysis, arb_stats, out_path = build_full_audit()
print(f"Scanned {len(file_analysis)} files successfully.")
