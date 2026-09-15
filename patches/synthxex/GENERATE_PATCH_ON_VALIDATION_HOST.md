# Generate the exact local SynthXEX patch

The successful M1 validation host preserved a pre-patch backup directory resembling:

```text
/opt/openxechain/synthxex/m1-backup-20260915-230004/
```

Generate a single exact patch **on that host**, where both the original and successful modified sources exist:

```bash
cd /opt/openxechain/synthxex

diff -urN \
  m1-backup-20260915-230004 \
  src \
  > /path/to/BWA360/patches/synthxex/m1-function-import-thunks.patch || true
```

Because the backup directory contains selected source files rather than necessarily the same tree layout, inspect the resulting patch before committing it. Prefer a clean Git-based diff against the exact upstream SynthXEX v0.0.5 commit if available.

Do not fabricate a patch from documentation alone; preserve the exact working source delta from the validation host.
