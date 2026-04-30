# PyBridge API Server

Python 기반의 고성능 비동기 API 서버 프로젝트입니다. FastAPI와 Flask를 활용하여 효율적인 API 인프라를 구축하는 데 목적이 있습니다.

## 🚀 프로젝트 구조
```text
PyBridge/
├── app/                # 애플리케이션 핵심 로직 (FastAPI Router, Services, Schemas)
├── scripts/            # 서버 관리 및 테스트 스크립트
│   ├── run.sh          # 서버 실행 (가상환경 자동 관리 및 nohup 적용)
│   ├── stop.sh         # 서버 종료
│   └── test_api.sh     # API 기능 테스트
├── main.py             # 진입점 (Entry Point)
├── requirements.txt    # 의존성 목록
├── GEMINI.md           # 프로젝트 규칙 및 개발 가이드
└── .gitignore          # Git 제외 목록
```

## 🛠 주요 기능
- **CSV 검증 API**: 로컬 CSV 파일의 경로를 인자로 받아 데이터 요약 정보를 반환합니다.
- **가상환경 자동화**: `run.sh` 실행 시 가상환경(`venv`) 생성 및 의존성 설치가 자동으로 처리됩니다.
- **Router 기반 구조**: 확장성을 고려하여 API 엔드포인트를 기능별로 분리 관리합니다.

## 🏁 시작하기

### 서버 실행
```bash
cd PyBridge/scripts
./run.sh
```

### 서버 종료
```bash
cd PyBridge/scripts
./stop.sh
```

### API 테스트
```bash
cd PyBridge/scripts
./test_api.sh
```

## 📝 개발 가이드
세부적인 개발 규칙 및 가상환경 설정 방법은 [GEMINI.md](./GEMINI.md) 파일을 참고하세요.
