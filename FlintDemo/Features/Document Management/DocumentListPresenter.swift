//
//  DocumentListPresenter.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation

protocol DocumentListPresenter {
    func didInsertNew(documentInfo: DocumentInfo)
    func didUpdate(documentInfo: DocumentInfo)
    func didRemove(documentRef: DocumentRef)
}
