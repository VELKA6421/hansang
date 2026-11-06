"""GitHub 업로드에 필요한 파일만 ZIP으로 묶습니다."""
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED

root = Path(__file__).resolve().parent.parent
names = ['index.html', 'style.css', 'app.js', 'data.js', 'config.js', '.nojekyll', '.gitignore', 'README.md']
folders = ['assets', 'supabase', '.github']
with ZipFile(root / 'hansang-github.zip', 'w', ZIP_DEFLATED) as archive:
    for name in names:
        archive.write(root / name, name)
    for folder in folders:
        for file in (root / folder).rglob('*'):
            if file.is_file():
                archive.write(file, file.relative_to(root).as_posix())
    for name in ['check-site.cjs', 'package.py']:
        archive.write(root / 'tools' / name, 'tools/' + name)
print('Created hansang-github.zip')
