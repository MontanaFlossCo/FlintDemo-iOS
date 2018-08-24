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

    static func perform(context: ActionContext<InputType>, presenter: DocumentEditingPresenter, completion: Completion) -> Completion.Status {
        context.input.removeAttachment()
        return completion.completedSync(.success(closeActionStack: true))
    }
}
