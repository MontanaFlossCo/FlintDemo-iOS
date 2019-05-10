//
//  DocumentRef+FlintAdditions.swift
//  FlintDemo
//
//  Created by Marc Palmer on 16/07/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import MobileCoreServices
import UIKit
import CoreSpotlight
import FlintCore

/// Add more useful Flint logging for this type
extension DocumentRef: FlintLoggable {
    var loggingDescription: String {
        return "DocumentRef: \(name)"
    }

    var loggingInfo: [String : String]? {
        return ["name": name]
    }
}

/// Add custom URL encoding for this type
extension DocumentRef: RouteParametersCodable {
    init?(from queryParameters: RouteParameters?, mapping: URLMapping) {
        guard let name = queryParameters?["name"] else {
            return nil
        }
        self.name = name
        self.summary = ""
    }
    
    func encodeAsRouteParameters(for mapping: URLMapping) -> RouteParameters? {
        return ["name": name]
    }
}

/// Add custom metadata representation for use in NSUserActivity, for better
/// Siri Shortcuts support and Spotlight results.
extension DocumentRef: ActivityMetadataRepresentable {
    var metadata: ActivityMetadata {
        let searchAttributes = CSSearchableItemAttributeSet()
        searchAttributes.addedDate = Date()
        searchAttributes.kind = "Flint Demo Document"

        return .build {
            $0.title = name
            $0.thumbnail = UIImage(named: "FlintDemoDocIcon")
            $0.keywords = Set("decentralised internet patent".components(separatedBy: " "))
            $0.searchAttributes = searchAttributes
        }
    }
}

/// Add custom activity codable handling, to support non-URL based invocation based on userInfo data alone.
/// This means you can continue actions from activities even if they are not URL-mapped.
extension DocumentRef: ActivityCodable {
    var requiredUserInfoKeys: Set<String> {
        return ["document"]
    }
    
    enum DocumentRefError: Error {
        case missingKey(name: String)
    }
    
    init(activityUserInfo: [AnyHashable:Any]?) throws {
        guard let name = activityUserInfo?["document"] as? String else {
            throw DocumentRefError.missingKey(name: "document")
        }
        self.init(name: name, summary: "")
    }
    
    func encodeForActivity() -> [AnyHashable:Any]? {
        return ["document": name]
    }
}
