//
//  DocumentCreateAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

/// This action will ask the presenter to show the "Create a new document" UI, with a suggested name.
final class DocumentCreateAction: Action {
    typealias InputType = NoInput
    typealias PresenterType = DocumentCreatePresenter

    static var description = "Create a new document"

    static var analyticsID: String? = "document-create"

    static func perform(context: ActionContext<NoInput>, presenter: DocumentCreatePresenter, completion: Completion) -> Completion.Status {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MM HH:mm:ss")
        let date = dateFormatter.string(from: Date())
        presenter.showCreate(suggestedTitle: "Untitled \(date)")
        return completion.completedSync(.success)
    }
}

