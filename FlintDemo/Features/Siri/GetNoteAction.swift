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

    static func donateToSiri(input: InputType) {
        if #available(iOS 12, *) {
            let intentToUse = GetNoteAction.intent(for: input)
            intentToUse.suggestedInvocationPhrase = GetNoteAction.suggestedInvocationPhrase

            let interaction = INInteraction(intent: intentToUse, response: nil)
            interaction.donate { error in
                print("Donation error: \(String(describing: error))")
            }
        }
    }
    
    static func perform(context: ActionContext<DocumentRef>, presenter: PresenterType, completion: Completion) -> Completion.Status {
        guard #available(iOS 12, *) else {
            flintBug("Should never be called")
        }
        
        let note = "Yasssss!"
        let response = GetNoteIntentResponse(code: .success, userActivity: nil)
        response.content = note

        presenter.showResult(response: response)
        return completion.completedSync(.successWithFeatureTermination)
    }
}
