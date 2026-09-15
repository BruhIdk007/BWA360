# Release / Tag Checklist

Use this before tagging a BWA360 milestone release.

## Repository hygiene

- [ ] `git status` contains only intended files.
- [ ] No original game executable/assets/`main.pak` are tracked.
- [ ] No generated `.obj`, `.exe`, `.xex` or `.basefile` files are tracked.
- [ ] No personal home-directory paths remain in committed build scripts.
- [ ] Third-party modifications preserve upstream license obligations.

## Milestone

- [ ] Detailed milestone checklist is complete.
- [ ] `ROADMAP.md` checkbox is updated.
- [ ] `STATUS.md` points to the next active milestone.
- [ ] `RELEASES.md` is updated.
- [ ] `CHANGELOG.md` has a release entry.
- [ ] Evidence is stored under `docs/evidence/`.

## Validation

- [ ] Clean rebuild passes.
- [ ] Xenia validation passes where applicable.
- [ ] Real hardware validation is recorded where required by the milestone.
- [ ] Known limitations are documented rather than silently ignored.

## Tag

```bash
git tag -a <version> -m "<release name>"
git push origin <version>
```
