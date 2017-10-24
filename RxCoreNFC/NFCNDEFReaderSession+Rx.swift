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

extension Reactive where Base: NFCNDEFReaderSession {
    
    /**
     Reactive wrapper for `delegate`.
     For more information take a look at `DelegateProxyType` protocol documentation.
     */
    public var delegate: DelegateProxy {
        return RxNFCNDEFReaderSessionDelegateProxy.proxyForObject(base)
    }
    
    // TODO
    
}
