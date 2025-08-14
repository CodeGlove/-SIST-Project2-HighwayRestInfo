from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.action_chains import ActionChains
import time
import pandas as pd
from datetime import datetime

def switch_frame(frame):
    driver.switch_to.default_content()  # frame 초기화
    driver.switch_to.frame(frame)  # frame 변경

def time_wait(num, code):
    try:
        wait = WebDriverWait(driver, num).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, code)))
    except:
        print(code, '태그를 찾지 못하였습니다.')
        driver.quit()
    return wait

# Chrome 옵션 설정 (참고 코드 기반)
options = webdriver.ChromeOptions()
options.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3')
options.add_argument('window-size=1380,900')
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")

# Chrome 드라이버 생성
driver = webdriver.Chrome(options=options)

# 대기 시간 설정
driver.implicitly_wait(time_to_wait=3)

# 검색할 키워드 리스트
keywords = ["첫번째는 날리기","정안알밤휴게소(천안방향)", "하남드림휴게소", "시흥하늘휴게소", "가평휴게소(춘천)", "홍성휴게소(서울)"]

# 데이터 저장을 위한 리스트
all_data = []

# 각 키워드에 대해 반복 처리
for keyword in keywords:
    try:
        count = True
        print(f"\n{'='*60}")
        print(f"검색 키워드: {keyword}")
        print(f"{'='*60}")
        
        # 네이버 지도 검색 URL로 직접 접속
        search_url = f"https://map.naver.com/p/search/{keyword}"
        driver.get(url=search_url)
        print(f"현재 URL: {driver.current_url}")
        if count:  # 첫 번째 키워드일 때 5초 대기
            time.sleep(3)
            count = False
        # 페이지 로딩 대기
        else:
            time.sleep(2)
        
        # searchIframe으로 전환
        try:
            switch_frame('searchIframe')
            store_list = driver.find_elements(By.CSS_SELECTOR, 'li.VLTHu')
            time.sleep(1)
            
            # place_bluelink 클래스를 가진 링크 찾기
            place_links = driver.find_elements(By.CSS_SELECTOR, 'a.place_bluelink')
            
            if place_links:
                first_link = place_links[0]
                
                # 링크 클릭
                first_link.click()
                print("링크를 클릭했습니다.")
                
                # entryIframe으로 전환
                try:
                    switch_frame('entryIframe')
                    
                    # 주소 정보 추출
                    address = "주소 정보 없음"
                    try:
                        address_element = driver.find_element(By.CSS_SELECTOR, '.LDgIH')
                        address = address_element.text
                        print(f"도로명주소: {address}")
                    except:
                        print("도로명주소를 찾을 수 없습니다.")
                    
                    # 전화번호 정보 추출
                    phone = "전화번호 정보 없음"
                    try:
                        number_element = driver.find_element(By.CSS_SELECTOR, '.xlx7Q')
                        phone = number_element.text
                        print(f"전화번호: {phone}")
                    except:
                        print("전화번호를 찾을 수 없습니다.")

                    # 별점 정보 추출
                    rating = "별점 정보 없음"
                    try:
                        rating_element = driver.find_element(By.CSS_SELECTOR, '.PXMot.LXIwF')
                        text = rating_element.text.strip()
                        rating = text.replace("별점", "").strip()
                        print(f"별점: {rating}")
                    except:
                        print("별점 정보를 찾을 수 없습니다.")
                    
                    # 데이터를 리스트에 추가 (들여쓰기 수정)
                    all_data.append({
                        '휴게소명': keyword,
                        '도로명주소': address,
                        '전화번호': phone,
                        '별점': rating,
                        '수집시간': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                    })
                    print(f"데이터 수집 완료: {keyword}")
                            
                except Exception as e:
                    print(f"entryIframe 처리 중 오류: {e}")
                    # 오류가 발생해도 기본 데이터는 저장
                    all_data.append({
                        '휴게소명': keyword,
                        '도로명주소': '오류 발생',
                        '전화번호': '오류 발생',
                        '별점': '오류 발생',
                        '수집시간': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                    })
                    
            else:
                print("place_bluelink 클래스를 가진 링크를 찾을 수 없습니다.")
                # 링크를 찾지 못한 경우에도 기본 데이터 저장
                all_data.append({
                    '휴게소명': keyword,
                    '도로명주소': '링크 없음',
                    '전화번호': '링크 없음',
                    '별점': '링크 없음',
                    '수집시간': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                })
                
        except Exception as e:
            print(f"searchIframe 처리 중 오류: {e}")
            # 오류가 발생해도 기본 데이터는 저장
            all_data.append({
                '휴게소명': keyword,
                '도로명주소': '프레임 오류',
                '전화번호': '프레임 오류',
                '별점': '프레임 오류',
                '수집시간': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            })
            
        # 다음 키워드로 넘어가기 전에 잠시 대기
        time.sleep(1)
        
    except Exception as e:
        print(f"키워드 '{keyword}' 처리 중 오류 발생: {e}")
        # 예외가 발생해도 기본 데이터는 저장
        all_data.append({
            '휴게소명': keyword,
            '도로명주소': '예외 발생',
            '전화번호': '예외 발생',
            '별점': '예외 발생',
            '수집시간': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        })
        continue

# 모든 키워드 처리 완료 후 엑셀로 저장
if all_data:
    df = pd.DataFrame(all_data)
    
    # 현재 시간을 파일명에 포함
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    filename = f'가게정보_데이터_{timestamp}.xlsx'
    
    # 엑셀로 저장
    df.to_excel(filename, index=False, engine='openpyxl')
    print(f"\n데이터가 '{filename}' 파일로 저장되었습니다.")
    print(f"총 {len(all_data)}개의 데이터가 저장되었습니다.")
    
    # 저장된 데이터 미리보기
    print("\n저장된 데이터 미리보기:")
    print(df.head())
else:
    print("\n수집된 데이터가 없습니다.")

# 모든 키워드 처리 완료 후 브라우저 유지
print("\n모든 키워드 처리가 완료되었습니다.")
print("브라우저를 열어둔 상태로 유지합니다. 종료하려면 Ctrl+C를 누르세요.")
try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    print("\n사용자가 브라우저를 종료합니다.")
    driver.quit()
    

