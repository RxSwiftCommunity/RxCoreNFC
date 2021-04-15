//
//  NFCNDEFReaderSession+Rx.swift
//  RxCoreNFC
//
//  Created by Maxim Volgin on 24/10/2017.
//  Copyright (c) RxSwiftCommunity. All rights reserved.
//

import CoreNFC
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

final class RxNFCNDEFReaderSessionDelegate: NSObject, NFCNDEFReaderSessionDelegate {

    typealias Observer = AnyObserver<[NFCNDEFMessage]>

    var observer: Observer?

    public func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        if let nfcReaderError = error as? NFCReaderError {
            switch nfcReaderError.code {
            case NFCReaderError.readerSessionInvalidationErrorUserCanceled:
                fallthrough
            case NFCReaderError.readerSessionInvalidationErrorFirstNDEFTagRead:
                observer?.on(.completed)
                return
            default:
                break
            }
        }
        observer?.on(.error(error))
    }

    public func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        observer?.on(.next(messages))
    }

}

public struct RxNFCNDEFReaderSession {

    private let delegate: RxNFCNDEFReaderSessionDelegate
    private let session: NFCNDEFReaderSession

    public let message: Observable<[NFCNDEFMessage]>

    public init(invalidateAfterFirstRead: Bool, alertMessage: String?) {
        let delegate = RxNFCNDEFReaderSessionDelegate()
        let session = NFCNDEFReaderSession(delegate: delegate, queue: nil, invalidateAfterFirstRead: invalidateAfterFirstRead)
        if let alertMessage = alertMessage {
            session.alertMessage = alertMessage
        }

        self.message = Observable
            .create { observer in
                delegate.observer = observer
                return Disposables.create()
            }
            .do(onSubscribed: {
                session.begin()
            })
        self.session = session
        self.delegate = delegate
    }

}

extension Reactive where Base: NFCNDEFReaderSession {

    static public func session(invalidateAfterFirstRead: Bool = true, alertMessage: String? = nil) -> Observable<RxNFCNDEFReaderSession> {
        return Observable
            .create { observer in
                let session = RxNFCNDEFReaderSession(invalidateAfterFirstRead: invalidateAfterFirstRead, alertMessage: alertMessage)
                observer.on(.next(session))
                return Disposables.create()
            }
            .share(replay: 1, scope: .whileConnected)
    }
    
}

