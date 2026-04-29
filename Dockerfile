FROM python:3.9-slim

WORKDIR /app

# 시스템 라이브러리 및 패키지 업데이트
RUN apt-get update && apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# 요구사항 설치
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 소스코드 복사
COPY . .

# 컨테이너 포트 8088 노출
EXPOSE 8088

# 서버 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8088"]
