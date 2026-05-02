# AGENTS.md - Isaac Newton Physics Work Repository

## Repository Overview

This repository contains academic work for the Conceptual Physics I course at Unimontes.
The content focuses on Isaac Newton's scientific contributions for educational purposes.

**Professor:** Vitor Monteiro
**Schedule:** Tue, Thu 19:10 - 20:50
**Group Work:** The scope and format will be defined by group members/colleagues
**Status:** Scope not yet fully defined - initial references included Newton's life phases
**GitHub Repository:** https://github.com/dionarley/Trabaho_Fisica_Conceit_1_per_Divulgacao_Cient
**GitHub Pages:** https://dionarley.github.io/Trabaho_Fisica_Conceit_1_per_Divulgacao_Cient/

## Repository Structure

```
Isaac_Newton/
├── Documentos/           # Text documents, scripts, and notes
│   ├── README.txt       # Comic book script and project notes
│   └── .license.txt     # License file (gitignored)
├── Imagens/             # Images of Isaac Newton (various ages)
├── Referencias_PDFs/    # Academic references and papers
├── docs/                # MkDocs documentation source
│   ├── index.md         # Home page
│   ├── sobre.md         # About the project
│   ├── roteiro.md       # Comic script (to be defined by group)
│   ├── imagens.md       # Image gallery
│   ├── referencias.md   # Academic references
│   ├── contribuindo.md  # Contribution guide
│   └── licenca.md      # License details
├── mkdocs.yml          # MkDocs configuration
├── LICENSE              # CC BY-NC-SA 4.0 License
├── .gitignore          # Ignores .license.txt
├── README.md           # Project README
└── Isaac_Newton.zip    # Archive of materials
```

## Build/Lint/Test Commands

This is a documentation and research repository. MkDocs is used for documentation.

```bash
# MkDocs commands
mkdocs serve                    # Serve documentation locally at localhost:8000
mkdocs build                    # Build the documentation site
mkdocs gh-deploy                # Deploy to GitHub Pages (gh-pages branch)

# If adding Python scripts in the future:
#   python -m pytest tests/              # Run all tests
#   python -m pytest tests/test_file.py  # Run single test file
#   python -m pytest tests/test_file.py::test_name  # Run single test
#   python -m flake8 .                   # Lint Python code
#   python -m black .                    # Format Python code
```

## Code Style Guidelines

### General Principles

- Write clear, self-documenting code when adding scripts
- Prefer readability over cleverness
- Use consistent formatting throughout the project

### Python (if adding scripts)

```python
# Imports: standard library first, then third-party, then local
import os
import sys
from pathlib import Path

import numpy as np  # third-party example

# Naming conventions
variable_name = "snake_case"
CONSTANT_NAME = "UPPER_SNAKE_CASE"
function_name = "snake_case"
ClassName = "PascalCase"
_file_name = "snake_case.py"  # module names

# Type hints for function signatures
def calculate_gravity(mass: float, acceleration: float) -> float:
    return mass * acceleration

# Error handling
try:
    result = risky_operation()
except SpecificError as e:
    logger.error(f"Operation failed: {e}")
    raise
```

### Documentation Files

- Use Markdown for documentation files (README.md, etc.)
- Text files (.txt) should use UTF-8 encoding
- Keep line lengths reasonable (80-120 characters)
- Use Portuguese for academic content (course requirement)

### Images

- Supported formats: PNG, JPG, JPEG, WEBP
- Name files descriptively: `isaac-newton-young.jpg`, `in1-45-65.jpg`
- Optimize images before committing when possible

### PDF References

- Store academic papers in `Referencias_PDFs/`
- Use descriptive names: `9 - Isaac Newton.pdf`, `monografia-Durval-Araujo-de-Mendonça.pdf`
- Ensure you have rights to distribute referenced materials

## Licensing

This project is licensed under **CC BY-NC-SA 4.0** (Creative Commons Attribution-NonCommercial-ShareAlike).

When contributing:
- Attribute original work appropriately
- Do not use content for commercial purposes
- Share derivative works under the same license
- See LICENSE file for full terms: https://creativecommons.org/licenses/by-nc-sa/4.0/

## Git Workflow

```bash
# Check status
git status

# Stage changes
git add <file>

# Commit with descriptive message (Portuguese or English)
git commit -m "Add: description of changes"

# Push to remote
git push origin main
```

## Notes for AI Agents

- This repository contains educational content in Portuguese
- The project scope is not yet fully defined by the group
- References to Newton's life phases were initial draft ideas, not final scope
- When modifying documents, preserve the original formatting and intent
- Respect the CC BY-NC-SA 4.0 license for all contributions
- No automated testing exists; verify changes manually
- The `.license.txt` file is intentionally gitignored
- MkDocs documentation structure is ready for future content as scope defines
- MkDocs documentation is hosted at: https://dionarley.github.io/Trabaho_Fisica_Conceit_1_per_Divulgacao_Cient/
- GitHub repository: https://github.com/dionarley/Trabaho_Fisica_Conceit_1_per_Divulgacao_Cient

## MkDocs Version Note

- **Currently using:** MkDocs v1.4.8 + MkDocs Material v1.5.5
- **Version locked in:** `requirements.txt` (prevents auto-upgrade)
- **v2.0 warning:** Backward incompatible changes coming (no migration path)
- **Recommendation:** Stay on v1.x (works perfectly for this project)
- **If upgrading issues:** Just change `theme.name:` in `mkdocs.yml` to another theme

## Suggested MkDocs Pages for Undefined Scope

As the project scope is being defined, consider these documentation pages:

```
docs/
├── index.md           # Project overview and current status
├── sobre.md           # About the project and objectives
├── proposta.md        # Initial proposal and ideas (draft)
├── referencias.md     # Academic references and research
├── rascunhos.md       # Drafts and work-in-progress
├── contribuindo.md    # How to contribute
└── licenca.md        # License details
```

Additional pages to consider based on final scope:
- `metodologia.md` - Methodology (for academic rigor)
- `cronograma.md` - Timeline and milestones
- `recursos.md` - Resources and materials
- `rascunhos/ideias.md` - Brainstorming and ideas
