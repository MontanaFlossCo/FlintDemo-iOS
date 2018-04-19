//
//  DocumentCreateAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

final class DocumentCreateAction: Action {
    typealias InputType = NoInput
    typealias PresenterType = DocumentCreatePresenter

    static var description = "Create a new document"

    static var analyticsID: String? = "document-create"

    static func perform(with context: ActionContext<NoInput>, using presenter: DocumentCreatePresenter, completion: @escaping ((ActionPerformOutcome) -> ())) {
        presenter.showCreate(suggestedTitle: "Untitled")
        completion(.success(closeActionStack: false))
    }
}

