# PackMana Repository

This repository hosts packages for the **Packmana** package manager.

## Overview

PackMana-Repository contains pre-packaged `.tar.gz` files and version metadata that Packmana users can install, update, and remove using the Packmana CLI tool.

Packages here are simple archives containing executable bash scripts (`.sh` files) ready for installation.

---

## How to add your own package

If you want to contribute your own package to Packmana’s repository:

1. Fork this repository.

2. Prepare your package:
   - Create a bash script file (`your-script.sh`).
   - Package it into a `.tar.gz` archive:
     ```bash
     tar czf your-script.tar.gz your-script.sh
     ```
   - Create a version file named `your-script.version` with the version string, e.g.:
     ```
     1.0
     ```

3. Add your package files (`your-script.tar.gz` and `your-script.version`) to the root of your forked repo.

4. Commit and push your changes.

5. Open a Pull Request to this repository.

---

## How Packmana uses this repo

- Packmana downloads packages and their version files from this repository via GitHub Pages.
- When users run `packmana install <package>`, it looks for the corresponding `.tar.gz` archive here.
- The version files (`.version`) allow Packmana to check for updates.

---

## Repository structure

/ (root)
|- helloworld.tar.gz
|- helloworld.version
|- anotherpkg.tar.gz
|- anotherpkg.version
|- ...
