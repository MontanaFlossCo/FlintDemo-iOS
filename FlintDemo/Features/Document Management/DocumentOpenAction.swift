//
//  DocumentOpenAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

/// This action will open and present a document, with the input specifying the document reference (name).
///
/// The action supports Handoff and Spotlight search via NSUserActivity.
/// On iOS 12+ it supports Siri Predictions as well (search is implied by prediction).
///
/// The action is also set up to report basic analytics (with no custom attributes).
///
/// - see: `DocumentManagementFeature` for URL mappings that can trigger this action.
final class DocumentOpenAction: Action {
    typealias InputType = DocumentRef
    typealias PresenterType = DocumentPresenter

    static var description = "Open a document"
    
    static var analyticsID: String? = "document-open"
    
    // Detect iOS 12 and support Siri predictions from NSUserActivity if so.
#if canImport(Network)
    static var activityTypes: Set<ActivityEligibility> = [.handoff, .prediction]
#else
    static var activityTypes: Set<ActivityEligibility> = [.handoff, .search]
#endif

    static func perform(context: ActionContext<DocumentRef>, presenter: DocumentPresenter, completion: @escaping ((ActionPerformOutcome) -> ())) {
        presenter.openDocument(context.input)
        completion(.success(closeActionStack: false))
    }
    
    static func prepareActivity(_ activity: ActivityBuilder<InputType>) {
        guard let document = DocumentStore.shared.load(activity.input.name) else {
            preconditionFailure("No such document")
        }
        guard let name = activity.metadata?.title else {
            preconditionFailure("Document has no name")
        }
        activity.title = "Open \(name)"
        activity.subtitle = document.body
    }
}
