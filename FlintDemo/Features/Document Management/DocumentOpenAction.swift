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

final class DocumentOpenAction: Action {
    typealias InputType = DocumentRef
    typealias PresenterType = DocumentPresenter

    static var description = "Open a document"
    
    static var analyticsID: String? = "document-open"
    
    static var activityTypes: Set<ActivityEligibility> = [.perform, .handoff, .search]
    
    static func perform(with context: ActionContext<DocumentRef>, using presenter: DocumentPresenter, completion: @escaping ((ActionPerformOutcome) -> ())) {
        presenter.openDocument(context.input)
        completion(.success(closeActionStack: false))
    }
    
    static func prepare(activity: NSUserActivity, with input: InputType?) -> NSUserActivity? {
        guard let documentRef = input else {
            preconditionFailure("Input was expected")
        }
        
        // Note that this shouldn't really be here, inside an "Open" action.
        // Usually this would be for the case where you want to index something *and* make it available for
        // Siri suggestions, such as browsing document that the user didn't create themselves.
        // For the purposes of testing however, we leave it here. In reality you would use the CoreSpotlight APIs
        // directly to index all the known documents in the background at startup or similar.

        guard let document = DocumentStore.shared.load(documentRef.name) else {
            return nil
        }

        let searchAttributes: CSSearchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        searchAttributes.addedDate = Date()
        searchAttributes.kind = "Flint Demo Document"
        searchAttributes.contentDescription = document.body
        activity.contentAttributeSet = searchAttributes

        /// Hardcode some silly keywords for testing
        activity.keywords = Set("decentralised internet patent".components(separatedBy: " "))
        activity.title = documentRef.name
        return activity
    }
}
