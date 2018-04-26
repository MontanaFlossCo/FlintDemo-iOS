//
//  DocumentCloseAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

final class DocumentCloseAction: Action {
    typealias InputType = Document
    typealias PresenterType = DocumentEditingPresenter

    static var description = "Close the current document"

    static var analyticsID: String? = "document-close"

    static func perform(with context: ActionContext<Document>, using presenter: DocumentEditingPresenter, completion: @escaping ((ActionPerformOutcome) -> ())) {
        presenter.closeDocument(context.input)
        completion(.success(closeActionStack: true))
    }
}

