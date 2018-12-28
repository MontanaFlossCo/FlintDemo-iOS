//
//  GetNoteAction.swift
//  FlintDemo
//
//  Created by Marc Palmer on 15/09/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore
import Intents

@available(iOS 12, *)
class GetNoteSiriPresenter: IntentResultPresenter {
    let completion: (GetNoteIntentResponse) -> Void
    
    init(completion: @escaping (GetNoteIntentResponse) -> Void) {
        self.completion = completion
    }
    
    func showResult(response: FlintIntentResponse) {
        guard let response = response as? GetNoteIntentResponse else {
            fatalError("Wrong response type")
        }
        completion(response)
    }
}

@available(iOS 12, *)
final class GetNoteAction: IntentAction {
    typealias InputType = GetNoteIntent
    typealias PresenterType = GetNoteSiriPresenter
    
    static func perform(context: ActionContext<InputType>, presenter: PresenterType, completion: Completion) -> Completion.Status {
        let response: GetNoteIntentResponse
        if let name = context.input.documentName, let document = DocumentStore.shared.load(name) {
            response = .success(content: document.body)
        } else {
            response = GetNoteIntentResponse(code: .failure, userActivity: nil)
        }
        
        presenter.showResult(response: response)
        return completion.completedSync(.successWithFeatureTermination)
    }
}

