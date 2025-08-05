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
            print(f"찾은 place_bluelink 링크 수: {len(place_links)}")
            
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

                    # 리뷰 탭 클릭
                    try:
                        # 모든 탭 메뉴 요소 찾기
                        tab_menus = driver.find_elements(By.CSS_SELECTOR, '.tpj9w._tab-menu')
                        # 탭 메뉴 갯수에 따라 리뷰 탭 인덱스 결정
                        review_index = "1" if len(tab_menus) == 4 else "2"
                        review_button = driver.find_element(By.CSS_SELECTOR, f'.tpj9w._tab-menu[data-index="{review_index}"]')
                        print(f"리뷰 탭: {review_button.text}")
                        review_button.click()
                        time.sleep(1)
                        
                        # 스크롤을 맨 아래로 내리기
                        last_height = driver.execute_script("return document.body.scrollHeight")
                        while True:
                            driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
                            time.sleep(1)
                            new_height = driver.execute_script("return document.body.scrollHeight")
                            if new_height == last_height:
                                break
                            last_height = new_height

                        # 리뷰 목록 요소 찾기
                        review_list = driver.find_elements(By.CSS_SELECTOR, '#_review_list > li')
                        print(f"총 {len(review_list)}개의 리뷰를 찾았습니다.")
                        
                        # 각 리뷰 요소에 대해 반복
                        for i, review in enumerate(review_list, 1):
                            try:
                                print(f"\n--- 리뷰 {i} ---")
                                
                                # 기본 정보 초기화
                                author = "작성자 정보 없음"
                                review_text = "리뷰 내용 없음"
                                review_image = "리뷰 사진 없음"
                                date = "작성 날짜 없음"
                                
                                # 작성자 정보 추출
                                try:
                                    author_element = review.find_element(By.CSS_SELECTOR, '.pui__NMi-Dp')
                                    author = author_element.text
                                    print(f"작성자: {author}")
                                except:
                                    print("작성자 정보를 찾을 수 없습니다.")
                                
                                # 리뷰 내용 추출 
                                try:
                                    review_text_element = review.find_element(By.CSS_SELECTOR, '.pui__vn15t2 a')
                                    review_text = review_text_element.text
                                    print(f"리뷰 내용: {review_text}")
                                except:
                                    print("리뷰 내용을 찾을 수 없습니다.")
                                
                                # 리뷰 사진 추출 (개선된 부분)
                                try:
                                    # 가장 정확한 선택자부터 시도
                                    img_element = review.find_element(By.CSS_SELECTOR, 'img[alt="방문자리뷰사진"]')
                                    src = img_element.get_attribute('src')
                                    
                                    if src and 'pup-review-phinf.pstatic.net' in src:
                                        review_image = src
                                        print(f"리뷰 사진 URL: {review_image}")
                                    else:
                                        print("리뷰 사진 URL이 유효하지 않습니다.")
                                        
                                except:
                                    # 이미지가 없는 경우 바로 처리
                                    print("리뷰 사진 없음")

                                # 작성 날짜 추출
                                try:
                                    date_elements = review.find_elements(By.CSS_SELECTOR, '.pui__gfuUIT .pui__blind')
                                    date = date_elements[1].text if len(date_elements) > 1 else "날짜 정보 없음"
                                    print(f"작성 날짜: {date}")
                                except:
                                    print("작성 날짜를 찾을 수 없습니다.")
                                
                                # 데이터를 리스트에 추가
                                all_data.append({
                                    '휴게소명': keyword,
                                    '도로명주소': address,
                                    '전화번호': phone,
                                    '리뷰번호': i,
                                    '작성자': author,
                                    '리뷰내용': review_text,
                                    '리뷰사진URL': review_image,
                                    '작성날짜': date,
                                    '수집시간': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                                })
                                
                                print("-" * 50)
                                
                            except Exception as e:
                                print(f"리뷰 {i} 데이터 추출 중 오류 발생: {e}")
                                continue
                                
                    except Exception as e:
                        print(f"리뷰 탭 처리 중 오류: {e}")
                        
                except Exception as e:
                    print(f"entryIframe 처리 중 오류: {e}")
                    
            else:
                print("place_bluelink 클래스를 가진 링크를 찾을 수 없습니다.")
                
        except Exception as e:
            print(f"searchIframe 처리 중 오류: {e}")
            
        # 다음 키워드로 넘어가기 전에 잠시 대기
        time.sleep(1)
        
    except Exception as e:
        print(f"키워드 '{keyword}' 처리 중 오류 발생: {e}")
        continue

# 모든 키워드 처리 완료 후 엑셀로 저장
if all_data:
    df = pd.DataFrame(all_data)
    
    # 현재 시간을 파일명에 포함
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    filename = f'휴게소_리뷰_데이터_{timestamp}.xlsx'
    
    # 엑셀로 저장
    df.to_excel(filename, index=False, engine='openpyxl')
    print(f"\n데이터가 '{filename}' 파일로 저장되었습니다.")
    print(f"총 {len(all_data)}개의 리뷰 데이터가 수집되었습니다.")
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
    

