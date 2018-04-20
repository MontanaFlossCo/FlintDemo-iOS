//
//  DocumentSaveAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

final class DocumentSaveAction: Action {
    typealias InputType = Document
    typealias PresenterType = DocumentSavePresenter

    static var description = "Save a document"

    static var analyticsID: String? = "document-save"

    static func perform(with context: ActionContext<Document>, using presenter: DocumentSavePresenter, completion: @escaping ((ActionPerformOutcome) -> ())) {
        guard let document = context.input else {
            preconditionFailure("Cannot save without a document")
        }
        
        let isNew = DocumentStore.shared.save(document)
        presenter.didSaveChanges(to: document, wasFirstSave: isNew)
        completion(.success(closeActionStack: false))
    }
}