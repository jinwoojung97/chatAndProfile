//
//  JoinView+Image.swift
//  ZeplinProject
//
//  Created by inforex on 2021/07/27.
//

import Foundation
import UIKit


extension JoinView : UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    //이미지뷰 클릭
    func pickImage(){
        photo.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.screenDidTap))
        profileImageView.addGestureRecognizer(tap)
        pickImageView.addGestureRecognizer(tap)
    }
    
    //사진선택
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //사진선택하기
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            profileImageView.image = image
            selectImage = image
        }
        // 사진 선택하면 닫아주기
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func screenDidTap(){
        photo.sourceType = .photoLibrary
        App.visibleViewController()?.present(self.photo, animated: true, completion: nil) //사진앨범 띄우기
    }
    

}
