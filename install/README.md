# CentOS 7 Python 3.12 & Miniconda 오프라인 설치 가이드

이 문서는 인터넷이 연결되지 않은 CentOS 7 환경에서 Python 3.12, OpenSSL 1.1.1 및 Miniconda를 설치하기 위한 준비 및 실행 방법을 설명합니다.

## 1. 사전 준비 (인터넷이 연결된 환경)

인터넷이 연결된 동일한 버전의 CentOS 7 머신에서 아래 파일들을 다운로드하여 `install/files/` 디렉토리에 배치해야 합니다.

### 1.1 소스 코드 및 설치 파일 다운로드
아래 파일들을 `install/files/src/` 폴더에 다운로드합니다.
- **Python 3.12.x**: [https://www.python.org/ftp/python/3.12.x/Python-3.12.x.tar.xz](https://www.python.org/ftp/python/3.12.x/Python-3.12.0.tar.xz)
- **OpenSSL 1.1.1w**: [https://www.openssl.org/source/openssl-1.1.1w.tar.gz](https://www.openssl.org/source/openssl-1.1.1w.tar.gz)
- **Miniconda3**: [https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh](https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh)

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
│   ├── hosts
│   ├── playbook.yml            # Python 3.12 설치용
│   ├── miniconda_playbook.yml  # Miniconda 설치용
│   └── roles/ ...
├── files/
│   ├── binaries/               # (선택) 컴파일된 바이너리 아카이브 배치
│   │   ├── python312_bin.tar.gz
│   │   └── openssl111_bin.tar.gz
│   ├── rpms/
│   │   └── (다운로드한 .rpm 파일들)
│   └── src/
│       ├── Python-3.12.x.tar.xz
│       ├── openssl-1.1.1w.tar.gz
│       └── Miniconda3-latest-Linux-x86_64.sh
└── README.md
```

## 3. Ansible을 이용한 설치

### 3.1 인벤토리 설정 (`hosts`)
`install/ansible/hosts` 파일을 편집하여 설치 대상 서버의 IP와 접속 정보를 입력합니다. 이 플레이북은 **`python_servers` 그룹**에 등록된 서버들만을 대상으로 동작합니다.

```ini
[python_servers]
server1 ansible_host=192.168.1.10
server2 ansible_host=192.168.1.11
```

### 3.2 실행 계정 및 권한 설정
상황에 따라 실행 계정과 sudo 권한을 다음과 같이 지정할 수 있습니다.

- **방법 1: `hosts` 파일에 설정 (영구적)**
  `ansible_user`와 `ansible_ssh_pass` 등을 설정합니다.
- **방법 2: 명령줄 옵션 사용 (유연함)**
  - `-u [USER]`: 접속할 사용자 계정 지정 (예: `-u myuser`)
  - `-k`: 접속 사용자의 비밀번호 입력 프롬프트 활성화
  - `-K` (대문자): sudo(become) 권한 획득을 위한 비밀번호 입력 프롬프트 활성화

### 3.3 설치 실행
관리 PC(또는 배포 서버)에서 아래 명령어를 실행합니다.

#### Python 3.12 설치
```bash
cd install/ansible
ansible-playbook -i hosts playbook.yml -u root -k
```

#### Miniconda 설치
```bash
cd install/ansible
ansible-playbook -i hosts miniconda_playbook.yml -u root -k
```

> **참고**: SSH 키 기반 인증(`ssh-copy-id`)이 되어 있다면 `-k` 옵션은 생략 가능합니다.

## 4. 설치 상세 내용
- **바이너리 배포 지원**: 한 대의 서버에서 컴파일이 완료된 후, 해당 경로(`/usr/local/python312`, `/usr/local/openssl111`)를 압축하여 `install/files/binaries/` 폴더에 배치하면, 다른 서버들은 컴파일 과정 없이 압축 해제만으로 즉시 설치됩니다.
  - **압축 방법 예시**: `tar -czvf python312_bin.tar.gz /usr/local/python312` (경로 전체 포함 권장)
- **패키지 충돌 방지**: `repotrack`으로 받은 모든 패키지를 강제 설치하지 않고, 필수 빌드 도구만 선택적으로 설치하여 시스템 라이브러리와의 충돌을 방지합니다.
- **오프라인 배포**: 관리 PC에 준비된 파일들이 각 대상 서버의 임시 경로(`/tmp/...`)로 자동 복사된 후 설치됩니다.
- **OpenSSL 1.1.1**: `/usr/local/openssl111` 경로에 설치되며, 시스템 기본 OpenSSL에는 영향을 주지 않습니다.
- **Python 3.12**: `/usr/local/python312` 경로에 설치됩니다.
- **Miniconda**: `/usr/local/miniconda` 경로에 설치되며, `/etc/profile.d/miniconda.sh`를 통해 전역 환경 변수가 설정됩니다.
- **바이너리 링크**: `python3.12`, `pip3.12` 명령어가 `/usr/local/bin`에 링크되어 어디서든 사용 가능합니다.
