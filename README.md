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
            // handle '[NFCNDEFMessage]'
            break
        case .error(let error):
            // handle error
            break
        case .completed:
            // only happens when 'invalidateAfterFirstRead = true'
            break
        }
    }
    .disposed(by: disposeBag)
```

// TODO: NFCISO15693ReaderSession
