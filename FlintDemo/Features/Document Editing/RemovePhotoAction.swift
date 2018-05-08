//
//  RemovePhotoAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 04/05/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

final class RemovePhotoAction: Action {
    typealias InputType = Document
    typealias PresenterType = DocumentEditingPresenter

    static func perform(with context: ActionContext<InputType>, using presenter: DocumentEditingPresenter, completion: @escaping (ActionPerformOutcome) -> Void) {
        context.input.removeAttachment()
        completion(.success(closeActionStack: true))
    }
}
