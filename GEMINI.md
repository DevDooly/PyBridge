# PyBridge 프로젝트 규칙

이 문서는 `PyBridge` 프로젝트의 개발, 배포 및 운영을 위한 가이드라인과 규칙을 담고 있습니다.

## 1. 프로젝트 개요
- **목적**: Python 기반의 API 서버 제공 (FastAPI 및 Flask 활용)
- **주요 기술 스택**: 
  - Python 3.x
  - FastAPI (고성능 비동기 API)
  - Flask (경량 API 및 유연한 확장)

## 2. 문서 및 코드 작성 규칙
- **언어**: 모든 README.md 및 마크다운 파일은 **한글**로 작성합니다.
- **커밋 메시지**: 커밋 메시지는 **한글**로 작성하며, 변경 사항을 명확하게 기술합니다.
- **코드 스타일**: PEP 8 표준을 준수하며, 타입 힌트(Type Hinting)를 적극 활용합니다.

## 3. 작업 및 자동화 프로세스
- **자동 Commit & Push**: 모든 작업 진행 후에는 별도의 확인 절차 없이 **자동으로 스테이징, 커밋 및 원격 저장소(Push) 반영**을 수행합니다.
- **검증**: 변경 사항을 반영하기 전에 린트 체크 및 테스트를 수행하여 안정성을 확보합니다.

## 4. 개발 및 배포 가이드
### 4.1 개발 환경 설정
```bash
# 가상환경 생성 및 활성화
python -m venv venv
source venv/bin/activate

# 의존성 설치
pip install -r requirements.txt
```

### 4.2 API 서버 실행
- **FastAPI**: `uvicorn main:app --reload`
- **Flask**: `flask run`

### 4.3 배포 방법
- **Docker 활용**: `docker build -t pybridge:latest .`
- **프로세스 관리**: Gunicorn 또는 Uvicorn을 활용하여 백그라운드 실행을 권장합니다.
- **CI/CD**: GitHub Actions를 통한 자동 배포 환경 구축을 지향합니다.

---
*규칙은 프로젝트의 성장에 따라 지속적으로 업데이트됩니다.*
