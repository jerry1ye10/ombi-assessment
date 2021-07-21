//
//  ViewController.swift
//  ombi-video-assignment
//
//  Created by Jerry Ye on 7/20/21.
//

import UIKit
import MobileCoreServices


class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var controller = UIImagePickerController()
    let videoFileName = "/video.mp4"
    var firstAppearance = false
    var viewingVideo = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstAppearance{
            return
        }
        viewingVideo = false
        takeVideo()
        firstAppearance = true
    }

    
    func takeVideo(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    
                // 2 Present UIImagePickerController to take video
                controller.sourceType = .camera
                controller.mediaTypes = [kUTTypeMovie as String]
                controller.delegate = self
                    
                present(controller, animated: true, completion: nil)
            }
            else {
                print("Camera is not available")
            }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Starting")
        if self.viewingVideo{
            return
        }
        if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
            // Save video to the main photo album
            let selectorToCall = #selector(ViewController.videoSaved(_:didFinishSavingWithError:context:))
              
            // 2
            UISaveVideoAtPathToSavedPhotosAlbum(selectedVideo.relativePath, self, selectorToCall, nil)
            // Save the video to the app directory
            let videoData = try? Data(contentsOf: selectedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
            let dataPath = documentsDirectory.appendingPathComponent(videoFileName)
            try! videoData?.write(to: dataPath, options: [])
        }
        // 3
        picker.dismiss(animated: true)
    }
    
    
    @objc func videoSaved(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
        if let theError = error {
            print("error saving the video = \(theError)")
        } else {
           DispatchQueue.main.async(execute: { () -> Void in
           })
        }
    }
    
    @IBAction func takeVideo(_ sender: Any) {
        takeVideo()
    }
    
    @IBAction func playVideo(_ sender: Any) {
        
        // Display Photo Library
            var newController = UIImagePickerController()
            newController.sourceType = UIImagePickerController.SourceType.photoLibrary
            newController.mediaTypes = [kUTTypeMovie as String]
            newController.delegate = self
            viewingVideo = true
            present(newController, animated: true, completion: nil)
        
    }
    
}

