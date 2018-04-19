//
//  DocumentInfo.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

struct DocumentInfo: CustomStringConvertible, CustomDebugStringConvertible {
    let name: String
    let modifiedDate: Date

    init(name: String, modifiedDate: Date) {
        self.name = name
        self.modifiedDate = modifiedDate
    }
    
    var documentRef: DocumentRef {
        return DocumentRef(name: name)
    }

    var description: String { return name }
    
    var debugDescription: String { return "DocumentInfo: \(name)" }
}
