//
//  DocumentManagementFeature.swift
//  FlintDemo
//
//  Created by Marc Palmer on 07/02/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

class DocumentManagementFeature: Feature, URLMapped {
    static let description = "Create, Open and Save documents"

    static let createNew = action(DocumentCreateAction.self)
    static let openDocument = action(DocumentOpenAction.self)
    static let closeDocument = action(DocumentCloseAction.self)
    static let saveDocument = action(DocumentSaveAction.self)
    static let deleteDocument = action(DocumentDeleteAction.self)

    static func prepare(actions: FeatureActionsBuilder) {
        actions.declare(createNew)
        actions.declare(openDocument)
        actions.declare(closeDocument)
        actions.declare(saveDocument)
        actions.declare(deleteDocument)
    }
    
    static func urlMappings(routes: URLMappingsBuilder) {
        routes.send("create", to: createNew, in: [.app(scheme: "x-test"), .app(scheme:"internal-test"), .universal(domain: "yourdomain.com")])
        routes.send("open", to: openDocument, in: [.appAny, .universal(domain: "legacydomain.com")])
    }
}
