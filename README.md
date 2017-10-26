# RxCoreNFC
RxCoreNFC (based on RxSwift)

Basic usage.

```swift
NFCNDEFReaderSession
    .rx
    .create()
    .subscribe { (event) in
    switch event {
        case .next(let messages):
            // handle [NFCNDEFMessage]
            break
        case .error(let error):
            // handle error
            break
        case .completed:
            // never happens
            break
        }
    }
    .disposed(by: disposeBag)
```
