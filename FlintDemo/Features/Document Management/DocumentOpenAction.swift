//
//  DocumentOpenAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
#if os(macOS)
import CoreServices
#else
import MobileCoreServices
#endif
import CoreSpotlight
import FlintCore

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

extension DocumentRef: ActivityCodable {
    var requiredUserInfoKeys: Set<String> {
        return ["document"]
    }
    
    enum TestError: Error {
        case missingKey(name: String)
    }
    
    init(activityUserInfo: [AnyHashable:Any]?) throws {
        guard let name = activityUserInfo?["document"] as? String else {
            throw TestError.missingKey(name: "document")
        }
        self.init(name: name)
    }
    
    func encodeForActivity() -> [AnyHashable:Any]? {
        return ["document": name]
    }
}

final class DocumentOpenAction: Action {
    typealias InputType = DocumentRef
    typealias PresenterType = DocumentPresenter

    static var description = "Open a document"
    
    static var analyticsID: String? = "document-open"
    
#if canImport(Network)
    static var activityTypes: Set<ActivityEligibility> = [.handoff, .prediction]
#else
    static var activityTypes: Set<ActivityEligibility> = [.handoff, .search]
#endif

    static func perform(with context: ActionContext<DocumentRef>, using presenter: DocumentPresenter, completion: @escaping ((ActionPerformOutcome) -> ())) {
        presenter.openDocument(context.input)
        completion(.success(closeActionStack: false))
    }
    
    static func prepareActivity(_ activity: ActivityBuilder<DocumentOpenAction>) {
        guard let document = DocumentStore.shared.load(activity.input.name) else {
            activity.cancel()
            return
        }

        guard let name = activity.metadata?.title else {
            preconditionFailure("Document has no name")
        }
        activity.title = "Open \(name)"
        activity.subtitle = document.body
    }
}
