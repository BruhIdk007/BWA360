# Rebuild the repository history from zero

This procedure creates a brand-new local Git history from the canonical M1 snapshot and replaces the existing GitHub `main` history.

## 1. Preserve the old working tree

Do not delete the previous tree. Rename it or archive it first.

## 2. Start from the canonical snapshot

The clean snapshot directory should become the new repository root.

## 3. Initialize a new history

```bash
git init
git branch -M main
git config user.name "YOUR NAME"
git config user.email "YOUR GITHUB EMAIL"
```

Audit before the first commit:

```bash
git status --short
git grep -n '/home/' || true
find . -type f \( -name '*.xex' -o -name '*.exe' -o -name '*.obj' -o -name '*.basefile' -o -name '*.pak' \) -print
```

Then:

```bash
git add .
git commit -m "BWA360 v0.0.1: complete M1 Hello360 bring-up"
```

## 4. Attach the existing GitHub repository

```bash
git remote add origin https://github.com/BruhIdk007/BWA360.git
git fetch origin
```

Because the repository is deliberately being rebuilt from zero, replace the old remote history with the new root commit:

```bash
git push -u origin main --force-with-lease
```

Use `--force-with-lease`, not plain `--force`.

## 5. Tag M1 only after the GitHub tree is verified

```bash
git tag -a v0.0.1 -m "BWA360 v0.0.1 - Toolchain Bring-up"
git push origin v0.0.1
```

After this point, continue normal non-forced development for M2.
