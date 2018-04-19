//
//  Document.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation

struct Document: CustomStringConvertible, CustomDebugStringConvertible {
    var name: String
    var modifiedDate: Date
    var body: String
    
    var info: DocumentInfo {
        return DocumentInfo(name: name, modifiedDate: modifiedDate)
    }

    var documentRef: DocumentRef {
        return DocumentRef(name: name)
    }

    var description: String {
        return name
    }
    
    var debugDescription: String {
        return "Document: name: \"\(name)\", body: \"\(body)\""
    }
}

