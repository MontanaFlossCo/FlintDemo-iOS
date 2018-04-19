//
//  DocumentRef.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

struct DocumentRef: CustomStringConvertible, CustomDebugStringConvertible {
    let name: String

    init(name: String) {
        self.name = name
    }
    
    var description: String { return name }
    
    var debugDescription: String { return "DocumentRef: \(name)" }
}

extension DocumentRef: QueryParametersCodable {
    init?(from queryParameters: QueryParameters?) {
        guard let name = queryParameters?["name"] else {
            return nil
        }
        self.name = name
    }
    
    func encodeAsQueryParameters() -> QueryParameters? {
        return ["name": name]
    }
}
