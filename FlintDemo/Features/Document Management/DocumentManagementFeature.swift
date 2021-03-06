//
//  DocumentManagementFeature.swift
//  FlintDemo
//
//  Created by Marc Palmer on 07/02/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

/// This feature describes all the core interactions with documents in the app.
///
/// URL mappings are provided for triggering `create` and `open`, showing both custom and default schemes and domains.
///
/// - Tag: document-management
final class DocumentManagementFeature: Feature, URLMapped {
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
        // Map the app's default (first) custom URL scheme and a custom universal domain. e.g. this route will be
        // used for `fdemo://open`
        routes.send("open", to: openDocument, in: [.appAny, .universal(domain: "legacydomain.com")])
        routes.send("create", to: createNew, in: [.app(scheme: "x-test"), .app(scheme:"internal-test"), .universal(domain: "yourdomain.com")])
    }
}
