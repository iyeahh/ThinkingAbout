# 🗓 띵커바웃 (Think about)

##### 2023년 10월 3일 → 2023년 10월 23일 (3주)

## 🗒️ 카테고리 별로 나누어 저장하는 메모앱
- 카테고리 별로 메모를 저장
- 메모 작성, 확인, 수정, 삭제 가능
- 오늘 메모는 Today 탭에서 확인
- 다크모드 대응

## 🤓 기술스택
* UIKit
* UI → Storyboard
* CoreData

## ⚽️ 트러블 슈팅

### 👿 트러블
**CoreData에서 지원하지 않는 `Category` 타입 저장하기**

### 😈 해결 방법
💡 코어데이터 내의 엔티티의 속성은 기본적인 타입을 지정할 수 있는데, 커스텀 타입을 엔티티의 속성으로 사용하려면 어떻게 해야할까?

- 코어데이터에서 지원하지 않는 타입을 저장하기 위해서는 `Transformable` 타입을 사용해야 하고, 3가지 요구사항을 적용해야 함
    - 저장하려는 데이터가 NSSecureCoding 프로토콜 준수
        - NSSecureCoding 프로토콜 채택
        - 해당 자료형이 NSSecureCoding 프로토콜을 따르지 않기 때문에 NSString으로 변환하고 인코딩
        - Core Data에서 데이터를 검색 할 때 decodeObject(of: forKey :)를 사용하여 객체를 디코딩
        
        ```swift
        public class Category: NSObject, NSSecureCoding {
            public static var supportsSecureCoding: Bool = true
        
            var type: String?
            var color: UIColor?
            var image: UIImage?
        
            init(type: String? = nil, color: UIColor? = nil, image: UIImage? = nil) {
                self.type = type
                self.color = color
                self.image = image
            }
        
            public func encode(with coder: NSCoder) {
                guard let type = type, let color = color, let image = image else { return }
                coder.encode(type as NSString, forKey: "type")
                coder.encode(color as UIColor, forKey: "color")
                coder.encode(image as UIImage, forKey: "image")
            }
        
            required public convenience init?(coder: NSCoder) {
                let type = coder.decodeObject(of: NSString.self, forKey: "type") as? String
                let color = coder.decodeObject(of: UIColor.self, forKey: "color")
                let image = coder.decodeObject(of: UIImage.self, forKey: "image")
        
                self.init(type: type, color: color, image: image)
            }
        }
        ```
        
    - NSSecureUnarchiveFromDataTransformer subclass를 생성하고 등록
        - 값 변환 프로세스에서 최상위 클래스이므로 allowedTopLevelClasses 배열에 Category 클래스를 추가
        - custom transformer 를 등록하기 위한 메서드
        
        ```swift
        class CategoryTransformer: NSSecureUnarchiveFromDataTransformer {
        
            override class var allowedTopLevelClasses: [AnyClass] {
                return [Category.self]
            }
        
            static func register() {
                let className = String(describing: CategoryTransformer.self)
                let name = NSValueTransformerName(className)
        
                let transformer = CategoryTransformer()
                ValueTransformer.setValueTransformer(transformer, forName: name)
            }
        }
        ```
        
    - 생성한 data transformer 하위 클래스를 Transformable 타입 attribute와 연결   
        ![스크린샷 2023-11-22 오후 2 20 13](https://github.com/iyeahh/ThinkingAbout/assets/120009678/ff931538-2951-4918-b7dd-0b4433cac2eb)


---
       
### 👿 트러블
**반복되는 코어데이터 접근으로 앱의 버벅임 발생**

### 😈 해결 방법
💡 앱의 UI를 그릴 때나 데이터를 가지고 올 때마다 코어데이터를 통해 **디스크**에 저장된 메모를 불러옴   
→ (디스크에 자주 접근함으로써 발생하는) 앱의 버벅임을 줄이려면 어떻게 해야 할까?

- 전체 메모를 읽어오고 또는 메모를 생성 / 수정 / 삭제 할때마다 코어 데이터에 접근하기 보다는,
- `DataManager` 내에 (메모리 내에서 먼저 접근하고 사용할 수 있는)
- `memoList` 배열을 만들어
    - CRUD를 배열(메모리) 내에서 처리하고
    - UI를 그리거나 데이터를 가지고 올 때는 디스크에 접근하는 대신 배열(메모리)에 접근하여 앱의 버벅임을 줄임

     ```swift
     memoDataManager.getMemoListFromCoreData().count
     -> memoDataManager.memoList.count 로 변경
     ```
    
---
### 👿 트러블
**다크모드를 지원하지 않는 컬러의 다크모드 대응**

### 😈 해결 방법
💡 유저 입장에서의 편리한 사용 경험을 제공을 위한 다크모드 대응을 하고 싶은데 어떻게 해야 할까?

- UI 기본컬러는 다크모드를 지원하지만, 커스텀 컬러는 다크모드를 지원하지 않음
    - `Assets`의 `Color Set`에 라이트모드와 다크모드에 색상을 지정하여 대응함
        
        ![스크린샷 2023-11-22 오후 2 42 39](https://github.com/iyeahh/ThinkingAbout/assets/120009678/5b236518-5059-4e00-b64a-6f47dab6ed5c)


        
        ```swift
        // 다크모드일 때 글자색 변경
        textView.textColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
              if traitCollection.userInterfaceStyle == .dark {
                     return UIColor.white
              } else {
                     return UIColor.black
              }
        ```
---
### 👿 트러블
**메모 작성 화면에서 키보드의 높이만큼 저장하기 버튼 올라오게 구현하기**

### 😈 해결 방법
💡 저장하기 버튼이 키보드 높이에 딱 맞게끔 올라오게 하고 싶은데 어떻게 할 수 있을까?

- 코드가 아닌 스토리보드로 버튼의 제약을 주었기 때문에 IBOutlet 으로 제약을 코드에 연결함
- `keyboardWillShow(_:)`  `keyboardWillHide(_:)` 함수에 노티피케이션 설정
- 키보드가 올라올 때 탭바와 키보드의 height을 동적으로 계산하여 해당 높이만큼 제약을 주고,
- 키보드가 내려갈 때 제약을 0으로 주고 자연스럽게 내려가도록 애니메이션을 넣어 뷰를 다시 그림
    
    ```swift
    // 버튼의 위치를 동적으로 변경하기 위한 제약 연결
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
    
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
    
            NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
            guard let tabBar = self.tabBarController?.tabBar else {
                return
            }
            let tabBarHeight = tabBar.frame.size.height
    
            guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
    
            let keyboardHeight = keyboardFrame.size.height
    
            buttonBottomConstraint.constant = keyboardHeight - tabBarHeight
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
            buttonBottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
    }
    ```
---
## ✅ 1.1 업데이트
- **버그 수정** 
[b201ba4](https://github.com/iyeahh/ThinkingAbout/commit/b201ba45df7e9917010459a0f3051ec01801f31e)
    - 카테고리에서 수정하는 화면 진입 시 날짜 랜덤으로 보이는 것 수정
    - 모아보기에서 수정하는 화면 진입 시 카테고리 랜덤으로 보이는 것 수정
    - 미리보기 메모와 본문의 메모가 다른 것 수정
    - 메모 수정 시 카테고리 지정하지 않으면 업무로 지정되는 것 수정

- **delete 안되는 것 수정** 
[c16406b](https://github.com/iyeahh/ThinkingAbout/commit/c16406bff811f4a6a470aa92bc6d11cb2f050a6d)
