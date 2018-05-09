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

class DetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,
        DocumentEditingPresenter, PhotoSelectionPresenter, PermissionAuthorisationCoordinator {
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
    
    var permissionController: AuthorisationController?
    
    func selectPhoto() {
        if let request = PhotoAttachmentsFeature.request(PhotoAttachmentsFeature.showPhotoSelection) {
            request.perform(using: self)
        } else {
            handleUnsatisfiedConstraints(for: PhotoAttachmentsFeature.self, retry: { [weak self] in self?.selectPhoto() })
        }
    }
    
    func handleUnsatisfiedConstraints<T>(for feature: T.Type, retry retryHandler: (() -> Void)?) where T: ConditionalFeature {
        // Check for required permissions that are restricted on this device through parental controls or a profile.
        // We must ask for these first in case the user purchases a feature they cannot use
        if feature.permissions.restricted.count > 0 {
            let permissions = feature.permissions.restricted.map({ String(describing: $0) }).joined(separator: ", ")
            let alertController = UIAlertController(title: "Permissiones are restricted!",
                                                    message: "\(feature.name) requires permissions that are restricted on your device: \(permissions)",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
            return
        }
        
        // Check for required purchases next, only if there are no permissions that are restricted
        if feature.purchases.requiredToUnlock.count > 0 {
            let alertController = UIAlertController(title: "Purchase required!",
                                                    message: "Sorry but \(feature.name) is a premium feature. Please make a purchase to unlock this feature.",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
            return
        }

        // Check for required permissions that are already denied
        if feature.permissions.denied.count > 0 {
            let permissions = feature.permissions.denied.map({ String(describing: $0) }).joined(separator: ", ")
            let alertController = UIAlertController(title: "Permissiones are denied!",
                                                    message: "\(feature.name) requires permissions that you have denied. Please go to Settings to enable them: \(permissions)",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
            return
        }

        // Start the flow of requesting authorisation for any permissions not determined
        if feature.permissions.notDetermined.count > 0 {
            permissionController = PhotoAttachmentsFeature.permissionAuthorisationController(using: self)
            permissionController?.begin(retryHandler: retryHandler)
            return
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

        func _showPicker(source: UIImagePickerControllerSourceType) {
            imagePickerController = UIImagePickerController()
            imagePickerController?.sourceType = source
            if source == .camera {
                imagePickerController?.cameraCaptureMode = .photo
                imagePickerController?.cameraDevice = .rear
            }
            imagePickerController?.delegate = self
            present(imagePickerController!, animated: true)
        }
        
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = photoActionButton
        alertController.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            _showPicker(source: .camera)
        }))
        alertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            _showPicker(source: .photoLibrary)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
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

/// MARK: Permission authorisation

extension DetailViewController {
    func willBeginPermissionAuthorisation(for permissions: Set<SystemPermission>, completion: ([SystemPermission]) -> ()) {
        // This is where you'd start your permission onboarding UI
        print("Starting permission authorisastion flow for: \(permissions)")
        completion(Array(permissions))
    }
    
    func willRequestPermission(for permission: SystemPermission, completion: (SystemPermissionRequestAction) -> ()) {
        // This is where you'd tell the user about the pemission you're about to ask for, before the system alert
        print("About to request authorisation for: \(permission)")
        completion(.request)
    }
    
    func didRequestPermission(for permission: SystemPermission, status: SystemPermissionStatus, completion: (_ shouldCancel: Bool) -> Void) {
        print("Finished request for \(permission), status is now: \(status)")
    }
    
    func didCompletePermissionAuthorisation(cancelled: Bool, outstandingPermissions: [SystemPermission]?) {
        /// This is where you can dismiss or update your onboarding UI to tell them the outcome, i.e. can
        /// they use the feature now or not.
        if cancelled {
            print("Cancelled permission authorisation flow. Outstanding permissions: \(String(describing: outstandingPermissions))")
        } else {
            print("Finished permission authorisation flow. Outstanding permissions: \(String(describing: outstandingPermissions))")
        }
        permissionController = nil
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
        let asset: PHAsset? = info[UIImagePickerControllerPHAsset] as? PHAsset
        let image: UIImage? = info[UIImagePickerControllerOriginalImage] as? UIImage
        guard asset != nil || image != nil else {
            preconditionFailure("Expected an asset")
        }

        // Perform the attach action
        if let request = PhotoAttachmentsFeature.request(PhotoAttachmentsFeature.addSelectedPhoto) {
            let addRequest = AddAssetToDocumentRequest(asset: asset, image: image, document: document!)
            request.perform(using: self, with: addRequest) { (outcome: ActionOutcome) in
                if case .success = outcome {
                    self.configureView()
                }
            }
        }

        picker.dismiss(animated: true, completion: nil)
    }
}
