# 한상 — 한국의 맛을 만나다

전통 한식, 일상의 한식, 퓨전 한식을 소개하는 반응형 홈페이지입니다. HTML/CSS/JavaScript만으로 동작하며 빌드가 필요하지 않습니다.

## 포함된 기능

- 16개 카테고리: 밥, 국·탕·찌개, 구이, 김치·발효, 면·만두, 분식, 전·부침, 도시락, 보양·계절식, 채소·나물, 떡·전통과자, 빙수, 전통차, 치킨·야식, 모던 한식, 글로벌 퓨전
- 카테고리별 대표 음식 이미지, 소개, 재료, 팁, 관련 음식
- 음식·재료·관련 메뉴 검색과 분류 필터
- 각 음식 페이지의 게시판: 글쓰기, 열람, 수정, 삭제
- 기본 브라우저 저장 모드와 선택형 Supabase 공유 게시판
- 모바일 대응, 키보드 탐색, 읽기 보조기용 레이블

## 내 컴퓨터에서 실행

프로젝트 폴더에서 다음 명령을 실행합니다.

```powershell
python -m http.server 8000
```

브라우저에서 **http://localhost:8000** 을 엽니다. 종료는 터미널에서 Ctrl+C를 누르세요.

## GitHub Pages 배포

1. GitHub에 새 저장소를 만들고 이 폴더의 파일을 업로드합니다. `.github/workflows/pages.yml`과 `assets` 폴더도 포함하세요. `.venv`는 업로드하지 않습니다.
2. 기본 브랜치를 `main`으로 사용합니다. 다른 브랜치를 사용한다면 `pages.yml`의 `branches` 값을 수정하세요.
3. 저장소의 **Settings → Pages → Build and deployment → Source**에서 **GitHub Actions**를 선택합니다.
4. `main`에 푸시하거나 **Actions → Deploy Hansang to GitHub Pages → Run workflow**를 실행합니다.
5. 배포가 끝나면 Settings → Pages 또는 Actions의 배포 결과에서 주소를 확인합니다. 일반적인 주소는 `https://사용자이름.github.io/저장소이름/`입니다.

파일 경로는 모두 상대 경로이며 페이지 주소는 `#/food/bibimbap` 형태입니다. 저장소 하위 경로와 상세 페이지 새로고침을 지원합니다. 공개 주소 발급은 GitHub에서 실제 배포 후 이루어집니다.

Git 사용 예시(저장소 주소는 자신의 값으로 바꾸세요):

```powershell
git init
git add .
git commit -m "Create Hansang Korean food website"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
git push -u origin main
```

## 게시판 저장 방식

### 기본: 브라우저 저장

별도 설정 없이 글쓰기·수정·삭제가 가능합니다. 글은 현재 브라우저의 `localStorage`에 저장됩니다. **다른 방문자나 다른 기기에서는 볼 수 없으며, 브라우저 데이터를 삭제하면 글도 사라집니다.** 기본 모드에는 서버 인증이 없으므로 같은 브라우저를 쓰는 사람이 저장된 글을 수정할 수 있습니다.

### 선택: 여러 방문자가 함께 쓰는 공유 게시판

GitHub Pages는 정적 호스팅이므로 공유 게시판을 사용하려면 별도의 데이터베이스가 필요합니다. 이 프로젝트는 Supabase 연동 코드를 포함합니다. 계정이나 서버 연결 정보는 아직 설정되어 있지 않습니다.

1. [Supabase](https://supabase.com/)에서 프로젝트를 만듭니다.
2. SQL Editor에서 [`supabase/schema.sql`](supabase/schema.sql)을 한 번 실행합니다. 공개 읽기와 로그인한 작성자 본인의 작성·수정·삭제만 허용하는 RLS 정책이 포함됩니다.
3. 프로젝트의 API 설정에서 Project URL과 공개용 `anon` 키 또는 publishable 키를 확인합니다.
4. [`config.js`](config.js)의 두 값을 채웁니다.

```js
window.HANSANG_CONFIG = {
  supabaseUrl: "https://YOUR_PROJECT.supabase.co",
  supabaseAnonKey: "YOUR_PUBLIC_ANON_OR_PUBLISHABLE_KEY"
};
```

5. **Authentication → URL Configuration**에서 Site URL을 실제 GitHub Pages 주소로 설정하고, Redirect URLs에 **동일한 주소(저장소 경로와 끝의 `/`까지)**를 추가합니다. 예: `https://myname.github.io/hansang/`. 로컬 테스트 시 `http://localhost:8000/`도 추가합니다.
6. 이메일 인증을 켜고, 운영 시에는 이메일 발송 설정과 발송 제한도 확인하세요. 사이트의 로그인 버튼으로 매직 링크를 요청하고 메일을 열어 로그인합니다.
7. 변경한 `config.js`를 GitHub에 푸시하면 공유 게시판 모드가 활성화됩니다.

공유 모드는 누구나 글을 읽을 수 있고, 로그인 후 글을 작성하며 본인 글만 수정·삭제할 수 있습니다. 개인 저장 모드의 글은 자동으로 공유 저장소로 옮겨지지 않습니다. 공유 연결에 실패하면 오류를 표시하며 개인 저장으로 전환하지 않습니다. 각 페이지는 최신 글 200개까지 표시합니다.

**service_role/secret 키는 공개 파일에 넣지 마세요.** 클라이언트용 공개 키와 SQL의 RLS 정책을 함께 사용하는 구조입니다. 참고: [Supabase 이메일 로그인](https://supabase.com/docs/reference/javascript/auth-signinwithotp), [RLS](https://supabase.com/docs/guides/database/postgres/row-level-security).

## 내용과 디자인 수정

- `data.js`: 음식 이름, 소개, 재료, 카테고리, 관련 음식
- `style.css`: 레이아웃, 색상, 반응형 스타일
- `app.js`: 화면과 게시판 동작
- `assets/food-atlas.png`: 4×4 음식 이미지 아틀라스
- `config.js`: 공유 게시판 공개 연결 설정

이미지의 칸 순서는 `data.js` 음식 순서와 같습니다. 새 이미지를 사용할 때는 해당 순서를 유지하거나 `photo()` 함수의 이미지 연결 방식을 변경하세요.

이미지는 imagegen 내장 도구로 제작한 AI 연출 이미지이며, 실제 식당이나 상품의 사진이 아닙니다. 최종 생성 프롬프트는 [`assets/IMAGE-PROMPT.md`](assets/IMAGE-PROMPT.md)에 기록했습니다. 한글 웹폰트는 Google Fonts에서 불러오며 연결되지 않으면 시스템 글꼴로 표시됩니다. Supabase JS SDK v2.49.1은 `assets/vendor`에 포함했습니다.

## 검증 범위

Chrome 자동 브라우저 검사에서 16개 상세 페이지, 검색·분류, 글 작성·새로고침 후 유지·열람·수정·삭제, 페이지별 게시글 분리, HTML 이스케이프, 모바일 가로 넘침, 이미지 응답, JavaScript 오류 없음을 확인했습니다. Supabase 공유 모드의 실제 로그인, 데이터 저장, 이메일 발송은 자신의 프로젝트를 연결한 뒤 추가로 확인해야 합니다. GitHub Actions의 실제 배포도 저장소에 업로드한 뒤 확인할 수 있습니다.

검사를 다시 실행하려면 로컬 서버를 켠 뒤 다음 명령을 실행하세요. 검사 스크립트는 Windows의 기본 Chrome 설치 경로를 사용합니다.

```powershell
npm install --prefix tools/browser --cache .npm-cache --no-save --package-lock=false playwright
node tools/check-site.cjs
```
