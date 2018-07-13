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

    static func perform(context: ActionContext<Document>, presenter: DocumentSavePresenter, completion: @escaping ((ActionPerformOutcome) -> ())) {
        let isNew = DocumentStore.shared.save(context.input)
        presenter.didSaveChanges(to: context.input, wasFirstSave: isNew)
        completion(.success(closeActionStack: false))
    }
}
