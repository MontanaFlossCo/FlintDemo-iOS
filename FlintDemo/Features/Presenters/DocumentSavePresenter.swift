//
//  DocumentSavePresenter.swift
//  FlintDemo
//
//  Created by Marc Palmer on 19/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation

protocol DocumentSavePresenter {
    func didSaveChanges(to document: Document, wasFirstSave: Bool)
}
