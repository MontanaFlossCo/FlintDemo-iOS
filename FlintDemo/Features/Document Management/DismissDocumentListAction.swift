//
//  DismissDocumentListAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import UIKit
import FlintCore

final class DismissDocumentListAction: Action {
    typealias InputType = NoInput
    typealias PresenterType = UINavigationController

    static var description = "Dismiss the document list UI"

    static var analyticsID: String? = "dismiss-document-list"

    static func perform(with context: ActionContext<NoInput>, using presenter: UINavigationController, completion: ((ActionPerformOutcome) -> ())) {
        presenter.popViewController(animated: true)
        completion(.success(closeActionStack: true))
    }
}
