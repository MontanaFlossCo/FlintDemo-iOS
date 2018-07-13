//
//  DocumentRef.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

struct DocumentRef: FlintLoggable {
    let name: String

    init(name: String) {
        self.name = name
    }
    
    var loggingDescription: String {
        return "DocumentRef: \(name)"
    }

    var loggingInfo: [String : String]? {
        return ["name": name]
    }
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
