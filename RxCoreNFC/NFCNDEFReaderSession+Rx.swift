//
//  NFCNDEFReaderSession+Rx.swift
//  RxCoreNFC
//
//  Created by Maxim Volgin on 24/10/2017.
//  Copyright © 2017 Maxim Volgin. All rights reserved.
//

import CoreNFC
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

final class RxNFCNDEFReaderSessionDelegate: NSObject, NFCNDEFReaderSessionDelegate {
    
    fileprivate static var session: NFCNDEFReaderSession?
    fileprivate static var current: NFCNDEFReaderSessionDelegate?

    typealias Observer = AnyObserver<[NFCNDEFMessage]>

    private let observer: Observer

    init(observer: Observer) {
        self.observer = observer
    }
    
    fileprivate static func dispose() {
        RxNFCNDEFReaderSessionDelegate.session = nil
        RxNFCNDEFReaderSessionDelegate.current = nil
    }
    
    public func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        if let nfcReaderError = error as? NFCReaderError {
            switch nfcReaderError.code {
            case NFCReaderError.readerSessionInvalidationErrorUserCanceled:
                fallthrough
            case NFCReaderError.readerSessionInvalidationErrorFirstNDEFTagRead:
                observer.on(.completed)
                RxNFCNDEFReaderSessionDelegate.dispose()
                return
            default:
                break
            }
        }
        observer.on(.error(error))
        RxNFCNDEFReaderSessionDelegate.dispose()
    }

    public func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        observer.on(.next(messages))
    }

}

extension Reactive where Base: NFCNDEFReaderSession {
    
    public static func create(invalidateAfterFirstRead: Bool = true) -> Observable<[NFCNDEFMessage]> {
        return Observable.create { observer in
            let delegate = RxNFCNDEFReaderSessionDelegate(observer: observer)
            RxNFCNDEFReaderSessionDelegate.session = NFCNDEFReaderSession(delegate: delegate, queue: nil, invalidateAfterFirstRead: invalidateAfterFirstRead)
            RxNFCNDEFReaderSessionDelegate.current = delegate
            return Disposables.create(with: RxNFCNDEFReaderSessionDelegate.dispose)
        }
    }

}


