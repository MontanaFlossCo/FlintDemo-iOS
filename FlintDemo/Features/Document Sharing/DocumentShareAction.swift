//
//  DocumentShareAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 19/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

/// The action that will present the share UI for a given document
final class DocumentShareAction: Action {
    typealias InputType = Document
    
    typealias PresenterType = DocumentEditingPresenter
    
    static func perform(context: ActionContext<Document>, presenter: DocumentEditingPresenter, completion: Completion) -> Completion.Status {
        presenter.share(context.input)
        return completion.completedSync(.success(closeActionStack: true))
    }
}
