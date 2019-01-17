//
//  DocumentOpenAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore
import Intents

/// This action will open and present a document, with the input specifying the document reference (name).
///
/// The action supports Handoff and Spotlight search via NSUserActivity.
/// On iOS 12+ it supports Siri Predictions as well (search is implied by prediction).
///
/// The action is also set up to report basic analytics (with no custom attributes).
///
/// - see: `DocumentManagementFeature` for URL mappings that can trigger this action.
final class DocumentOpenAction: UIAction {
    typealias InputType = DocumentRef
    typealias PresenterType = DocumentPresenter

    static var description = "Open a document"
    
    static var analyticsID: String? = "document-open"

    // Search is included in case targetting < iOS 12 which doesn't support prediction
    static var activityTypes: Set<ActivityEligibility> = [.handoff, .search, .prediction]

    static var suggestedInvocationPhrase: String? = "Show my notes"

    // The donateToSiri() functionality will call this. 
    @available(iOS 12, *)
    static func associatedIntents(for input: InputType) -> [FlintIntent]? {
        let result = GetNoteIntent()
        result.documentName = input.name
        result.setImage(INImage(named: "GetNoteIcon"), forParameterNamed: \.documentName)
        return [result]
    }

    static func perform(context: ActionContext<DocumentRef>, presenter: DocumentPresenter, completion: Completion) -> Completion.Status {
        presenter.openDocument(context.input)

        return completion.completedSync(.success)
    }
    
    static func prepareActivity(_ activity: ActivityBuilder<DocumentOpenAction>) {
        guard let document = DocumentStore.shared.load(activity.input.name) else {
            preconditionFailure("No such document")
        }
        guard let name = activity.metadata?.title else {
            preconditionFailure("Document has no name")
        }
        activity.title = "Open \(name)"
        activity.subtitle = document.body
        activity.suggestedInvocationPhrase = "Get note \(document.name)"
    }
}
