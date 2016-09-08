//
//  ViewController.swift
//  Test
//
//  Created by Jecky Kukadiya on 08/09/16.
//  Copyright © 2016 Jecky Kukadiya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, CLUploaderDelegate {

    // MARK:- IBOutlets
    @IBOutlet weak var ivTarget: UIImageView!
    
    @IBOutlet weak var btnChooseImage: UIButton!
    
    @IBOutlet weak var btnUpload: UIButton!
    
    // MARK:- Globle Objects
    var imagePicker = UIImagePickerController()
    
    // MARK:- ViewController's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- Custom Init Functions
    func setValues() {
        self.ivTarget.layer.borderColor = UIColor.blackColor().CGColor
        self.ivTarget.layer.borderWidth = 0.7
        self.ivTarget.layer.cornerRadius = 1.0
        self.ivTarget.layer.masksToBounds = true
    }
    
    // MARK:- Button Actions
    @IBAction func btnChooseImage_Action(sender: UIButton) {
        let actionsheet = UIAlertController(title: "Options", message: nil, preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .Default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                self.imagePicker.allowsEditing = false
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
        }

        let galleryAction = UIAlertAction(title: "Gallery", style: .Default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
                self.imagePicker.allowsEditing = false
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            print("Cancel")
        }
        actionsheet.addAction(cameraAction)
        actionsheet.addAction(galleryAction)
        actionsheet.addAction(cancelAction)
        self.presentViewController(actionsheet, animated: true, completion: nil)
     }
    
    @IBAction func btnUpload_Action(sender: UIButton) {
        if ivTarget.image != nil {
        let uploader = CLUploader(cloudnary, delegate: self)
            let imageData = UIImagePNGRepresentation(ivTarget.image!)
            uploader.upload(imageData, options: [:])
        } else {
            let alert = UIAlertController(title: "Test Application", message: "Please select an image to upload on cloudinary.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Cancel, handler: { (action) in
                print("Ok")
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK:- Image Picker Controller Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: {() -> Void in
            self.ivTarget.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        })
    }
    
    // MARK:- Cloudinary Delegates
    func uploaderSuccess(result: [NSObject : AnyObject]!, context: AnyObject!) {
        let publicID = result["public_id"]
        print("Upload success. Public ID=%@, Full result=%@", publicID, result)
    }
    
    func uploaderError(result: String!, code: Int, context: AnyObject!) {
        print("Upload error: %@, %d", result, code)

    }
    
    func uploaderProgress(bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int, context: AnyObject!) {
        print("Upload progress: %d/%d (+%d)", totalBytesWritten, totalBytesExpectedToWrite, bytesWritten);
    }
}

