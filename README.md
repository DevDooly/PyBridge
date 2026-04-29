# PyBridge

PyBridge는 Python 기반의 고성능 비동기 API 서버입니다 (FastAPI 활용).

## 주요 기능
- **서버 상태 확인 (`/`)**: 서버가 정상적으로 실행 중인지 확인합니다.
- **CSV 파일 검증 (`/validate-csv`)**: 로컬 파일 시스템 경로의 CSV 파일을 읽고, 빈 파일 여부 및 데이터 행/열 개수, Null 값 등의 기본 검증 정보를 반환합니다.
- **아이템 조회 (`/items/{item_id}`)**: 경로 매개변수와 쿼리 매개변수를 활용한 기본적인 아이템 조회 API입니다.

## 로컬 실행 방법
1. 가상 환경 생성 및 패키지 설치
   ```bash
   python -m venv venv
   source venv/bin/activate  # (Windows: venv\Scripts\activate)
   pip install -r requirements.txt
   ```
2. 서버 실행
   ```bash
   uvicorn main:app --host 0.0.0.0 --port 8088 --reload
   ```

## Docker 배포 및 실행
Dockerfile이 제공되어 컨테이너 환경에서 실행할 수 있습니다.

```bash
# Docker 이미지 빌드
docker build -t pybridge:latest .

# Docker 컨테이너 실행
docker run -d -p 8088:8088 --name pybridge-server pybridge:latest
```

## Kubernetes (Helm) 배포
Helm 차트가 `helm/pybridge` 폴더에 작성되어 있어 쉽게 Kubernetes 클러스터에 배포할 수 있습니다.

```bash
# Helm 차트가 있는 디렉토리로 이동
cd helm/pybridge

# Helm 차트 설치
helm install my-pybridge .

# 상태 확인
kubectl get pods
kubectl get services
```

## 기술 스택
- **Python 3.9+**
- **FastAPI**
- **Pandas**
- **Docker**
- **Kubernetes / Helm**