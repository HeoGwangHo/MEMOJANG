# 메모장 프로젝트
### 주요 기능
**1. 메모 목록보기, 작성하기, 수정하기 기능 구현**<br>
**2. 기본 UI 구성은 TableView + Navigation Controller로 디자인**<br>
**3. 오토 레이아웃으로 디자인하여 여러 아이폰 시리즈 지원**<br>
**4. 데이터베이스로 Realm을 이용**<br>
**5. 메모 삭제 시 해당 Cell을 오른쪽에서 왼쪽으로 스와이프 하여 삭제 가능**<br>
**6. Main화면으로 돌아가고 싶을 때 왼쪽 위의 버튼을 터치하거나 왼쪽에서 오른쪽으로 스와이프 하여 이동 가능**<br>
- 실행화면<br>
 ![ezgif com-video-to-gif (2)](https://user-images.githubusercontent.com/60169777/79417896-47b1cc80-7fee-11ea-9516-8ff1c9e98011.gif)<br>
### Main 화면<br>
**1. 처음 실행 시 데이터베이스어 저장된 메모를 읽어드려 TableView에 보여줌**<br>
 **2. 메모가 저장되어 있으면 제목과 내용을 Cell에 보여줌**<br>
 - 시작화면<br>
 <img align="left" width="224" height="480" alt="스크린샷 2020-04-13 오후 4 59 18" src="https://user-images.githubusercontent.com/60169777/79103748-22338180-7da8-11ea-881a-cd830a9c69b2.png">
 
![ezgif com](https://user-images.githubusercontent.com/60169777/79105928-89ebcb80-7dac-11ea-8a59-0631624772ed.gif)<br>

 ### 메모 작성하기
 **1. 오른쪽 위의 "+"버튼 터치 시 작성하기 화면으로 이동**<br>
 **2. 작성하기 화면으로 이동 시 0.5초 후에 제목 텍스트 필드에 자동으로 포커스**<br>
 **3. 제목의 길이를 12로 고정, 제목을 쓰지 않고 넘어갈 시 오늘 날짜가 자동으로 저장**<br>
 **4. 리턴키 입력 시 내용을 쓸 수 있는 텍스트 뷰로 포커스 이동**<br>
 **5. 키보드 툴바 혹은 제목의 좌, 우 빈공간을 터치 시 키보드 내려감**<br>
 **6. 하단의 "+"버튼 터치 시 Alert를 통해 앨범에서 선택하거나 촬영한 사진을 이미지 뷰에 보여줌**<br>
 **7. 완료 버튼 터치 시 데이터베이스에 저장하고 Main 화면으로 돌아간 뒤 TableView의 Cell 갱신**<br>
 - 메모 작성<br>
 ![ezgif com-video-to-gif](https://user-images.githubusercontent.com/60169777/79417392-f6550d80-7fec-11ea-8db3-b0cd415ccdb5.gif)<br>
 ### 메모 수정하기
 **1. TableView의 Cell 터치 시 해당 Cell의 제목, 내용, 이미지 등을 보여주는 화면으로 이동**<br>
 **2. 변경하고 싶은 부분 터치 시 변경 가능**<br>
 **3. 수정 버튼 터치 시 Alert를 통해 "예" -> 내용이 업데이트되고 Main 화면으로 이동**<br>
 **4. "아니오" -> 변경한 내용은 취소되고 Main 화면으로 이동**<br>
 - 메모 수정<br>
![ezgif com-video-to-gif (1)](https://user-images.githubusercontent.com/60169777/79417614-83986200-7fed-11ea-8d5c-f26928acd044.gif)
