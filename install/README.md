# CentOS 7 Python 3.12 & Miniconda 오프라인 설치 가이드

이 문서는 인터넷이 연결되지 않은 CentOS 7 환경에서 Python 3.12, OpenSSL 1.1.1 및 Miniconda를 설치하기 위한 준비 및 실행 방법을 설명합니다.

## 1. 사전 준비 (인터넷이 연결된 환경)

인터넷이 연결된 동일한 버전의 CentOS 7 머신에서 아래 파일들을 다운로드하여 `install/files/` 디렉토리에 배치해야 합니다.

### 1.1 소스 코드 및 설치 파일 다운로드
아래 파일들을 `install/files/src/` 폴더에 다운로드합니다.
- **Python 3.12.x**: [Python-3.12.x.tar.xz](https://www.python.org/ftp/python/3.12.x/Python-3.12.0.tar.xz)
- **OpenSSL 1.1.1w**: [openssl-1.1.1w.tar.gz](https://www.openssl.org/source/openssl-1.1.1w.tar.gz)
- **Miniconda3**: [Miniconda3-latest-Linux-x86_64.sh](https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh)

### 1.2 RPM 의존성 패키지 다운로드
CentOS 7 기본 레포지토리에서 빌드에 필요한 패키지들을 `install/files/rpms/` 폴더에 다운로드합니다.

```bash
mkdir -p rpms
yum install -y yum-utils
repotrack -p ./rpms gcc make wget libffi-devel zlib-devel bzip2-devel readline-devel sqlite-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
```

### 1.3 Python 모듈(WHL) 다운로드
가상환경에서 사용할 모듈들을 `install/files/packages/` 폴더에 다운로드합니다. (의존성 포함)

```bash
mkdir -p packages
# requirements.txt에 명시된 모든 패키지를 WHL 파일로 다운로드
pip download -d ./packages -r requirements.txt
```

## 2. 파일 배치 구조

준비된 파일들은 프로젝트 내에 다음과 같이 배치되어야 합니다.

```text
install/
├── README.md                   # 설치 가이드
├── hosts                       # 대상 서버 인벤토리
├── playbook.yml                # Python 3.12 설치용
├── miniconda_playbook.yml      # Miniconda 설치용
├── conda_env_playbook.yml      # 가상환경 및 모듈 관리용
├── roles/                      # Ansible 역할 정의
│   ├── python312/
│   ├── miniconda/
│   └── conda_env/              # 가상환경 관리 역할
└── files/
    ├── requirements.txt        # 설치할 Python 모듈 목록
    ├── packages/               # 다운로드한 .whl 파일들
    ├── binaries/               # (선택) 컴파일 완료된 바이너리 아카이브
    ├── rpms/                   # 의존성 .rpm 파일들
    └── src/                    # Python, OpenSSL, Miniconda 소스
```

## 3. Ansible을 이용한 설치

### 3.1 인벤토리 설정 (`hosts`)
`install/hosts` 파일을 편집하여 설치 대상 서버의 IP와 접속 정보를 입력합니다.

### 3.2 설치 실행

#### Python 3.12 설치
```bash
cd install
ansible-playbook -i hosts playbook.yml -u root -k
```

#### Miniconda 설치
```bash
cd install
ansible-playbook -i hosts miniconda_playbook.yml -u root -k
```

#### 가상환경 및 모듈 관리 (requirements.txt)
```bash
cd install
ansible-playbook -i hosts conda_env_playbook.yml -u root -k
```

## 4. 설치 상세 내용
- **오프라인 모듈 설치**: 인터넷이 연결된 환경에서 `pip download`로 받은 `.whl` 파일들을 사용하여 설치합니다. `pip install --no-index --find-links` 옵션을 통해 외부망 접속 없이 로컬 파일만으로 가상환경을 구성합니다.
- **가상환경 관리**: `pybridge_env`라는 이름의 가상환경을 자동으로 생성하며, `requirements.txt`에 명시된 모듈들을 설치/업데이트합니다.
- **바이너리 배포 지원**: 한 대의 서버에서 컴파일이 완료된 후, 해당 경로를 압축하여 `install/files/binaries/` 폴더에 배치하면, 다른 서버들은 압축 해제만으로 즉시 설치됩니다.
- **OpenSSL 1.1.1**: `/usr/local/openssl111` 경로에 설치됩니다.
- **Python 3.12**: `/usr/local/python3.12` 경로에 설치됩니다.
- **Miniconda**: `/usr/local/miniconda3` 경로에 설치됩니다.
