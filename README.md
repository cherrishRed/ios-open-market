# ๐ OPEN MARKET
>ํ๋ก์ ํธ ๊ธฐ๊ฐ 2022.04.25 ~ 2022.05.06 
>
> ํ์: [Mino](https://github.com/Mino777), [Red](https://github.com/cherrishRed) / ๋ฆฌ๋ทฐ์ด :  [์๋ฆผ](https://github.com/lina0322)

## ๋ชฉ์ฐจ

- [ํ๋ก์ ํธ ์๊ฐ](#ํ๋ก์ ํธ-์๊ฐ)
- [ํค์๋](#ํค์๋)
- [๐ trouble shooting](#๐trouble-shooting)
    - [STEP 1](#step-1)
    - [STEP 2](#step-2)
    - [STEP 3](#step-3)
    - [STEP 4](#step-4)
- [โ๏ธ ๋ฐฐ์ด ๊ฐ๋](#โ๏ธ-๋ฐฐ์ด-๊ฐ๋)


## ํ๋ก์ ํธ ์๊ฐ
* ๋๋ง์ ๋ฌผ๊ฑด์ ๋ฑ๋กํด ๋ณด์ธ์!
* List ๋ก Grid ๋ก ํธํ๊ฒ ๋ณผ ์ ์์ด์!
* ๋ณธ์ธ์ด ๋ฑ๋กํ ์ํ์ ์์ , ์ญ์  ํ  ์ ์์ด์!

|||||
|--|--|--|--|
|<img src="https://i.imgur.com/LnRHu1s.gif">|<img src="https://i.imgur.com/GBlV2lZ.gif">|<img src="https://i.imgur.com/dP72Mqv.gif">|<img src="https://i.imgur.com/gzhv2R9.gif">|


## ๊ฐ๋ฐํ๊ฒฝ ๋ฐ ๋ผ์ด๋ธ๋ฌ๋ฆฌ

[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-13.3.1-blue)]()

## ํค์๋
- `Network`
- `URLSession Mock Test`
- `Json Decoding Strategy`
- `XCTestExpection`
- `completionHandler`
- `Escaping Closure`
- `URLSession`
- `Test Double`

## ์์ธํ ๊ณ ๋ฏผ ๋ณด๊ธฐ
[STEP 1 PR](https://github.com/yagom-academy/ios-open-market/pull/137)

[STEP 2 PR](https://github.com/yagom-academy/ios-open-market/pull/146)

[STEP 3 PR](https://github.com/yagom-academy/ios-open-market/pull/155)

[STEP 4 PR](https://github.com/yagom-academy/ios-open-market/pull/165)

## ๐trouble shooting

### [STEP 1]
 
#### sessionDataTask ์ init ์ด deprecated ๋ ๋ฌธ์  
`๐ค๋ฌธ์ `
![](https://i.imgur.com/UbpFa0A.png)
```swift
final class StubURLSessionDataTask: URLSessionDataTask {
    var completion: (() -> ())?
    
    override func resume() {
        completion?()
    }
}
```
`URLsessionDataTask` `init` ์ด `deprecated` ๋์ด์ `URLSessionDataTask` ๋ฅผ ์์๋ฐ์ `StubURLSessionDataTask` ๋ฅผ ์ด๊ธฐํ ํด์ค ์ ์๋ ๋ฌธ์ ๊ฐ ๋ฐ์ํ์ต๋๋ค.

`๐คํด๊ฒฐ`
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
`URLSessionDataTaskProtocol` ์ด๋ผ๋ ๊ฒ์ ์์ฑํด์ `StubURLSession` ์ด `URLSession` ์ ์์์ ๋ฐ๋ ๊ฒ์ด๋ผ ์๋๋ผ
URLSessionDataTaskProtocol ๋ฅผ ์ฑํํ๋๋ก ๋ง๋ค์ด ์ฃผ์ด์ `URLsessionDataTask`์ `init` ์ ์ฌ์ฉํ์ง ์๋๋ก ํ์ฌ ๋ฌธ์ ๋ฅผ ํด๊ฒฐํ์ต๋๋ค.

#### getter ๋ฉ์๋ ๋ค์ด๋ฐ
`๐ค๋ฌธ์ `
get์ผ๋ก ์์ํ๋ ๊ฒฝ์ฐ ๋ถํ์ํ ๋จ์ด๋ฅผ ์๋ตํ๋ผ ๋ผ๋ ๊ท์น์ ์ด๊ฒผ์ต๋๋ค.
```swift
static func getProductsDetail(id: String) -> EndPoint
```
`๐คํด๊ฒฐ`
๋ฆฌํดํด์ฃผ๋ ํ์์ ์ด๋ฆ์ ๋ฉ์๋๋ช์ผ๋ก ๋ณ๊ฒฝํ์ต๋๋ค.
```swift
static func productsList(id: String) -> EndPoint
```

[๊ณต์ ๋ฌธ์](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CodingGuidelines/Articles/NamingMethods.html)

#### view ์ ๊ต์ฒด ์๊ธฐ
MainViewController ์ ์๋ ์๋ view ๊ฐ ์๋๋ผ ์ปค์คํ view ๋ฅผ ์ฌ์ฉํ์์ต๋๋ค. 
`๐ค๋ฌธ์ `
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    view = mainView
    }
 }
```
๋ทฐ๊ฐ ๋ก๋ ๋๊ณ  ๋์ `viewDidLoad()` ๋ฉ์๋๋ฅผ ํตํด์ ๋ทฐ๋ฅผ ๋ณ๊ฒฝํด ์ฃผ์์ต๋๋ค.

`๐คํด๊ฒฐ`
```swift
override func loadView() {
        super.loadView()
        view = mainView
    }
```
๋ทฐ๊ฐ ๋ก๋ ๋  ๋ ๋ทฐ๋ฅผ ๋ฐ๊ฟ์ค์ผ๋ก์จ ๋ถํ์ํ view ๊ฐ ์์ฑ๋๋ ๊ฒ์ ๋ง์์ฃผ์์ต๋๋ค. 

## [STEP 2]
### ๐ trouble shooting

####  URL Session ์ทจ์ ๊ธฐ๋ฅ ๊ตฌํ 
`๐ค๋ฌธ์ `
cell ์ ์ด๋ฏธ์ง๋ฅผ ๋ค์ด ๋ฐ๋ค๊ฐ ์คํฌ๋กค์ด ์ด๋ํด ์ด๋ฏธ์ง๋ฅผ ์ทจ์ํด์ผ ํ  ๊ฒฝ์ฐ์ `productImageView.image = nil` ์ ๋ฃ์ด์ ์ทจ์๋ฅผ ๊ตฌํํ์์ต๋๋ค. 
์ด๋ฏธ์ง๋ฅผ ๋ค์ด๋ฐ๋ ์์์ ๋น๋๊ธฐ์ ์ผ๋ก ์๋ํ๊ธฐ ๋๋ฌธ์ image ์ ๊ฐ์ ๋ณ๊ฒฝํ๋ค๊ณ  ์์์ด ๋ฉ์ถ์ง ์์ ๋ฉ๋ชจ๋ฆฌ๋ฅผ ๋ญ๋นํ๋ ๋ฌธ์ ๊ฐ ๋ฐ์ํ์ต๋๋ค. 

`๐คํด๊ฒฐ`
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
์์ ์ฌ์ฌ์ฉ ํ๋ ๋ฉ์๋ ๋ด๋ถ์ URLSessionDataTask ์ ์ํ๋ฅผ ๊ฒ์ฌํด ๋ค์ด๋ก๋๊ฐ ์๋ฃ๋์ง ์์ ์ํ๋ผ๋ฉด task ๋ฅผ ์ทจ์ํ๋ ๋ก์ง์ ๊ตฌํํ์ฌ ํด๊ฒฐํ์์ต๋๋ค. 

#### ๋น๋ํด์ง ViewController 
`๐ค๋ฌธ์ `
๋ฐ์ดํฐ๋ฅผ ์ฌ๊ฐ๊ณต ํ๋ ์ผ์ด ๋์ด๋จ์ ๋ฐ๋ผ์ MVC ๋ก์ง ๊ตฌ์กฐ์์ ViewController ๊ฐ View ์ ์ผ ๋ฟ๋ง ์๋๋ผ ๋ชจ๋  ๋ฐ์ดํฐ ๋ก์ง ๊ตฌ์กฐ๋ฅผ ๊ฐ์ง๊ณ  ์์ด ๊ท๋ชจ๊ฐ ์ปค์ง๋ ๋ฌธ์ ๊ฐ ์์์ต๋๋ค. 
`๐คํด๊ฒฐ`
๋ฆฌ๋ทฐ์ด์ ์กฐ์ธ์ผ๋ก ๋ฐ์ดํฐ๋ฅผ ๊ฐ๊ณตํ๋ ๋ก์ง์ ViewModel ๋ก ๋ถ๋ฆฌํ์ฌ ๋ทฐ๋ก ๋ฐ์ดํฐ ๊ฐ๊ณต์ ํ์คํ ๋๋์์ต๋๋ค. 

---

## [STEP 3]
### ๐ trouble shooting

#### textView keyboard hide
`๐ค๋ฌธ์ `
textView ์์ฑ์์ keyboard๊ฐ ์ฌ๋ผ์ค๋ ๊ฒฝ์ฐ ๋ฐ๊นฅ์ ๋ทฐ๋ฅผ ํฐ์นํด์ผ ๋ด๋ ค๊ฐ๊ฒ๋ ์งํ์ ํ๋ฉด ๋ฒ์๊ฐ ๋๋ฌด ์์ ์ด๋ ค์์ด ์์์ต๋๋ค. 
`๐คํด๊ฒฐ`
<img src="https://i.imgur.com/4OdU17o.png" width =40%>
ํค๋ณด๋์ ํด๋ฐ๋ฅผ ๋ฃ์ด์ฃผ์ด์ ํค๋ณด๋๋ฅผ ๋ด๋ ค์ฃผ๋ ๋ฒํผ์ ๋ง๋ค์ด ์ฃผ์ด ๋ฌธ์ ๋ฅผ ํด๊ฒฐํ์์ต๋๋ค.

#### ํน์ ํ ์์๋ง button ์ ์ถ๊ฐํ๋ ๊ธฐ๋ฅ
`๐ค๋ฌธ์ `
<img src="https://i.imgur.com/vU1qrsV.png" width =40%>
imagePicker ๋ฅผ ๋ถ๋ฌ์ค๊ธฐ ์ํ ๋ง์ง๋ง ์์ ๋ง๋ค์ด ์ฃผ๊ธฐ ์ํด ๋ค์ํ ๋ฐฉ๋ฒ์ ์๋ํด ๋ณด์์ต๋๋ค.

`์๋1`
trailing footer ๋ฅผ ์ถ๊ฐํด์ผ ๊ฒ ๋ค๊ณ  ์๊ฐํ์ต๋๋ค.
composition layout ์์ footer ๋ฅผ ์ถ๊ฐํ๋ ๊ธฐ๋ฅ์ด iOS14 ๋ฒ์ ๋ถํฐ ์ฌ์ฉ๊ฐ๋ฅํ๊ธฐ ๋๋ฌธ์, composition ๊ณผ flow layout ์ ๊ธฐ๋ฅ์ ์์ด์ ์ฌ์ฉํด์ผ ํ์ต๋๋ค.

๊ทธ๋๋ ๊ตฌํ์ ํด๋ณด์์ง๋ง ์คํฌ๋กค์ด ๋  ๋ footer ๋ ๊ฐ์ด ๋ํ๋ฌ๋ค ์ฌ๋ผ์ง ๊ฒ์ด๋ผ๋ ์ ํฌ์ ์์๊ณผ ๋ฌ๋ฆฌ footer ๊ฐ ๊ณ ์ ์ด ๋์ด์ ์์ง์ด์ง ์๋ ๋ฌธ์ ๊ฐ ๋ฐ์ํ์ต๋๋ค.

`์๋2`
header footer ๊ฐ ์๋๋ผ section ์ ๋๋  ํ์ ์์ new section ์ ๋ฃ์ผ๋ ค๋ ์๋๋ฅด ํ์ต๋๋ค. ๊ทธ๋ฌ๋ NSDiffableDataSourceSectionSnapshot ๋ iOS14 ๋ฒ์ ๋ถํฐ ์ง์์ ํ์ฌ iOS13 ๋ฒ์ ๊น์ง ์งํํ๊ธฐ๋ก ํ ์ด๋ฒ ํ๋ก์ ํธ์ ๋ง์ง ์๋ ๊ธฐ์ ์ด๋ผ๊ณ  ํ๋จํ์ต๋๋ค. 
`๐คํด๊ฒฐ`
๊ทธ๋์ ๊ฒฐ๊ตญ์ ๊ฐ์ ์๋ก ๊ตฌํ์ ํ๊ณ  ์ด๋ฏธ์ง๋ฅผ ๋ง๋ค์ด ๋ฃ์ด์ฃผ์๊ณ , last index ์ธ ์์๋ง button ์ ๋ฃ์ด์ฃผ์ด, imagePicker ๊ฐ ๋์ฌ ์ ์๋๋ก ๊ตฌํํ์ต๋๋ค!

#### listView ์ grid View ์ ์ฑํฌ ๋ง์ถค
`๐ค๋ฌธ์ `
listView ์์ grid View ๋ก ์ด๋ํ  ๋ ๊ฐ์ฅ ์์ ์์ ๋ฐ๋ผ๋ณด๊ณ  ์์์์๋ ์คํฌ๋กค์ด ๋๋ ํ์์ด ์กด์ฌํ์ต๋๋ค.

`๐คํด๊ฒฐ`
listView ์ grid View ๊ฐ ํ ํ๋ฉด์ ๋ํ๋๋ ์์ ๊ฐ์๊ฐ ๋ค๋ฅด๊ธฐ ๋๋ฌธ์ ๋ํ๋๋ ๋ฌธ์  ์์ต๋๋ค. 
๋ทฐ๋ฅผ ์ด๋ํ  ๊ฒฝ์ฐ ์คํฌ๋กค์ ์์น๋ ์๋์ผ๋ก ์กฐ์ ํด ์ฃผ๋๋ก ์ฝ๋๋ฅผ ์์ ํ์ฌ ํด๊ฒฐํ์์ต๋๋ค. 

#### muti part form ์ด๋ฏธ์ง ๋ฐ๊ธฐ 
`๐ค๋ฌธ์ `
์๋ฒ์์ ๋ฉ์ธ์ง๋ ์๋ 0๋ฒ ์ฝ๋ ์๋ฌ๋ฅผ ๋์ ธ์ฃผ์ด์ ํด๋น ๋ถ

`๐คํด๊ฒฐ`
์ด๋ฏธ์ง์ ํ์ผ ์ด๋ฆ์ .jpg๋ฅผ ๋ถ์ฌ์ฃผ์ง ์์์ ์๊ธด ์ค๋ฅ์์ต๋๋ค. 

#### API ์ ๋ค๋ฆญ ์์ 
`๐ค๋ฌธ์ `
```swift
final class APIProvider<T: Decodable>: Provider {
}
```
APIProvider ๊ฐ์ฒด๊ฐ ์ ๋ค๋ฆญ ํ์์ ๊ฐ์ง๊ณ  ์์ด์, ์๋ก์ด ํ์์ Provider ๋ฅผ ์ฌ์ฉํ๋ ค๊ณ  ํ  ๋๋ง๋ค APIProvider ๋ฅผ ์์ฑํด์ผ ํ๋ ๋ฌธ์ ๊ฐ ์์์ต๋๋ค. 

`๐คํด๊ฒฐ`
Provider๊ฐ ์๋ ๋ด๋ถ ๋ฉ์๋๊ฐ T๋ฅผ ๊ฐ์ง๊ฒ๋๋ฉด์ ์ธ๋ถ์์ ํด๋น ๋ฉ์๋๋ฅผ ์ฌ์ฉํ  ๋ ํด๋น ๋ชจ๋ธ๋ก ์ถ๋ก ํ๋๋ก ํ์ฌ ํ๋์ APIProvider๋ง ์์ฑํ์ฌ ์ธ ์ ์๋๋ก ์์ ํ์ฌ ๋ฌธ์ ๋ฅผ ํด๊ฒฐ ํ์ต๋๋ค. 


## [STEP 4]

#### ์ด๋ฏธ์ง ์ฉ๋ ์ ํ
`๐ค๋ฌธ์ `
์ด๋ฏธ์ง์ ์ฉ๋์ ์ค์ ํ์ง ์์์ ์ด๋ฏธ์ง ๋ง๋ค ๋ฐ์์ง๋ ์๋๊ฐ ๋ฌ๋ผ ํ๋ฉด์ ๋จ๋ ์๊ฐ์ ์ฐจ์ด๊ฐ ์์์ต๋๋ค. 

`๐คํด๊ฒฐ`
ํ๋ฉด์ ์ด๋ฏธ์ง์ ์ฌ์ด์ฆ๊ฐ ํฌ์ง ์๊ธฐ ๋๋ฌธ์ ์ด๋ฏธ์ง์ ์ฌ์ด์ฆ์ ํฌ๊ธฐ์ ์ ํ์ ๋์ด ๋ฌธ์ ๋ฅผ ํด๊ฒฐํ์์ต๋๋ค. 
```swift
UIGraphicsBeginImageContextWithOptions(_ size: CGSize, _ opaque: Bool, _ scale: CGFloat)

draw(in rect: CGRect)

UIGraphicsGetImageFromCurrentImageContext() -> UIImage?
```
์ด๋ฏธ์ง์ ์ต๋ ์ฉ๋ ํฌ๊ธฐ๋ฅผ 299999byte๋ก ์ง์ ํด์ฃผ๊ณ , ํด๋น ์ด๋ฏธ์ง์ ํฌ๊ธฐ๊ฐ ์ต๋ ์ฉ๋ ํฌ๊ธฐ๋ณด๋ค ์์์ง๋๊น์ง while๋ฌธ์ ๋๋ ค ์ฃผ๋ฉด์ ํด๋น ๋ฉ์๋๋ค์ ํตํด ๋นํธ๋งต context๋ฅผ ๊ธฐ๋ฐ์ผ๋ก ์ด๋ฏธ์ง ๊ฐ์ฒด๋ฅผ ์ป์ด์์ ํ์ํ ๋งํผ ํฌ๊ธฐ๋ฅผ ์กฐ์ ํด์ฃผ๊ณ  ๋ค์ ๊ทธ๋ ค์ฃผ์ด ์ฉ๋์ ์ค์ฌ์ฃผ๋ ๋ฐฉ์์ผ๋ก ๊ตฌํํ์์ต๋๋ค.
๋ํ ํด๋น ์์์ ๋ฌด๊ฒ๋ค๊ณ  ์๊ฐ์ด ๋ค์ด์ userInitiated qos ํ์์ผ๋ก global ์ค๋ ๋์์ ๋๋ ค์ฃผ์์ต๋๋ค.

#### Data๊ฐ ์๋ฐ์ดํธ ๋์์ ๋ ๋๊ธฐํ
`๐ค๋ฌธ์ `
ViewController์ ViewWillAppear์์ ๋ฐ์ดํฐ๋ฅผ ๋ฆฌ์ํด์ฃผ๋ ๋ฐฉ์์ผ๋ก ๋๊ธฐํ๋ฅผ ์งํํ์์ต๋๋ค. 
ํ์ง๋ง ์ด๋ฐ ๊ฒฝ์ฐ์ ๋ฐ์ดํฐ๊ฐ ์๋ฐ์ดํธ ๋์ง ์์๋๋ฐ๋ API๋ฅผ ์์ฒญํ๋ ๋ถ๋ถ ๋๋ฌธ์ ๋นํจ์จ์ ์ด๋ผ๊ณ  ์๊ฐํ์์ต๋๋ค.

`๐คํด๊ฒฐ`
๋๊ธฐํํ๋ ์์์ Post, Patch, Delete ์์์ด ์ํ๋์์ ๋๋ง NotificationCenter์ Postํ์ฌ ์๋ฐ์ดํธ ํด์ฃผ๋ ๋ฐฉ์์ผ๋ก ๊ตฌํ์ ๋ณ๊ฒฝํด ์ฃผ์ด ๋ฌธ์ ๋ฅผ ํด๊ฒฐํ์ต๋๋ค. 

<details>
    <summary>โ๏ธ ๋ฐฐ์ด ๊ฐ๋</summary>
<div markdown="1">

## โ๏ธ ๋ฐฐ์ด ๊ฐ๋
### Unit Test ๋ฅผ ์ํ ์์กด์ฑ ์ฃผ์, ํ๋กํ ์ฝ ํ์ฉ 
์ค์  ๋คํธ์ํฌ ํต์ ๊ณผ ๋ฌด๊ดํ ํ์คํธ๋ฅผ ์์ฑํ๊ธฐ ์ํด TestDouble ์ ํ์ฉํ์ต๋๋ค.
TestDouble ์ ํ์ฉ์ ์ํด ๊ฐ์ฒด ๊ฐ์ ๋ถ๋ฆฌ๋ฅผ ์งํํ์๊ณ  ์์กด์ฑ ์ฃผ์๊ณผ ํ๋กํ ์ฝ์ ์ ๊ทน ํ์ฉํ์ต๋๋ค. 
    
### URL Session์ ํ์ฉํ ๋คํธ์ํฌ ํต์ 

URLsession ์ ์ฑ๊ธํค์ธ shared ๋ฅผ ๊ฐ์ง๊ณ  ์์ต๋๋ค.
shared ์ฌ์ฉํ์ง ์์ผ๋ฉด Configuration ์ ์ฌ์ฉํด ์ปค์คํ URLsession ์ ๋ง๋ค ์ ์์ต๋๋ค. 

<URlsession ์์ ์ฌ์ฉํ  ์ ์๋ task์ ์ข๋ฅ>
* Data Tasks
NSData๋ฅผ ์ฌ์ฉํ์ฌ ๋ฐ์ดํฐ๋ฅผ ๋ณด๋ด๊ณ  ๋ฐ๋๋ค. ์งง๊ณ  ํต์ ์ด ์์ฃผ ์์ ๋ ์ฌ์ฉํ๋ค.
```swift
URLSession.shared.dataTask(with: completionHandler:)
```
* Upload Tasks
๋ฐ์ดํฐ๋ฅผ ํ์ผํํ๋ก ๋ณด๋ธ๋ค. ๋ฐฑ๊ทธ๋ผ์ด๋ ์๋ก๋๋ฅผ ์ง์ํ๋ค.
```swift
URLSession.shared.uploadTask(with:from:completionHandler:)
```

* Download Tasks
๋ฐ์ดํฐ๋ฅผ ํ์ผํํ๋ก ๋ฐ๋๋ค. ๋ฐฑ๊ทธ๋ผ์ด๋ ๋ค์ด๋ก๋๋ฅผ ์ง์ํ๋ค.
```swift
URLSession.shared.downloadTask(with:completionHandler:)
```
> `completionHandler` ๋ถ๋ถ์ parameter ์๋ data, response, error ๊ฐ์ด ๋ด๋ ค์ต๋๋ค.
> ๊ธฐ๋ณธ์ ์ผ๋ก `URLSession` ๋ฉ์ถ๊ธฐ ๋๋ฌธ์ `resume` ์ ํด์ค์ผ ์๋ํฉ๋๋ค.

* Web Socket
```swift
URLSession.shared.webSocketTask(with:)
```
SwiftCopy
RFC 6455 ๋ก ์ง์ ๋ ์น์์ผ ํ๋กํ ์ฝ์ ์ฌ์ฉํด์ TCP, TLS ๋ก ๋ฉ์ธ์ง๋ฅผ ์ฃผ๊ณ  ๋ฐ๋๋ค๊ณ  ํ๋ค.

### @escaping closure ๋ฐ Result Type
๋น๋๊ธฐ๋ก ๋ฉ์๋๊ฐ ๋๋ ์ดํ์ ๋ฐ์ดํฐ๋ฅผ ์ ๋ฌ๋ฐ๊ธฐ ์ํด @escaping closure๋ฅผ ์ฌ์ฉํ๋ฉด ๋๋ค๋ ๊ฒ์ ์์์ต๋๋ค.

### Result Type
Result๋ ์ ๋ค๋ฆญ์ ์ด์ฉํด error ๊ฐ ๋๋ ์ํฉ์์ throw ๋ฅผ ์ฌ์ฉํ์ง ์๊ณ , Success ์ Failure ๋ฅผ ์ด์ฉํด ์ค๋ฅ์ ์ฑ๊ณต์ ์ฒ๋ฆฌํด ์ค ์ ์๋ ๊ฐ์ฒด ์๋๋ค. 
```swift
@frozen enum Result<Success, Failure> where Failure : Error
```
Result Type์ ํ์ฉํด ์ฑ๊ณต๊ณผ ์คํจ์ ๋ฐ๋ฅธ ์ ์์ ์ธ ๊ฒฐ๊ณผ๋ฐ ์๋ฌ๋ฅผ ๋ฐํํด ์ค ์ ์๋๋ก ํ์ต๋๋ค.

### POSTMAN ์ฌ์ฉ๋ฒ 
Postman์ ํ์ฉํ์ฌ API๋ฅผ ํ์คํธํ๊ณ , API์ ๋ํ ๋ฌธ์๋ฅผ ํ์ธํ๋ฉฐ ๊ฐ๋ฐํ์ต๋๋ค.
    
### collection View
Collection View ํ์ฉ๋ฐฉ๋ฒ์ ๋ํด ํ์ตํ์ต๋๋ค.
    
### modern collection View
diffable dataSource ์ snapshot ์ ๊ฐ๋์ ๋ํด์ ๊ณต๋ถํ์์ต๋๋ค. 
    

</div>
</details>

<br>

[![top](https://img.shields.io/badge/์ฒ์์ผ๋ก-%23000000.svg?&amp;style=for-the-badge&amp;color=green&amp;logo=Acclaim&amp;logoColor=white&amp;)](#๋ชฉ์ฐจ)

