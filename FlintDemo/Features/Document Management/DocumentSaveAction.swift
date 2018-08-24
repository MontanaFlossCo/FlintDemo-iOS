//
//  DocumentSaveAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

/// This action will save the specified document and then notify the presenter.
final class DocumentSaveAction: Action {
    typealias InputType = Document
    typealias PresenterType = DocumentSavePresenter

    static var description = "Save a document"

    static var analyticsID: String? = "document-save"

    static func perform(context: ActionContext<Document>, presenter: DocumentSavePresenter, completion: Completion) -> Completion.Status {
        let isNew = DocumentStore.shared.save(context.input)
        presenter.didSaveChanges(to: context.input, wasFirstSave: isNew)
        return completion.completedSync(.success(closeActionStack: false))
    }
}
