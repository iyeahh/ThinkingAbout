# 🗓 띵커바웃 (Think about) README

##### 2023년 10월 3일 → 2023년 10월 23일

## 🗒️ 카테고리 별로 나누어 저장하는 메모앱
* 여러 카테고리로 저장하고 찾아볼 수 있도록 함

## 🤓 기술스택
* UIKit
* UI -> Storyboard
* CoreData
* UICollecionView
* UITableView

## ⚽️ 트러블 슈팅

### 👿 트러블
* CoreData에서 지원하지 않는 `Category` 타입 저장하기

### 😈 해결 방법
* 코어데이터에서 지원하지 않는 타입을 저장하기 위해서는 `Transformable` 타입을 사용해야 하고, 3가지 요구사항을 적용함
  * 저장하려는 데이터가 NSSecureCoding 프로토콜 준수
  * NSSecureUnarchiveFromDataTransformer subclass를 생성하고 등록
  * 생성한 data transformer 하위 클래스를 Transformable 타입 attribute와 연결
---
### 👿 트러블
* `fetchMemoList()`로 코어데이터에 저장된 메모를 가져오는 과정이 반복되다 보니 앱이 버벅이는 현상 발생함

### 😈 해결 방법
* 코어데이터 내의 메모 데이터 배열을 만들어 접근하도록 하여 버벅임을 줄임
---
### 👿 트러블
* 키보드가 위로 올라오는만큼 저장하기 버튼도 올라오도록 구현

### 😈 해결 방법
* 탭바와 키보드의 높이를 동적으로 계산해 `Notification`으로 저장하기 버튼의 위치를 이동시킴
---
### 👿 트러블
* 다크모드를 지원하지 않는 컬러의 다크모드 대응

### 😈 해결 방법
* `Assets`에서 `Color Set`에 라이트모드와 다크모드에 색상 지정

