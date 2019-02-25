# RxCoreNFC
RxCoreNFC (based on RxSwift)

Basic usage.

```swift
let session = NFCNDEFReaderSession.rx.session() // .session(invalidateAfterFirstRead: false)
session
    .flatMapLatest { (session) -> Observable<[NFCNDEFMessage]> in
        return session.message
    }
    .subscribe { (event) in
        switch event {
        case .next(let messages):
            // handle '[NFCNDEFMessage]'
            break
        case .error(let error):
            // handle error
            break
        case .completed:
            // only happens when 'invalidateAfterFirstRead = true' (default), or after user cancellation
            break
        }
    }
    .disposed(by: disposeBag)
```

Carthage setup.

```
github "maxvol/RxCoreNFC" ~> 0.0.4

```

// TODO: NFCISO15693ReaderSession
