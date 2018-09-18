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
class GetNoteSiriPresenter: SiriResultPresenter {
    var result: GetNoteIntentResponse?
    
    func showResult(response: GetNoteIntentResponse) {
        result = response
    }
}


@available(iOS 12, *)
final class GetNoteAction: SiriIntentAction {
    typealias InputType = DocumentRef
    typealias PresenterType = GetNoteSiriPresenter
    
    static let suggestedInvocationPhrase: String? = "What's up"
    
    // Not need if using intentType? If that conforms to InputConvertible, do it by magic?
    @available(iOS 12, *)
    static func intent(for input: InputType) -> INIntent {
        let result = GetNoteIntent()
        result.documentName = input.name
        return result
    }

    static func perform(context: ActionContext<DocumentRef>, presenter: PresenterType, completion: Completion) -> Completion.Status {
        let response: GetNoteIntentResponse
        if let document = DocumentStore.shared.load(context.input.name) {
            response = .success(content: document.body)
        } else {
            response = GetNoteIntentResponse(code: .failure, userActivity: nil)
        }
        
        presenter.showResult(response: response)
        return completion.completedSync(.successWithFeatureTermination)
    }
}
