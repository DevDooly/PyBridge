import concurrent.futures
import time
import urllib.request
import json
import os
from dotenv import load_dotenv

# .env 파일 로드 (부모 디렉토리 기준)
load_dotenv(os.path.join(os.path.dirname(__file__), "..", ".env"))

def fetch_delay(url):
    try:
        req = urllib.request.Request(url)
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        return {"error": str(e)}

if __name__ == "__main__":
    port = os.getenv("PORT", "8088")
    urls = [f"http://localhost:{port}/delay" for _ in range(10)]
    print(f"동시 10개 요청 시작 (Port: {port})...")
    
    start_time = time.time()
    
    with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
        results = list(executor.map(fetch_delay, urls))
        
    end_time = time.time()
    
    for i, res in enumerate(results):
        print(f"요청 {i+1} 결과: {res}")
        
    print(f"\n총 소요 시간: {end_time - start_time:.2f} 초")
    if (end_time - start_time) < 15:
        print("테스트 성공: 병렬 처리(비동기)가 정상적으로 작동합니다!")
    else:
        print("테스트 실패: 처리 시간이 너무 깁니다. 비동기가 제대로 동작하지 않을 수 있습니다.")
