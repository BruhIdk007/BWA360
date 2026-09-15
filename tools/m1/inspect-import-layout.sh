#!/usr/bin/env bash
set -euo pipefail

OX="${OX:-/opt/openxechain/sysroot}"
TARGET_DIR="${1:-$(pwd)}"

cd "$TARGET_DIR"

for f in default.xex default.xex.basefile hello360.exe; do
    [[ -f "$f" ]] || { echo "ERROR: missing $TARGET_DIR/$f"; exit 1; }
done

"$OX/bin/llvm-readobj" --coff-imports hello360.exe
"$OX/bin/llvm-objdump" -d --section=.text hello360.exe

python3 <<'PY'
import struct
from pathlib import Path

xex = Path('default.xex').read_bytes()
base = Path('default.xex.basefile').read_bytes()

def be32(b,o): return struct.unpack_from('>I', b, o)[0]
def be16(b,o): return struct.unpack_from('>H', b, o)[0]
def le32(b,o): return struct.unpack_from('<I', b, o)[0]

if xex[:4] != b'XEX2':
    raise SystemExit('Not XEX2')

header_count = be32(xex, 0x14)
IMPORT_KEY = 0x000103FF
import_off = None
for i in range(header_count):
    off = 0x18 + i * 8
    key, value = be32(xex,off), be32(xex,off+4)
    if key == IMPORT_KEY:
        import_off = value

if import_off is None:
    raise SystemExit('No XEX_HEADER_IMPORT_LIBRARIES')

total_size = be32(xex, import_off)
name_size = be32(xex, import_off + 4)
module_count = be32(xex, import_off + 8)
name_start = import_off + 12
name_blob = xex[name_start:name_start+name_size]

names=[]; p=0
while p < len(name_blob):
    end=name_blob.find(b'\0',p)
    if end < 0: break
    s=name_blob[p:end].decode('ascii',errors='replace')
    if s: names.append(s)
    p=(end+1+3)&~3

pe_off=le32(base,0x3C)
optional_off=pe_off+4+20
image_base=le32(base,optional_off+28)

print(f'Import header offset: 0x{import_off:X}')
print(f'Import total size : {total_size}')
print(f'Module count      : {module_count}')
print(f'PE ImageBase      : 0x{image_base:08X}')

lib_off=(name_start+name_size+3)&~3
for mod in range(module_count):
    table_size=be32(xex,lib_off)
    if not table_size: break
    name_index=xex[lib_off+0x25]
    import_count=be16(xex,lib_off+0x26)
    name=names[name_index] if name_index < len(names) else '?'
    print(f'Library #{mod}: {name}')
    print(f'  imports: {import_count}')
    records_off=lib_off+0x28
    for i in range(import_count):
        addr=be32(xex,records_off+i*4)
        rva=addr-image_base
        value=be32(base,rva) if 0 <= rva <= len(base)-4 else None
        if value is None:
            print(f'  [{i}] address=0x{addr:08X} outside basefile')
        else:
            typ=(value>>24)&0xff
            ordinal=value&0xffff
            print(f'  [{i}] address=0x{addr:08X} rva=0x{rva:05X} value=0x{value:08X} type={typ} ordinal={ordinal}')
    lib_off += table_size
PY
