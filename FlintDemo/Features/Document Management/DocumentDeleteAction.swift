//
//  DocumentDeleteAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 19/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

final class DocumentDeleteAction: Action {
    typealias InputType = DocumentRef
    typealias PresenterType = DocumentListPresenter

    static var description = "Deletes a document"

    static var analyticsID: String? = "document-delete"

    static func perform(with context: ActionContext<DocumentRef>, using presenter: DocumentListPresenter, completion: @escaping ((ActionPerformOutcome) -> ())) {
        DocumentStore.shared.delete(context.input)
        presenter.didRemove(documentRef: context.input)
        completion(.success(closeActionStack: false))
    }
}
