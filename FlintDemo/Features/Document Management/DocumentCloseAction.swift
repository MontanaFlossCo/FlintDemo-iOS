//
//  DocumentCloseAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

/// This action will ask the presenter to close the specified document
final class DocumentCloseAction: UIAction {
    typealias InputType = Document
    typealias PresenterType = DocumentEditingPresenter

    static var description = "Close the current document"

    static var analyticsID: String? = "document-close"

    static func perform(context: ActionContext<Document>, presenter: DocumentEditingPresenter, completion: Completion) -> Completion.Status {
        presenter.closeDocument(context.input)
        return completion.completedSync(.successWithFeatureTermination)
    }
}

