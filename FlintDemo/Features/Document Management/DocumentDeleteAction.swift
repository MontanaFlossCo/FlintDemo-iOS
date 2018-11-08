//
//  DocumentDeleteAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 19/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

/// This action will delete the specified document and notify the presenter that it should remove the item from the
/// display.
final class DocumentDeleteAction: UIAction {
    typealias InputType = DocumentRef
    typealias PresenterType = DocumentListPresenter

    static var description = "Deletes a document"

    static var analyticsID: String? = "document-delete"

    static func perform(context: ActionContext<DocumentRef>, presenter: DocumentListPresenter, completion: Completion) -> Completion.Status {
        DocumentStore.shared.delete(context.input)
        presenter.didRemove(documentRef: context.input)
        return completion.completedSync(.success)
    }
}
