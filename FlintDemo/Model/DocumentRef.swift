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

extension DocumentRef: RouteParametersCodable {
    init?(from queryParameters: RouteParameters?, mapping: URLMapping) {
        guard let name = queryParameters?["name"] else {
            return nil
        }
        self.name = name
    }
    
    func encodeAsRouteParameters(for mapping: URLMapping) -> RouteParameters? {
        return ["name": name]
    }
}
