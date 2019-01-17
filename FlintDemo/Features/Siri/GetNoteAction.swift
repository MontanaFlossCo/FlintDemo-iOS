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
    typealias InputType = DocumentRef
    typealias IntentType = GetNoteIntent
    typealias PresenterType = GetNoteSiriPresenter
    
    enum Failure: Error {
        case documentNotFound
    }
    
    static func intent(for input: DocumentRef) -> GetNoteIntent? {
        let result = GetNoteIntent()
        result.documentName = input.name
        result.setImage(INImage(named: "GetNoteIcon"), forParameterNamed: \.documentName)
        return result
    }
    
    static func input(for intent: GetNoteIntent) -> DocumentRef? {
        guard let name = intent.documentName else {
            return nil
        }
        let ref = DocumentRef(name: name, summary: nil)
        return ref
    }
    
    static func perform(context: ActionContext<InputType>, presenter: PresenterType, completion: Completion) -> Completion.Status {
        let response: GetNoteIntentResponse
        let outcome: ActionPerformOutcome
        if let document = DocumentStore.shared.load(context.input.name) {
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

