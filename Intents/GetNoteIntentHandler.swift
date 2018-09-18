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
        guard let documentName = intent.documentName else {
            return
        }
        
        let siriResultPresenter = GetNoteSiriPresenter()
        
        // Can this be async? Can we delay calling completion?
        let docRef = DocumentRef(name: documentName)
        // We're on a background thread here.
        intentsQueue.async {
            SiriFeature.getNote.perform(input: docRef, presenter: siriResultPresenter)
            guard let result = siriResultPresenter.result else {
                fatalError("Action didn't return a result for Siri")
            }

            completion(result)
        }
    }
    
//    @objc(confirmGetNote:completion:)
//    func confirm(intent: GetNoteIntent, completion: @escaping (GetNoteIntentResponse) -> Swift.Void) {
//
//    }

}
