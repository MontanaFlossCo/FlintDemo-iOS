//
//  GetNoteIntentHandler.swift
//  FlintDemoSiriIntent
//
//  Created by Marc Palmer on 11/09/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import Intents
import FlintCore

@objc
class GetNoteIntentHandler: NSObject, GetNoteIntentHandling {
    @objc(handleGetNote:completion:)
    func handle(intent: GetNoteIntent, completion: @escaping (GetNoteIntentResponse) -> Void) {
        let presenter = GetNoteSiriPresenter(completion: completion)
        let outcome = Flint.performIntentAction(intent: intent, presenter: presenter)
        if outcome != .success {
            print("Intent failed: \(outcome)")
        }
    }
    
//    @objc(confirmGetNote:completion:)
//    func confirm(intent: GetNoteIntent, completion: @escaping (GetNoteIntentResponse) -> Swift.Void) {
//
//    }

}
