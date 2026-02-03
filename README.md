# 고속도로 휴게소 정보 시스템 (HighwayRestInfo)

## 📋 프로젝트 개요

고속도로 휴게소 정보 시스템은 한국 고속도로 휴게소에 대한 실시간 정보를 제공하는 웹 애플리케이션입니다.

## 🛠 기술 스택

### Backend Framework
- **Java 8-11** - 핵심 개발 언어
- **JSP/Servlet** - MVC 패턴 기반 웹 프레임워크
- **Apache Tomcat 9+** - 서블릿 컨테이너

### ORM & Database
- **MyBatis 3.5.16** - SQL 매핑 프레임워크
- **MySQL 8.x (AWS RDS)** - 메인 데이터베이스

### Authentication & Security
- **BCrypt (JBCrypt 0.4)** - 비밀번호 암호화
- **OAuth2** - 소셜 로그인 (Kakao, Naver)
- **Session 기반 인증** - 사용자 세션 관리

### External Services
- **AWS S3** - 파일 업로드 및 저장
- **Gmail SMTP** - 이메일 인증 및 비밀번호 재설정
- **Quartz Scheduler 2.3.2** - 배치 작업 스케줄링

### Data Processing
- **Apache POI 5.2.3** - Excel 파일 처리
- **Gson 2.10.1** - JSON 처리
- **JDOM2 2.0.6** - XML 파싱

### Additional Tools
- **Lombok 1.18.38** - 보일러플레이트 코드 감소
- **COS Library** - 파일 업로드 처리
- **JSTL 1.2** - JSP 표준 태그 라이브러리
- **SLF4J & Logback** - 로깅

## 🚀 시작하기

### 필수 요구사항
- Java 8-11
- Apache Tomcat 9+
- MySQL 8.0
- Maven 3+

### 설치 및 실행

1. **프로젝트 클론**
   ```bash
   git clone <repository-url>
   cd Project_4team
   ```

2. **데이터베이스 설정**

   MySQL 데이터베이스를 생성하고 `src/main/resources/application.properties` 파일을 생성하세요:

   ```properties
   # 데이터베이스 설정
   db.url=jdbc:mysql://localhost:3306/your_database
   db.username=your_username
   db.password=your_password

   # API 키 설정
   KAKAO_CLIENT_ID=your_kakao_client_id
   KAKAO_REDIRECT_URI=your_redirect_uri
   NAVER_CLIENT_ID=your_naver_client_id
   NAVER_CLIENT_SECRET=your_naver_client_secret

   # AWS S3 설정
   AWS_ACCESS_KEY=your_aws_access_key
   AWS_SECRET_KEY=your_aws_secret_key
   AWS_S3_BUCKET=your_bucket_name

   # Gmail SMTP 설정
   GMAIL_USERNAME=your_gmail@gmail.com
   GMAIL_PASSWORD=your_app_password

   # Tmap API 설정
   TMAP_API_KEY=your_tmap_api_key
   ```

   > ⚠️ **주의**: `application.properties` 파일은 보안을 위해 Git에 커밋하지 마세요.

3. **빌드 및 패키징**
   ```bash
   ./mvnw clean package
   ```

   빌드 결과물: `target/Project_4team-1.0-SNAPSHOT.war`

4. **애플리케이션 배포**

   생성된 WAR 파일을 Tomcat의 `webapps` 디렉토리에 복사하거나, IDE에서 Tomcat 서버로 직접 실행하세요.

5. **애플리케이션 접속**
   ```
   http://localhost:8080/Project_4team/
   ```

## 📁 프로젝트 구조

```
src/main/java/
├── restinfo/                   # 메인 애플리케이션 로직
│   ├── action/                # Command 패턴 액션 클래스 (40+ 액션)
│   ├── control/               # Front Controller & REST 엔드포인트
│   │   ├── Controller.java   # 중앙 서블릿 (/Controller)
│   │   └── RestAreaController.java  # REST API (/search)
│   ├── dao/                   # 데이터 접근 계층 (static 메서드)
│   ├── model/                 # 외부 API 서비스 통합
│   ├── util/                  # ConfigLoader, Paging 유틸리티
│   ├── GasPriceUpdateJob.java # Quartz 스케줄러 작업
│   └── QuartzSchedulerListener.java  # 스케줄러 초기화
├── bbs/                       # 게시판/커뮤니티 시스템
│   ├── action/                # 공지사항, FAQ, 게시글 작성/수정/삭제
│   ├── dao/                   # BbsDAO, LikeHateDAO
│   └── util/                  # 게시판 전용 페이징
└── mybatis/                   # ORM 계층
    ├── service/               # FactoryService (SqlSessionFactory)
    ├── vo/                    # Value Objects (11+ VO 클래스)
    └── resources/
        ├── config/conf.xml    # MyBatis 설정 파일
        └── mapper/            # XML 매퍼 파일 (11개, 50+ SQL 쿼리)

src/main/webapp/
├── WEB-INF/
│   ├── action.properties      # 요청 라우팅 맵
│   ├── web.xml               # 서블릿 매핑, CORS 필터 설정
│   └── views/                # JSP 뷰 페이지
├── css/                      # 스타일시트
├── js/                       # JavaScript 파일
├── image/                    # 이미지 리소스
└── bbs/                      # 게시판 관련 리소스
```

## 🔧 주요 기능

### 1. 휴게소 정보 조회
- **지능형 검색 알고리즘** (5단계 퍼지 매칭)
  - 정확한 매칭 (고속도로 접미사 유무 처리)
  - 방향 기반 매칭 (부산방향 등)
  - 부분 문자열 매칭
  - 키워드 추출 및 매칭
  - 유사도 점수 계산 (문자 중복도)
- 휴게소 기본 정보, 시설 정보, 운영 시간
- 실시간 혼잡도 정보 (Tmap API)

### 2. 유가 정보
- 한국도로공사 API 연동
- 주유소별 실시간 유가 조회
- Quartz 스케줄러를 통한 자동 업데이트 (매일 새벽 2시)

### 3. 메뉴 및 편의시설
- 휴게소별 음식 메뉴 정보
- 편의점, 약국 등 부대시설 정보
- 메뉴 가격 및 인기 메뉴 표시

### 4. 사용자 기능
- **회원가입 및 로그인**
  - BCrypt 비밀번호 해싱
  - 소셜 로그인 (Kakao, Naver OAuth2)
  - 이메일 인증 코드 발송 (6자리)
- **마이페이지**
  - 프로필 관리
  - 북마크 관리
  - 작성 글/댓글 관리
- **비밀번호 재설정**
  - 이메일을 통한 재설정 링크 발송

### 5. 게시판 시스템
- 공지사항, FAQ 게시판
- CKEditor 기반 글 작성 (이미지 첨부 지원)
- 파일 첨부 (AWS S3 업로드)
- 좋아요/싫어요 반응 시스템
- 페이징 처리

### 6. 리뷰 시스템
- 휴게소별 사용자 리뷰 작성
- 별점 평가
- 리뷰 목록 조회 및 더보기 기능

## 🌐 외부 API 연동

### SK Tmap API
- **장소 검색**: POI(Point of Interest) 검색
- **혼잡도 정보**: 실시간 장소별 혼잡도 조회
- 구현: `TmapSearchService`, `TmapCongestionService`

### 한국도로공사 (Korea Expressway Corporation)
- **유가 정보**: 고속도로 휴게소 주유소 가격
- **충전소 현황**: EV 충전소 상태 정보
- API 엔드포인트:
  - `https://data.ex.co.kr/openapi/restinfo/hiwaySvarInfoList`
  - `https://data.ex.co.kr/openapi/business/curStateStation`

### Kakao & Naver 지도 API
- 지도 표시 및 길찾기
- Geocoding (주소 <-> 좌표 변환)

모든 API 키는 `application.properties`를 통해 `ConfigLoader`로 중앙 관리됩니다.

## 🗄 데이터베이스

### MyBatis 설정
- **Connection Pool**: 5-10 연결
- **설정 파일**: `src/main/resources/mybatis/config/conf.xml`
- **Mapper 파일**: `src/main/resources/mybatis/mapper/` (11개)

### 주요 테이블
- `service_area` - 휴게소 기본 정보
- `gas` - 주유소 가격 정보
- `menu` - 휴게소 메뉴 정보
- `shop` - 편의시설 정보
- `user` - 사용자 정보
- `bookmark` - 사용자 북마크
- `bbs` - 게시판 게시글
- `like_hate` - 게시글 반응
- `review` - 휴게소 리뷰

### 데이터 관리
- **Soft Delete**: 게시글은 `DELETE` 플래그 사용 (0=활성, 1=삭제)
- **트랜잭션 관리**: MyBatis SqlSession commit/rollback 패턴
- **페이징**: MySQL row numbering (`@RN := @RN + 1`)

## 📐 아키텍처 패턴

### MVC + Command Pattern
```
HTTP Request → Controller Servlet → Action Classes → DAO → MyBatis → Database
                     ↓
              action.properties (라우팅 맵)
```

### 요청 라우팅
1. 모든 요청은 `/Controller` 서블릿으로 전달
2. `type` 파라미터로 액션 결정: `/Controller?type=login`
3. `action.properties`에서 매핑 정의
4. 액션 클래스가 JSP 경로 반환 또는 AJAX 응답 처리

예시 매핑:
```properties
login=restinfo.action.LoginAction
kakaoMap=restinfo.action.KaKaoMapV2
forgotPw=action.ForwardAction:/WEB-INF/views/forgotPw.jsp
```

### ConfigLoader 패턴
- `application.properties` 중앙 관리
- 정적 메서드로 전역 접근
- 사용 예: `ConfigLoader.getProperty("KAKAO_CLIENT_ID")`

## 🔐 보안 설정

- **비밀번호 암호화**: BCrypt 해싱
- **OAuth 인증**: Kakao, Naver OAuth2 with state 검증
- **세션 기반 인증**: HttpSession을 통한 사용자 상태 추적
- **CSRF 방지**: OAuth state 파라미터 검증

> ⚠️ **중요**: `application.properties`에 실제 자격 증명을 커밋하지 마세요.

## 📅 스케줄 작업

### Quartz Scheduler
- **리스너**: `QuartzSchedulerListener` (Tomcat 시작 시 초기화)
- **작업**: `GasPriceUpdateJob` - 한국도로공사 API에서 유가 정보 업데이트
- **실행 주기**: 매일 오전 2시 (기본값)
- **트랜잭션**: 오류 시 자동 롤백

## 🔄 개발 워크플로

### 새로운 액션 추가
1. `restinfo/action/` 또는 `bbs/action/`에 액션 클래스 생성
2. `Action` 인터페이스 구현
3. `action.properties`에 매핑 추가
4. `/Controller?type=yourAction`으로 접근

### 새로운 API 통합
1. `application.properties`에 API 키 추가
2. `ConfigLoader.getProperty()`로 로드
3. `restinfo/model/`에 서비스 클래스 생성
4. HttpURLConnection 또는 SDK 클라이언트 사용

### 데이터베이스 스키마 변경
1. `mybatis/mapper/`의 XML 매퍼 업데이트
2. `mybatis/vo/`의 VO 클래스 업데이트
3. 쿼리 로직 변경 시 DAO 메서드 수정
4. SqlSession commit/rollback 테스트

## 🐛 문제 해결

### 빌드 이슈
- Java 8-11 설치 확인
- Maven wrapper 실행 권한: `chmod +x mvnw`
- 클린 빌드: `./mvnw clean package`

### 데이터베이스 연결
- `application.properties` 자격 증명 확인
- AWS RDS 보안 그룹에서 연결 허용 확인
- MyBatis `conf.xml`의 데이터베이스 URL 확인

### Quartz 스케줄러 미실행
- `web.xml`의 `QuartzSchedulerListener` 확인
- `GasPriceUpdateJob`의 cron 표현식 검증
- 초기화 오류 로그 확인

### 파일 업로드 실패
- `application.properties`의 AWS S3 자격 증명 확인
- 버킷 이름 및 리전 일치 확인
- IAM 사용자의 S3 쓰기 권한 확인
- S3 네트워크 연결 확인

## 🤝 기여

이 프로젝트는 팀 프로젝트로 개발되었습니다.

## 📄 라이선스

이 프로젝트는 교육 목적으로 개발되었습니다.
