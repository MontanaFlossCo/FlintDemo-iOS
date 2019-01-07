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

/// Take a Siri Intent for "Get Note" and try to load and present the result in Siri
@available(iOS 12, *)
final class GetNoteAction: IntentAction {
    typealias InputType = GetNoteIntent
    typealias PresenterType = GetNoteSiriPresenter
    
    enum Failure: Error {
        case documentNotFound
    }
    
    static func perform(context: ActionContext<InputType>, presenter: PresenterType, completion: Completion) -> Completion.Status {
        let response: GetNoteIntentResponse
        let outcome: ActionPerformOutcome
        if let name = context.input.documentName, let document = DocumentStore.shared.load(name) {
            response = .success(content: document.body)
            outcome = .successWithFeatureTermination
        } else {
            // If they are to continue in-app we can pass an activity
            response = GetNoteIntentResponse(code: .failure, userActivity: nil)
            outcome = .failureWithFeatureTermination(error: Failure.documentNotFound)
        }
        
        presenter.showResult(response: response)
        return completion.completedSync(outcome)
    }
}

