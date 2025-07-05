# Packmana Package Repository

Welcome to the **official package repository** for [Packmana](https://github.com/yourusername/packmana) — a simple Bash-based package manager for Linux systems.

This repository hosts prebuilt `.tar.gz` packages that can be installed using Packmana.

---

## 🌐 How It Works

Each package is a compressed `.tar.gz` archive containing:
- A `manifest.txt` file with metadata
- A standard Unix-style file tree (e.g., `usr/bin/app`)

Packmana can fetch and install these packages using `curl` or `wget` when you add this repo URL with:

```bash
packmana add-repo https://yourusername.github.io/packmana-repo

