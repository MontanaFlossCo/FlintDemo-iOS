//
//  DocumentShareAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 19/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

final class DocumentShareAction: Action {
    typealias InputType = Document
    
    typealias PresenterType = DocumentEditingPresenter
    
    static func perform(with context: ActionContext<Document>, using presenter: DocumentEditingPresenter, completion: @escaping (ActionPerformOutcome) -> Void) {
        guard let document = context.input else {
            fatalError("A document is required as input")
        }
        presenter.share(document)
    }
}
