//
//  ViewController.swift
//  NeonAcademyFirebaseStorage
//
//  Created by Kerem Caan on 15.08.2023.
//

import UIKit
import SnapKit
import FirebaseFirestore
import FirebaseStorage

class ViewController: UIViewController {
    
    let imageView: UIImageView = UIImageView()
    let chooseButton: UIButton = UIButton()
    let uploadButton: UIButton = UIButton()
    private let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        retrievePhotos()
    }
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(100)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(300)
        }
        
        view.addSubview(chooseButton)
        chooseButton.setTitle("Choose", for: .normal)
        chooseButton.backgroundColor = .blue
        chooseButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        chooseButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(100)
            make.left.equalToSuperview().offset(100)
            make.width.equalTo(75)
        }
        
        view.addSubview(uploadButton)
        uploadButton.setTitle("Upload", for: .normal)
        uploadButton.backgroundColor = .blue
        uploadButton.addTarget(self, action: #selector(goToDownload), for: .touchUpInside)
        uploadButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(100)
            make.right.equalToSuperview().offset(-100)
            make.width.equalTo(75)
        }
        
    }

    
    @objc func goToDownload() {
        if imageView.image != nil {
            self.navigationController?.pushViewController(DownloadVC(), animated: true)
        }
        
    }
    
    
    
    
    func retrievePhotos() {
        
        let storageRef = Storage.storage().reference()
        let mediaFolder = storageRef.child("images")
        
        if let data = imageView.image?.pngData() {
            let imageRef = mediaFolder.child("image.png")
            
            
            imageRef.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    DownloadVC().urlLabel.text = url?.absoluteString
                    self.navigationController?.pushViewController(DownloadVC(), animated: true)
                }
                
            }
            
            
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @objc func buttonTapped() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        guard let imageData = image.pngData() else {
            return
        }
        
        let path = "images/image.png"
        storage.child(path).putData(imageData) { _, error in
            guard error == nil else {
                print("failed to upload.")
                return
            }
            
        let db = Firestore.firestore()
            db.collection("images").document().setData(["url": path]) { error in
                if error == nil {
                    
                }
            }
           
        }
        self.imageView.image = image
        picker.dismiss(animated: true)
        self.dismiss(animated: true)
        self.navigationController?.popToRootViewController(animated: true)

        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        self.dismiss(animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    

}
