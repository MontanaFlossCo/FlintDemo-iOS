//
//  ShowDocumentListAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import UIKit
import FlintCore

final class ShowDocumentListAction: Action {
    typealias InputType = UIStoryboard
    typealias PresenterType = UINavigationController

    static var description = "Show the list of documents"

    static var analyticsID: String? = "show-document-list"

    static func perform(with context: ActionContext<UIStoryboard>, using presenter: UINavigationController, completion: ((ActionPerformOutcome) -> ())) {
//        let viewController = context.input!.instantiateViewController(withIdentifier: "Master")!
//        presenter.pushViewController(viewController, animated: true)
        completion(.success(closeActionStack: false))
    }
}

