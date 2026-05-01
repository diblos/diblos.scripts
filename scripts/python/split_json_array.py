import json
from pathlib import Path

src = Path('/Users/acs_mbp13_01/workspace/hyred/hyred.fire/devpro/functions/b.json')
out_dir = src.parent
prefix = src.stem

with src.open() as f:
    data = json.load(f)

if not isinstance(data, list):
    raise SystemExit('Expected top-level JSON array')

chunk_size = 100
created = []
for i in range(0, len(data), chunk_size):
    chunk = data[i:i + chunk_size]
    out_path = out_dir / f"{prefix}{i // chunk_size + 1}.json"
    with out_path.open('w') as f:
        json.dump(chunk, f, ensure_ascii=False)
    created.append((out_path.name, len(chunk)))

print(f'total_records={len(data)}')
print(f'files_created={len(created)}')
for name, count in created:
    print(f'{name} {count}')
