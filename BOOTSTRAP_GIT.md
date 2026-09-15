# Bootstrap the official Git repository

From the repository root:

```bash
git init
git branch -M main

git add .
git status
```

Before committing, inspect carefully for proprietary files and local absolute paths:

```bash
git grep -n '/home/' || true
git grep -n 'main\.pak' || true
git status --short
```

Then create the M1 snapshot commit:

```bash
git commit -m "Complete M1 Hello360 Xbox 360 bring-up"
git tag -a v0.0.1 -m "BWA360 v0.0.1 - Toolchain Bring-up"
```

Recommended GitHub repository description and topics are in `docs/repository/GITHUB_METADATA.md`.

If using GitHub CLI after creating an empty remote:

```bash
git remote add origin git@github.com:<USER>/BWA360.git
git push -u origin main
git push origin v0.0.1
```

Create the remote privately first, audit the content, choose a project-wide license, then make it public when ready.
