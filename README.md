# 🗓 띵커바웃 (Think about)

##### 2023년 10월 3일 → 2023년 10월 23일 (3주)

## 🗒️ 카테고리 별로 나누어 저장하는 메모앱
- 카테고리 별로 메모를 저장
- 메모 작성, 확인, 수정, 삭제 가능
- 오늘 메모는 Today 탭에서 확인
- 다크모드 대응

## 🤓 기술스택
* UIKit
* UI - Storyboard
* CoreData
* MVC → MVVM 리팩토링

## 💡 문제 해결
       
### ❓ 문제
**반복되는 코어데이터 접근으로 앱의 버벅임 발생 문제 (메모리 캐시 활용을 통해 (반복적인 코어데이터 사용 빈도를 줄여) 앱의 버벅임 줄이기)**
### ❕ 해결 방법
💡 **문제 상황:** **앱의 UI를 그릴 때나 데이터를 가지고 올 때마다, 반복적으로 코어데이터를 통해 디스크에 저장된 메모를 불러옴**
               **→ (디스크에 자주 접근함으로써 발생하는) 앱의 버벅임을 줄이려면 어떻게 해야 할까? 
                     (코어데이터에 커스텀 데이터 타입 등 추가적인 데이터 저장으로 인한 버벅임 문제 해결)**

- 전체 메모를 읽어오고 또는 메모를 생성 / 수정 / 삭제 할때마다 코어 데이터에 접근하기 보다는,
- `DataManager` 내에 (메모리 내에서 먼저 접근하고 사용할 수 있는) **메모리 캐시**(`memoList` 배열)를 만들어
    - CRUD를 **메모리 캐시**(데이터 관리 배열) 내에서 처리하고
    - UI를 그리거나 단순하게 데이터를 가지고 올 때는 디스크에 접근하는 대신 메모리 캐시(배열)에 접근하여 앱의 버벅임을 줄임
    
    (예시) 코어데이터 직접 접근 → 메모리 캐시(배열)에 접근
    
    ```swift
    수정전 -> memoDataManager.getMemoListFromCoreData().count (코어데이터 접근)
    수정후 -> memoDataManager.memoList.count 로 변경            (메모리 캐시 접근)
    ```
    
    (예시) 데이터 삭제시, 코어데이터 직접 접근 → 배열(메모리 캐시)에 먼저 처리 후,  코어데이터에 후 처리
    
    ```swift
    수정전)
    func deleteMemo(_ memo: MemoData?, at index: Int) {
         //.....
    
         mainContext.delete(deletingMemo)          // 코어데이터에 직접 접근 삭제
         saveContext()
    }
    
    수정후)
    func deleteMemo(_ memo: MemoData?, at index: Int) {
         //.....
    
         memoList.remove(at: index)                // 메모리 캐시 내에서 삭제 후
         mainContext.delete(deletingMemo)          // 코어데이터에 직접 접근 삭제
         saveContext()
    }
    ```
    
---

### ❓ 문제
**기본 MVC에서 데이터 관리 계층(Layer)의 분리와 MVVM으로 추가적인 리팩토링 (객체지향 관점, 향후 유지보수를 고려한 설계)**

### ❕ 해결 방법

💡 **문제 상황:** **기본 MVC 아키텍처 구조에서, 각 뷰컨트롤러가 코어데이터와 직접 커뮤니케이션을 하고, 수많은 로직을 보유함으로
                 비대해진 뷰컨트롤러가 되었음. 또한 비효율적인 데이터 관리가 이루어짐.**

- **MVC** **기존구조** - 각 뷰컨트롤러에서 코어데이터에 직접 접근하는 CRUD 로직보유로 인한 데이터 관리 어려움과 비대해진 뷰컨트롤러
- 코어데이터와 커뮤니케이션하는 **데이터 관리 객체**를 중간에 추가해서, 로직을 분리하고 효율적인 데이터를 관리하도록 구조를 변경
- 데이터 부분 로직을 따로 분리해서 데이터 관리 객체의 역할을 분리시켜 보다 단순한 뷰컨트롤러의 구조를 유지시켰음
<img width="486" alt="스크린샷 2024-01-10 오후 1 43 44" src="https://github.com/iyeahh/ThinkingAbout/assets/120009678/fba3ff8f-f89b-4b19-a9e4-c9d8dececfc6">
<img width="493" alt="스크린샷 2024-01-10 오후 1 43 49" src="https://github.com/iyeahh/ThinkingAbout/assets/120009678/99f934dc-f101-4fed-a8d5-cc57f3ea4492">

---
### ❓ 문제
**기존의 MVC프로젝트를 MVVM으로 리팩토링 (향후 유지보수 및 테스트를 고려한 설계로 리팩토링)**

### ❕ 해결 방법
💡 **문제 상황:** **여전히 비대한 뷰컨트롤러에서, 향후 유지보수를 고려해 보다 효율적인 프로젝트 구조를 고민**

- **MVVM** **아키텍처** - 여전히 많은 로직이 뷰컨트롤러에서 이루어지고 있다는 점에서 벗어나 뷰모델(ViewModel)을 도입하여 로직에 대한 완전한 분리를 결정
- MVC에서는 사실상 View와 Controller가 합쳐서, 비대한 Controller(뷰컨트롤러)를 유지했었지만 뷰모델을 중간 계층에 삽입하여 로직을 분리
- 비대한 뷰컨트롤러에서 이제는 보다 심플한 뷰(뷰컨트롤러)를 유지할 수 있었고, 로직을 뷰모델에서 관리해서 향후 유지보수 관점에서 보다 효율적인 프로젝트 관리가 가능해졌음
<img width="534" alt="스크린샷 2024-01-10 오후 1 44 52" src="https://github.com/iyeahh/ThinkingAbout/assets/120009678/6af3ff48-3219-4e16-a467-14695d3ddbc8">

---

### ❓ 문제
**CoreData에서 기본으로 지원하지 않는 커스텀 타입 저장하기 (커스텀 데이터 타입과 CoreData 활용 문제)**

### ❕ 해결 방법
💡 **문제 상황**: **코어데이터 내의 엔티티의 속성은 스위프트의 Basic(기본) 타입을 지정할 수 있는데, 커스텀 타입을 엔티티의 속성으로 사용하려면 어떻게 해야할까?**

- 코어데이터에서 지원하지 않는 타입을 저장하기 위해서는 `Transformable` 타입을 사용해야 하고, 3가지 요구사항을 적용해야 함
    - 저장하려는 데이터가 NSSecureCoding 프로토콜 준수해야만 함
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
        ![스크린샷 2023-11-22 오후 2 20 13](https://github.com/iyeahh/ThinkingAbout/assets/120009678/64a9fec8-f567-43f7-9518-8e079fae08af)


---

### ❓ 문제
**유지보수를 고려한 디자인/테마 등의 파일 관리 (확장파일 생성과 효율적인 관리)**

### ❕ 해결 방법
💡 **문제상황:** **혹시나 향후 유지보수 등으로 인해 디자인/테마 등의 변경이 일어났을때를 대비해, 디자인적인 요소를 어떻게 리팩토링하기 쉽게**
               **관리할 수 있을까?**

- 확장(extension)을 통한 네임스페이스 지정과 네임스페이스에서 선언한 구조체를 다시 하위에 선언해서 언제든지 새로운 디자인/테마 변경 가능하도록 관리

```swift
extension UIImage {
    static let mainIcon = MainIconTheme()   // 선언위한 구조체만 교체하면 됨
    //...
}

struct MainIconTheme {
    let all: UIImage = UIImage(systemName: "list.clipboard")!
    let work: UIImage = UIImage(systemName: "text.book.closed")!
    let music: UIImage = UIImage(systemName: "beats.headphones")!
    let travel: UIImage = UIImage(named: "airplane")!
    let study: UIImage = UIImage(named: "edit")!
    let stuff: UIImage = UIImage(systemName: "house")!
    let hobby: UIImage = UIImage(systemName: "paintpalette")!
    let shopping: UIImage = UIImage(systemName: "cart")!
}
```
---

### ❓ 문제
**메모 작성 화면에서 키보드의 높이만큼 저장하기 버튼 올라오게 구현하기 (키보드에 따른 애니메이션 적용)**

### ❕ 해결 방법
💡 **문제상황:** **저장하기 버튼이 키보드 높이에 딱 맞게끔 올라오게 하고 싶은데 어떻게 할 수 있을까?**

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

### ❓ 문제
**다크모드를 지원하지 않는 컬러의 다크모드 대응 (다크모드 지원)**

### ❕ 해결 방법
💡 **문제 상황: 유저 입장에서의 편리한 사용 경험을 제공을 위한 다크모드 대응을 하고 싶은데 어떻게 해야 할까?**

- UI 기본컬러는 다크모드를 지원하지만, 커스텀 컬러는 다크모드를 지원하지 않음
    - `Assets`의 `Color Set`에 라이트모드와 다크모드에 색상을 지정하여 대응함
        ![스크린샷 2023-11-22 오후 2 42 39](https://github.com/iyeahh/ThinkingAbout/assets/120009678/b4ca6e11-a936-4aa3-85f2-9f93918a1586)


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

## ✅ 1.1 업데이트
- **버그 수정** [b201ba4](https://github.com/iyeahh/ThinkingAbout/commit/b201ba45df7e9917010459a0f3051ec01801f31e)
    - 카테고리에서 수정하는 화면 진입 시 날짜 랜덤으로 보이는 것 수정
    - 모아보기에서 수정하는 화면 진입 시 카테고리 랜덤으로 보이는 것 수정
    - 미리보기 메모와 본문의 메모가 다른 것 수정
    - 메모 수정 시 카테고리 지정하지 않으면 업무로 지정되는 것 수정

- **delete 안되는 것 수정** [c16406b](https://github.com/iyeahh/ThinkingAbout/commit/c16406bff811f4a6a470aa92bc6d11cb2f050a6d)
