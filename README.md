# 🛒 OPEN MARKET
>프로젝트 기간 2022.04.25 ~ 2022.05.06 
>
> 팀원: [Mino](https://github.com/Mino777), [Red](https://github.com/cherrishRed) / 리뷰어 :  [엘림](https://github.com/lina0322)

## 목차

- [프로젝트 소개](#프로젝트-소개)
- [키워드](#키워드)
- [🚀 trouble shooting](#🚀trouble-shooting)
    - [STEP 1](#step-1)
    - [STEP 2](#step-2)
    - [STEP 3](#step-3)
    - [STEP 4](#step-4)
- [✏️ 배운 개념](#✏️-배운-개념)


## 프로젝트 소개
* 나만의 물건을 등록해 보세요!
* List 로 Grid 로 편하게 볼 수 있어요!
* 본인이 등록한 상품은 수정, 삭제 할 수 있어요!

|||||
|--|--|--|--|
|<img src="https://i.imgur.com/LnRHu1s.gif">|<img src="https://i.imgur.com/GBlV2lZ.gif">|<img src="https://i.imgur.com/dP72Mqv.gif">|<img src="https://i.imgur.com/gzhv2R9.gif">|


## 개발환경 및 라이브러리

[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-13.3.1-blue)]()

## 키워드
- `Network`
- `URLSession Mock Test`
- `Json Decoding Strategy`
- `XCTestExpection`
- `completionHandler`
- `Escaping Closure`
- `URLSession`
- `Test Double`

## 자세한 고민 보기
[STEP 1 PR](https://github.com/yagom-academy/ios-open-market/pull/137)

[STEP 2 PR](https://github.com/yagom-academy/ios-open-market/pull/146)

[STEP 3 PR](https://github.com/yagom-academy/ios-open-market/pull/155)

[STEP 4 PR](https://github.com/yagom-academy/ios-open-market/pull/165)

## 🚀trouble shooting

### [STEP 1]
 
#### sessionDataTask 의 init 이 deprecated 된 문제 
`🤔문제`
![](https://i.imgur.com/UbpFa0A.png)
```swift
final class StubURLSessionDataTask: URLSessionDataTask {
    var completion: (() -> ())?
    
    override func resume() {
        completion?()
    }
}
```
`URLsessionDataTask` `init` 이 `deprecated` 되어서 `URLSessionDataTask` 를 상속받은 `StubURLSessionDataTask` 를 초기화 해줄 수 없는 문제가 발생했습니다.

`🤗해결`
```swift
protocol URLSessionDataTaskProtocol {
    func resume()
}
```
```swift
final class StubURLSessionDataTask: URLSessionDataTaskProtocol {
    var resumeHandler: () -> Void
    
    init(resumeHandler: @escaping () -> Void) {
        self.resumeHandler = resumeHandler
    }
    
    func resume() {
        resumeHandler()
    }
}
```
`URLSessionDataTaskProtocol` 이라는 것을 생성해서 `StubURLSession` 이 `URLSession` 의 상속을 받는 것이라 아니라
URLSessionDataTaskProtocol 를 채택하도록 만들어 주어서 `URLsessionDataTask`의 `init` 을 사용하지 않도록 하여 문제를 해결했습니다.

#### getter 메서드 네이밍
`🤔문제`
get으로 시작하는 경우 불필요한 단어를 생략하라 라는 규칙을 어겼습니다.
```swift
static func getProductsDetail(id: String) -> EndPoint
```
`🤗해결`
리턴해주는 타입의 이름을 메서드명으로 변경했습니다.
```swift
static func productsList(id: String) -> EndPoint
```

[공식 문서](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CodingGuidelines/Articles/NamingMethods.html)

#### view 의 교체 시기
MainViewController 에 원래 있던 view 가 아니라 커스텀 view 를 사용하였습니다. 
`🤔문제`
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    view = mainView
    }
 }
```
뷰가 로드 되고 나서 `viewDidLoad()` 메서드를 통해서 뷰를 변경해 주었습니다.

`🤗해결`
```swift
override func loadView() {
        super.loadView()
        view = mainView
    }
```
뷰가 로드 될 때 뷰를 바꿔줌으로써 불필요한 view 가 생성되는 것을 막아주었습니다. 

## [STEP 2]
### 🚀 trouble shooting

####  URL Session 취소 기능 구현 
`🤔문제`
cell 의 이미지를 다운 받다가 스크롤이 이동해 이미지를 취소해야 할 경우의 `productImageView.image = nil` 을 넣어서 취소를 구현하였습니다. 
이미지를 다운받는 작업은 비동기적으로 작동하기 때문에 image 의 값을 변경한다고 작업이 멈추지 않아 메모리를 낭비하는 문제가 발생했습니다. 

`🤗해결`
```swift 
override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        productNameLabel.text = ""
        tasks.forEach { task in
            let task = task as? URLSessionDataTask
            if task?.state.rawValue != Constants.completedState {
                task?.cancel()
            }
        }
        tasks.removeAll()
    }
```
셀을 재사용 하는 메서드 내부에 URLSessionDataTask 의 상태를 검사해 다운로드가 완료되지 않은 상태라면 task 를 취소하는 로직을 구현하여 해결하였습니다. 

#### 비대해진 ViewController 
`🤔문제`
데이터를 재가공 하는 일이 늘어남에 따라서 MVC 로직 구조에서 ViewController 가 View 의 일 뿐만 아니라 모든 데이터 로직 구조를 가지고 있어 규모가 커지는 문제가 있었습니다. 
`🤗해결`
리뷰어의 조언으로 데이터를 가공하는 로직을 ViewModel 로 분리하여 뷰로 데이터 가공을 확실히 나누었습니다. 

---

## [STEP 3]
### 🚀 trouble shooting

#### textView keyboard hide
`🤔문제`
textView 작성시에 keyboard가 올라오는 경우 바깥의 뷰를 터치해야 내려가게끔 진행을 하면 범위가 너무 작아 어려움이 있었습니다. 
`🤗해결`
<img src="https://i.imgur.com/4OdU17o.png" width =40%>
키보드에 툴바를 넣어주어서 키보드를 내려주는 버튼을 만들어 주어 문제를 해결하였습니다.

#### 특정한 셀에만 button 을 추가하는 기능
`🤔문제`
<img src="https://i.imgur.com/vU1qrsV.png" width =40%>
imagePicker 를 불러오기 위한 마지막 셀을 만들어 주기 위해 다양한 방법을 시도해 보았습니다.

`시도1`
trailing footer 를 추가해야 겠다고 생각했습니다.
composition layout 에서 footer 를 추가하는 기능이 iOS14 버전부터 사용가능했기 때문에, composition 과 flow layout 의 기능을 섞어서 사용해야 했습니다.

그래도 구현을 해보았지만 스크롤이 될 때 footer 도 같이 나타났다 사라질 것이라는 저희의 예상과 달리 footer 가 고정이 되어서 움직이지 않는 문제가 발생했습니다.

`시도2`
header footer 가 아니라 section 을 나눠 회색 셀을 new section 에 넣으려는 시도르 했습니다. 그러나 NSDiffableDataSourceSectionSnapshot 도 iOS14 버전부터 지원을 하여 iOS13 버전까지 진행하기로 한 이번 프로젝트에 맞지 않는 기술이라고 판단했습니다. 
`🤗해결`
그래서 결국에 같은 셀로 구현을 하고 이미지를 만들어 넣어주었고, last index 인 셀에만 button 을 넣어주어, imagePicker 가 나올 수 있도록 구현했습니다!

#### listView 와 grid View 의 싱크 맞춤
`🤔문제`
listView 에서 grid View 로 이동할 때 가장 위의 셀을 바라보고 있었음에도 스크롤이 되는 현상이 존재했습니다.

`🤗해결`
listView 와 grid View 가 한 화면에 나타나는 셀의 개수가 다르기 때문에 나타나는 문제 였습니다. 
뷰를 이동할 경우 스크롤의 위치는 수동으로 조정해 주도록 코드를 수정하여 해결하였습니다. 

#### muti part form 이미지 받기 
`🤔문제`
서버에서 메세지도 없는 0번 코드 에러를 던져주어서 해당 부

`🤗해결`
이미지의 파일 이름에 .jpg를 붙여주지 않아서 생긴 오류였습니다. 

#### API 제네릭 수정
`🤔문제`
```swift
final class APIProvider<T: Decodable>: Provider {
}
```
APIProvider 객체가 제네릭 타입을 가지고 있어서, 새로운 타입의 Provider 를 사용하려고 할 때마다 APIProvider 를 생성해야 하는 문제가 있었습니다. 

`🤗해결`
Provider가 아닌 내부 메서드가 T를 가지게되면서 외부에서 해당 메서드를 사용할 때 해당 모델로 추론하도록 하여 하나의 APIProvider만 생성하여 쓸 수 있도록 수정하여 문제를 해결 했습니다. 


## [STEP 4]

#### 이미지 용량 제한
`🤔문제`
이미지의 용량을 설정하지 않아서 이미지 마다 받아지는 속도가 달라 화면에 뜨는 시간의 차이가 있었습니다. 

`🤗해결`
화면에 이미지의 사이즈가 크지 않기 때문에 이미지의 사이즈의 크기에 제한을 두어 문제를 해결하였습니다. 
```swift
UIGraphicsBeginImageContextWithOptions(_ size: CGSize, _ opaque: Bool, _ scale: CGFloat)

draw(in rect: CGRect)

UIGraphicsGetImageFromCurrentImageContext() -> UIImage?
```
이미지의 최대 용량 크기를 299999byte로 지정해주고, 해당 이미지의 크기가 최대 용량 크기보다 작아질때까지 while문을 돌려 주면서 해당 메서드들을 통해 비트맵 context를 기반으로 이미지 객체를 얻어와서 필요한 만큼 크기를 조정해주고 다시 그려주어 용량을 줄여주는 방식으로 구현하였습니다.
또한 해당 작업은 무겁다고 생각이 들어서 userInitiated qos 타입으로 global 스레드에서 돌려주었습니다.

#### Data가 업데이트 되었을 때 동기화
`🤔문제`
ViewController의 ViewWillAppear에서 데이터를 리셋해주는 방식으로 동기화를 진행하였습니다. 
하지만 이런 경우에 데이터가 업데이트 되지 않았는데도 API를 요청하는 부분 때문에 비효율적이라고 생각하였습니다.

`🤗해결`
동기화하는 작업을 Post, Patch, Delete 작업이 수행되었을 때만 NotificationCenter에 Post하여 업데이트 해주는 방식으로 구현을 변경해 주어 문제를 해결했습니다. 

<details>
    <summary>✏️ 배운 개념</summary>
<div markdown="1">

## ✏️ 배운 개념
### Unit Test 를 위한 의존성 주입, 프로토콜 활용 
실제 네트워크 통신과 무관한 테스트를 작성하기 위해 TestDouble 을 활용했습니다.
TestDouble 의 활용을 위해 객체 간의 분리를 진행하였고 의존성 주입과 프로토콜을 적극 활용했습니다. 
    
### URL Session을 활용한 네트워크 통신

URLsession 은 싱글톤인 shared 를 가지고 있습니다.
shared 사용하지 않으면 Configuration 을 사용해 커스텀 URLsession 을 만들 수 있습니다. 

<URlsession 에서 사용할 수 있는 task의 종류>
* Data Tasks
NSData를 사용하여 데이터를 보내고 받는다. 짧고 통신이 자주 있을 때 사용한다.
```swift
URLSession.shared.dataTask(with: completionHandler:)
```
* Upload Tasks
데이터를 파일형태로 보낸다. 백그라운드 업로드를 지원한다.
```swift
URLSession.shared.uploadTask(with:from:completionHandler:)
```

* Download Tasks
데이터를 파일형태로 받는다. 백그라운드 다운로드를 지원한다.
```swift
URLSession.shared.downloadTask(with:completionHandler:)
```
> `completionHandler` 부분의 parameter 에는 data, response, error 값이 내려옵니다.
> 기본적으로 `URLSession` 멈추기 때문에 `resume` 을 해줘야 작동합니다.

* Web Socket
```swift
URLSession.shared.webSocketTask(with:)
```
SwiftCopy
RFC 6455 로 지정된 웹소켓 프로토콜을 사용해서 TCP, TLS 로 메세지를 주고 받는다고 한다.

### @escaping closure 및 Result Type
비동기로 메서드가 끝난 이후에 데이터를 전달받기 위해 @escaping closure를 사용하면 된다는 것을 알았습니다.

### Result Type
Result는 제네릭을 이용해 error 가 나는 상황에서 throw 를 사용하지 않고, Success 와 Failure 를 이용해 오류와 성공을 처리해 줄 수 있는 객체 입니다. 
```swift
@frozen enum Result<Success, Failure> where Failure : Error
```
Result Type을 활용해 성공과 실패에 따른 정상적인 결과및 에러를 반환해 줄 수 있도록 했습니다.

### POSTMAN 사용법 
Postman을 활용하여 API를 테스트하고, API에 대한 문서를 확인하며 개발했습니다.
    
### collection View
Collection View 활용방법에 대해 학습했습니다.
    
### modern collection View
diffable dataSource 와 snapshot 의 개념에 대해서 공부하였습니다. 
    

</div>
</details>

<br>

[![top](https://img.shields.io/badge/처음으로-%23000000.svg?&amp;style=for-the-badge&amp;color=green&amp;logo=Acclaim&amp;logoColor=white&amp;)](#목차)

