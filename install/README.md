# CentOS 7 Python 3.12 오프라인 설치 가이드

이 문서는 인터넷이 연결되지 않은 CentOS 7 환경에서 Python 3.12 설치 및 프로젝트용 `venv` 가상환경을 구축하기 위한 가이드를 제공합니다.

> **참고**: CentOS 7은 최신 Miniconda 지원이 중단되었으므로, Python 3.12의 표준 `venv` 모듈을 사용합니다.

## 1. 사전 준비 (인터넷이 연결된 환경)

### 1.1 소스 코드 및 패키지 다운로드
- **Python 3.12.x**: [Python-3.12.x.tar.xz](https://www.python.org/ftp/python/3.12.x/Python-3.12.0.tar.xz)
- **OpenSSL 1.1.1w**: [openssl-1.1.1w.tar.gz](https://www.openssl.org/source/openssl-1.1.1w.tar.gz)

### 1.2 RPM 의존성 패키지 다운로드
```bash
mkdir -p rpms
yum install -y yum-utils
repotrack -p ./rpms gcc make libffi-devel zlib-devel bzip2-devel readline-devel sqlite-devel xz-devel openssl-devel
```

### 1.3 Python 모듈(WHL) 다운로드
`install/files/packages/` 폴더에 다운로드합니다.
```bash
mkdir -p packages
pip download -d ./packages -r requirements.txt
```

## 2. 파일 배치 구조
```text
install/
├── README.md                   # 설치 가이드
├── hosts                       # 대상 서버 인벤토리
├── playbook.yml                # Python 3.12 설치용
├── venv_playbook.yml           # venv 가상환경 및 모듈 관리용
├── roles/
│   ├── python312/              # Python 설치 Role
│   └── python_venv/            # venv 관리 Role
└── files/
    ├── requirements.txt        # 모듈 목록
    ├── packages/               # .whl 파일들
    ├── rpms/                   # .rpm 파일들
    └── src/                    # 소스 파일들
```

## 3. Ansible을 이용한 설치

### 3.1 Python 3.12 설치
```bash
cd install
ansible-playbook -i hosts playbook.yml -u root -k
```

### 3.2 venv 가상환경 및 모듈 설정
```bash
cd install
ansible-playbook -i hosts venv_playbook.yml -u root -k
```

## 4. 상세 내용
- **venv 경로**: `/home/rudy/app/listener/.venv` (설정에서 변경 가능)
- **오프라인 설치**: `pip install --no-index --find-links`를 통해 로컬 패키지만으로 설치를 수행합니다.
- **바이너리 배포**: Python 컴파일 완료 후 결과물을 압축하여 `files/binaries/`에 두면 다른 서버 배포 시 컴파일 시간을 단축할 수 있습니다.
