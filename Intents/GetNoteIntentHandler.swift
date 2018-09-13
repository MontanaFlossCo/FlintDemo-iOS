//
//  GetNoteIntentHandler.swift
//  FlintDemoSiriIntent
//
//  Created by Marc Palmer on 11/09/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import Intents

@objc
class GetNoteIntentHandler: NSObject, GetNoteIntentHandling {
    @objc(handleGetNote:completion:)
    func handle(intent: GetNoteIntent, completion: @escaping (GetNoteIntentResponse) -> Void) {
        print("I'm in the intent!")
        guard let documentName = intent.documentName else {
            return
        }
        
        let siriResultPresenter = FlintSiriPresenter()
        
        // Can this be async? Can we delay calling completion?
        let docRef = DocumentRef(name: documentName)
        SiriFeature.getNote.perform(input: docRef, presenter: siriResultPresenter)
        
        completion(.success(content: "Yay"))
    }

//    @objc(confirmGetNote:completion:)
//    func confirm(intent: GetNoteIntent, completion: @escaping (GetNoteIntentResponse) -> Swift.Void) {
//
//    }

}
