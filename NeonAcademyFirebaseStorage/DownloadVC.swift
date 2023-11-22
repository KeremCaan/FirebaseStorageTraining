//
//  DownloadVC.swift
//  NeonAcademyFirebaseStorage
//
//  Created by Kerem Caan on 15.08.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class DownloadVC: UIViewController {
    
    let urlLabel: UILabel = UILabel()
    let imageView: UIImageView = UIImageView()
    let downloadButton: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

       configureUI()
       retrieveData()
    }

    func configureUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.image = UIImage(systemName: "person.fill")
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(100)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(300)
        }
        
        view.addSubview(urlLabel)
        urlLabel.text = "deneme"
        urlLabel.numberOfLines = 0
        urlLabel.textAlignment = .center
        urlLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(75)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        view.addSubview(downloadButton)
        downloadButton.setTitle("Download Photo.", for: .normal)
        downloadButton.backgroundColor = .blue
        downloadButton.titleLabel?.numberOfLines = 0
        downloadButton.addTarget(self, action: #selector(downloadPhotos), for: .touchUpInside)
        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(250)
            make.centerX.equalToSuperview()
            make.width.equalTo(75)
        }
    }
    
        private func saveImageToGallery(image: UIImage) {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_: didFinishSavingWithError: contextInfo:)), nil)
            }

            @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Image saved successfully to gallery.")
                }
            }
    
    func retrieveData() {
        let storageRef = Storage.storage().reference()
        let mediaFolder = storageRef.child("images")
        
        if let data = imageView.image?.pngData() {
            let imageRef = mediaFolder.child("image.png")
            
            imageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if error == nil && data != nil {
                    let image = UIImage(data: data!)
                        self.imageView.image = image
                }
            }
            imageRef.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.urlLabel.text = url?.absoluteString
                }
            }
        }
    }
    
   @objc func downloadPhotos() {
  
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child("images/image.png")

                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        if error == nil && data != nil {
                            let image = UIImage(data: data!)
                                DispatchQueue.main.async {
                                    self.imageView.image = image
                                    self.saveImageToGallery(image: image!)
                                }
                        }
                    }

                }
                
            }
        
    


