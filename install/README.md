# CentOS 7 Python 3.12 오프라인 설치 가이드

이 문서는 인터넷이 연결되지 않은 CentOS 7 환경에서 Python 3.12와 OpenSSL 1.1.1을 설치하기 위한 준비 및 실행 방법을 설명합니다.

## 1. 사전 준비 (인터넷이 연결된 환경)

인터넷이 연결된 동일한 버전의 CentOS 7 머신에서 아래 파일들을 다운로드하여 `install/files/` 디렉토리에 배치해야 합니다.

### 1.1 소스 코드 다운로드
아래 파일들을 `install/files/src/` 폴더에 다운로드합니다.
- **Python 3.12.x**: [https://www.python.org/ftp/python/3.12.x/Python-3.12.x.tar.xz](https://www.python.org/ftp/python/3.12.x/Python-3.12.0.tar.xz)
- **OpenSSL 1.1.1w**: [https://www.openssl.org/source/openssl-1.1.1w.tar.gz](https://www.openssl.org/source/openssl-1.1.1w.tar.gz)

### 1.2 RPM 의존성 패키지 다운로드
CentOS 7 기본 레포지토리에서 빌드에 필요한 패키지들을 `install/files/rpms/` 폴더에 다운로드합니다.

```bash
# 의존성 패키지 목록 다운로드
mkdir -p rpms
yum install -y yum-utils
repotrack -p ./rpms gcc make wget libffi-devel zlib-devel bzip2-devel readline-devel sqlite-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
```

## 2. 파일 배치 구조

준비된 파일들은 프로젝트 내에 다음과 같이 배치되어야 합니다.

```
install/
├── ansible/
│   ├── playbook.yml
│   └── roles/python312/ ...
├── files/
│   ├── rpms/
│   │   └── (다운로드한 .rpm 파일들)
│   └── src/
│       ├── Python-3.12.x.tar.xz
│       └── openssl-1.1.1w.tar.gz
└── README.md
```

## 3. Ansible을 이용한 설치

### 3.1 인벤토리 설정
`install/ansible/playbook.yml`을 실행하기 전, 대상 서버 정보를 확인하세요.

### 3.2 설치 실행
`install/` 폴더를 대상 서버로 복사한 후 아래 명령어를 실행합니다. (Ansible이 설치되어 있어야 함)

```bash
cd install/ansible
ansible-playbook -i "localhost," -c local playbook.yml
```

## 4. 설치 상세 내용
- **OpenSSL 1.1.1**: `/usr/local/openssl111` 경로에 설치되며, 시스템 기본 OpenSSL에는 영향을 주지 않습니다.
- **Python 3.12**: `/usr/local/python312` 경로에 설치됩니다.
- **바이너리 링크**: `python3.12`, `pip3.12` 명령어가 `/usr/local/bin`에 링크됩니다.
