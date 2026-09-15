#!/usr/bin/env bash
set -euo pipefail

SYNTH_SRC="${SYNTH_SRC:-/opt/openxechain/synthxex}"
BUILD_DIR="${BUILD_DIR:-$SYNTH_SRC/build-m1-import-thunks}"
DATA="$SYNTH_SRC/src/common/datastorage.h"
MAPPER="$SYNTH_SRC/src/pemapper/pemapper.c"
OPTS="$SYNTH_SRC/src/setdata/optheaders.c"

for f in "$DATA" "$MAPPER" "$OPTS"; do [[ -f "$f" ]] || { echo "ERROR: missing $f"; exit 1; }; done
BACKUP="$SYNTH_SRC/m1-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP"
cp "$DATA" "$BACKUP/datastorage.h"
cp "$MAPPER" "$BACKUP/pemapper.c"
cp "$OPTS" "$BACKUP/optheaders.c"
export DATA MAPPER OPTS
python3 <<'PY'
from pathlib import Path
import os,re

data=Path(os.environ['DATA']); mapper=Path(os.environ['MAPPER']); opts=Path(os.environ['OPTS'])
s=data.read_text()
if 'uint32_t thunkAddr;' not in s:
    pat=re.compile(r'struct\s+peImport\s*\{\s*uint32_t\s+iatAddr\s*;\s*\}\s*;',re.S)
    repl='''struct peImport\n{\n    uint32_t iatAddr;\n    uint32_t thunkAddr;\n    uint16_t ordinal;\n};'''
    s,n=pat.subn(repl,s,count=1)
    if n!=1: raise SystemExit('Could not patch peImport')
    data.write_text(s)

s=mapper.read_text()
if 'static uint32_t findImportThunk(' not in s:
    marker='int xenonifyIAT(FILE *basefile, struct peData *peData)'
    helper=r'''static uint32_t findImportThunk(FILE *basefile, struct peData *peData, uint32_t iatAddr)
{
    if(peData->size < 16) return 0;
    uint16_t hi=(uint16_t)(((iatAddr+0x8000)>>16)&0xFFFF);
    uint16_t lo=(uint16_t)(iatAddr&0xFFFF);
    uint8_t pattern[16]={0x3D,0x60,(uint8_t)(hi>>8),(uint8_t)hi,0x81,0x6B,(uint8_t)(lo>>8),(uint8_t)lo,0x7D,0x69,0x03,0xA6,0x4E,0x80,0x04,0x20};
    uint8_t *buffer=malloc(peData->size);
    if(!buffer) return 0;
    if(fseek(basefile,0,SEEK_SET)!=0){nullAndFree((void **)&buffer);return 0;}
    if(fread(buffer,1,peData->size,basefile)!=peData->size){nullAndFree((void **)&buffer);return 0;}
    for(uint32_t off=0;off+16<=peData->size;off+=4){
        if(memcmp(buffer+off,pattern,16)==0){uint32_t thunk=peData->baseAddr+off;nullAndFree((void **)&buffer);return thunk;}
    }
    nullAndFree((void **)&buffer);return 0;
}

static int xenonifyImportThunks(FILE *basefile, struct peData *peData)
{
    for(uint32_t i=0;i<peData->peImportInfo.tableCount;i++){
        struct peImportTable *table=&peData->peImportInfo.tables[i];
        for(uint32_t j=0;j<table->importCount;j++){
            struct peImport *imp=&table->imports[j];
            imp->thunkAddr=findImportThunk(basefile,peData,imp->iatAddr);
            if(!imp->thunkAddr) continue;
            uint32_t descriptor=0x01000000|((i&0xFF)<<16)|imp->ordinal;
            uint32_t thunkRVA=imp->thunkAddr-peData->baseAddr;
            if(fseek(basefile,thunkRVA,SEEK_SET)!=0) return ERR_FILE_WRITE;
#ifdef LITTLE_ENDIAN_SYSTEM
            descriptor=__builtin_bswap32(descriptor);
#endif
            if(fwrite(&descriptor,sizeof(uint32_t),1,basefile)<1) return ERR_FILE_WRITE;
            fseek(basefile,0,SEEK_CUR);
        }
    }
    return SUCCESS;
}

'''
    if marker not in s: raise SystemExit('xenonifyIAT marker not found')
    s=s.replace(marker,helper+marker,1)

needle='iatEntry |= (i & 0x000000FF) << 16; // Add the module index'
if 'imports[j].ordinal' not in s:
    if needle not in s: raise SystemExit('IAT module-index line not found')
    s=s.replace(needle,'peData->peImportInfo.tables[i].imports[j].ordinal = (uint16_t)(iatEntry & 0xFFFF);\n\n        '+needle,1)

endneedle='    return SUCCESS;\n}\n\n// Maps the PE file into the basefile (RVAs become offsets)'
if 'return xenonifyImportThunks(basefile, peData);' not in s:
    if endneedle not in s: raise SystemExit('xenonifyIAT end not found')
    s=s.replace(endneedle,'    return xenonifyImportThunks(basefile, peData);\n}\n\n// Maps the PE file into the basefile (RVAs become offsets)',1)
mapper.write_text(s)

s=opts.read_text()
old='''// Determine the number of addresses\n        importTables[i].addressCount = peImportInfo->tables[i].importCount;\n\n        // Allocate enough memory for the addresses\n        importTables[i].addresses = calloc(importTables[i].addressCount, sizeof(uint32_t));'''
if 'uint16_t thunkCount = 0;' not in s:
    new='''// Determine the number of addresses\n        uint16_t thunkCount = 0;\n        for(uint16_t j = 0; j < peImportInfo->tables[i].importCount; j++)\n            if(peImportInfo->tables[i].imports[j].thunkAddr != 0) thunkCount++;\n        importTables[i].addressCount = peImportInfo->tables[i].importCount + thunkCount;\n\n        // Allocate enough memory for the addresses\n        importTables[i].addresses = calloc(importTables[i].addressCount, sizeof(uint32_t));'''
    if old not in s: raise SystemExit('addressCount block not found')
    s=s.replace(old,new,1)
old2='''            addresses[currentAddr++] = peImportInfo->tables[i].imports[j].iatAddr;\n        }'''
if 'addresses[currentAddr++] =\n                    peImportInfo->tables[i].imports[j].thunkAddr;' not in s:
    new2='''            addresses[currentAddr++] = peImportInfo->tables[i].imports[j].iatAddr;\n            if(peImportInfo->tables[i].imports[j].thunkAddr != 0)\n                addresses[currentAddr++] =\n                    peImportInfo->tables[i].imports[j].thunkAddr;\n        }'''
    if old2 not in s: raise SystemExit('address population block not found')
    s=s.replace(old2,new2,1)
opts.write_text(s)
PY

cmake -S "$SYNTH_SRC" -B "$BUILD_DIR" -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build "$BUILD_DIR" --parallel
printf '\nPatched SynthXEX: %s\nBackup: %s\n' "$BUILD_DIR/synthxex" "$BACKUP"
