//
//  SiriFeature.swift
//  FlintDemo
//
//  Created by Marc Palmer on 11/09/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import Intents
import FlintCore


protocol SiriResultPresenter {
    func showResult(response: INIntentResponse)
}


class FlintSiriPresenter: SiriResultPresenter {
    var result: INIntentResponse?
    
    func showResult(response: INIntentResponse) {
        result = response
    }
}

class SiriFeature: Feature {
    static let description = "Siri access to documents"

    static let getNote = action(GetNoteAction.self)

    static func prepare(actions: FeatureActionsBuilder) {
        actions.declare(getNote)
    }
}

final class GetNoteAction: Action {
    typealias InputType = DocumentRef
    typealias PresenterType = SiriResultPresenter
    
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
            intentToUse.suggestedInvocationPhrase = suggestedInvocationPhrase

            let interaction = INInteraction(intent: intentToUse, response: nil)
            interaction.donate { error in
                print("Donation error: \(String(describing: error))")
            }
        }
    }
    
    static func perform(context: ActionContext<DocumentRef>, presenter: SiriResultPresenter, completion: Completion) -> Completion.Status {
        guard #available(iOS 12, *) else {
            flintBug("Should never be called")
        }
        
        let note = "Yasssss!"
        let response = GetNoteIntentResponse()
        response.content = note
        
        presenter.showResult(response: response)
        return completion.willCompleteAsync()
    }
}
