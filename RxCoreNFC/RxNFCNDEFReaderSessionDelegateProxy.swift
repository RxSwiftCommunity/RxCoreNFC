//
//  RxNFCNDEFReaderSessionDelegateProxy.swift
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

class RxNFCNDEFReaderSessionDelegateProxy:
    NFCNDEFReaderSessionDelegate,
    DelegateProxyType,
    DelegateProxy
{

    class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let readerSession: NFCNDEFReaderSession = object as! NFCNDEFReaderSession
        return readerSession.delegate
    }

    class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let readerSession: NFCNDEFReaderSession = object as! NFCNDEFReaderSession
        readerSession.delegate = delegate as? NFCNDEFReaderSessionDelegate
    }

}
