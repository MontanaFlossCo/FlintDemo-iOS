//
//  DetailViewController.swift
//  FlintDemo
//
//  Created by Marc Palmer on 06/02/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import UIKit
import FlintCore
import PhotosUI

class DetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DocumentEditingPresenter, PhotoSelectionPresenter {
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoActionButton: UIButton!
    
    var document: Document? {
        didSet {
            DocumentEditSession.shared.currentDocumentBeingEdited = document
        }
    }

    var documentRef: DocumentRef? {
        didSet {
            loadDocument()
            configureView()
        }
    }
    
    var imagePickerController: UIImagePickerController?

    func loadDocument() {
        if let info = documentRef {
            document = DocumentStore.shared.load(info.name)
        } else {
            document = nil
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let document = document {
            navigationItem.title = document.name
            
            if let textView = bodyTextView {
                textView.text = document.body
            }
            
            if let button = photoActionButton {
                if document.hasAttachment {
                    button.setTitle("❌", for: .normal)
                } else {
                    button.setTitle("📷", for: .normal)
                }
            }
            
            if let imageView = photoImageView {
                if let imageData = document.attachmentData {
                    imageView.image = UIImage(data: imageData)
                } else {
                    imageView.image = nil
                }
            }
        } else {
            navigationItem.title = "No document"
            if let textView = bodyTextView {
                textView.text = ""
            }
        }
    }

    private var masterViewController: MasterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    // Save the current document before leaving
    override func viewWillDisappear(_ animated: Bool) {
        if let document = document {
            DocumentManagementFeature.closeDocument.perform(using: self, with: document)
        }
        super.viewWillDisappear(animated)
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        // Not very happy about this, but on iPad when the detail VC is changing, we are removed and all the backrefs
        // to the master / split view controller are nil'd so we can't tell it to update its display.
        // There's an argument to be had that we shouldn't do this on iPad as it should have updated in realtime.
        // Something to fix up later.
        if parent != nil {
            // Get the list presenter for this view controller so we can tell it about the changes
            let primaryNavigationController = splitViewController!.viewControllers.first as! UINavigationController
            masterViewController = (primaryNavigationController.viewControllers.first as! MasterViewController)
        }
    }
    
    // MARK: IB Actions
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        guard let document = document else {
            fatalError("There's no document")
        }
        
        if let request = DocumentSharingFeature.request(DocumentSharingFeature.share) {
            request.perform(using: self, with: document)
        } else {
            let alertController = UIAlertController(title: "Purchase required!", message: "Sorry but sharing is a premium feature. Please purchase to unlock this feature.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        }
    }

    @IBAction func photoActionButtonTapped(_ sender: Any) {
        if photoImageView.image != nil {
            removePhoto()
        } else {
            selectPhoto()
        }
    }

    func removePhoto() {
        if let request = PhotoAttachmentsFeature.request(PhotoAttachmentsFeature.removePhoto) {
            request.perform(using: self, with: document!) { (outcome: ActionOutcome) in
                if case .success = outcome {
                    self.configureView()
                }
            }
        }
    }
    
    func selectPhoto() {
        if let request = PhotoAttachmentsFeature.request(PhotoAttachmentsFeature.showPhotoSelection) {
            request.perform(using: self)
        } else {
            // Check if it failed because of permissions
            let constraints = Flint.constraintsEvaluator.evaluate(for: PhotoAttachmentsFeature.self)
            if constraints.unsatisfied.permissions.count > 0 {
                
                let permission = constraints.unsatisfied.permissions.first!
                let status = Flint.permissionChecker.status(of: permission)
                if status == .denied {
                    let alertController = UIAlertController(title: "Permission required!", message: "You need to grant Photos access. Please go to Settings, Flint Demo and enable photos access.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alertController, animated: true)
                } else if status == .restricted {
                    let alertController = UIAlertController(title: "Access is restricted!", message: "You need Photos access but this is restricted on your device.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alertController, animated: true)
                } else if status == .notDetermined {
                    Flint.permissionChecker.requestAuthorization(for: permission)
                }
            }
        }
    }
    
    // MARK: Data mechanics
    
    func saveChanges() {
        if let document = document {
            document.body = bodyTextView.text
            document.modifiedDate = Date()
            DocumentManagementFeature.saveDocument.perform(using: self, with: document)
        }
    }

    // MARK: DocumentPresenter conformance
    
    func share(_ document: Document) {
        let text = document.body
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = actionButton
        present(activityViewController, animated: true)
    }
    
    func didSaveChanges(to document: Document, wasFirstSave: Bool) {
        guard let listPresenter = masterViewController else {
            return
        }

        if wasFirstSave {
            listPresenter.didInsertNew(documentInfo: document.info)
        } else {
            listPresenter.didUpdate(documentInfo: document.info)
        }

    }
    
    func closeDocument(_ document: Document) {
        saveChanges()
    }
}

/// MARK: Photo attachment presenter

extension DetailViewController {
    func showPhotoSelection() {
        imagePickerController = UIImagePickerController()
        imagePickerController?.delegate = self
        present(imagePickerController!, animated: true)
    }

    func dismissPhotoSelection() {
        imagePickerController?.dismiss(animated: true, completion: nil)
        imagePickerController = nil
    }

    func showAssetFetchProgress() {
        print("Fetching...")
    }
    
    func hideAssetFetchProgress() {
        print("Done fetching!")
    }
}

/// MARK: Image picker delegate conformance

extension DetailViewController {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController = nil
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePickerController = nil
        
        // Perform the attach action
        if let request = PhotoAttachmentsFeature.request(PhotoAttachmentsFeature.addSelectedPhoto) {
            guard let asset = info[UIImagePickerControllerPHAsset] as? PHAsset else {
                preconditionFailure("Expected an asset")
            }
            let addRequest = AddAssetToDocumentRequest(asset: asset, document: document!)
            request.perform(using: self, with: addRequest) { (outcome: ActionOutcome) in
                if case .success = outcome {
                    self.configureView()
                }
            }
        }

        picker.dismiss(animated: true, completion: nil)
    }
}
