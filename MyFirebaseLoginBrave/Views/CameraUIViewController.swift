//
//  CameraUIViewController.swift
//  MyFirebaseLoginBrave
//
//  Created by YONGKI LEE on 2020/02/01.
//  Copyright © 2020 Brave Lee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class CameraUIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var capturedImageView: UIImageView!
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.setScreenName("CameraUIViewController", screenClass: "CameraUIViewController")
    }
    
    @IBAction func takePhotoButtonTapped(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func storeImageButtonTapped(_ sender: UIButton) {
        guard let image = capturedImageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CameraUIViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[.mediaType] as? String ?? ""
        guard mediaType == "public.image" else { return }
        let image = info[.originalImage] as? UIImage ?? UIImage()
        capturedImageView.image = image
        picker.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
}
