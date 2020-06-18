//
//  ImagePickerViewController.swift
//  PhotoShare
//
//  Created by 佐藤浩樹 on 2020/06/16.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit

class ImagePickerViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var pickedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pickImageFromCamera(sender: AnyObject) {

        // カメラ起動
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerController.SourceType.camera
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func pickImageFromLibrary(sender: AnyObject) {
        // アルバム起動
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    // 写真を選択した時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[UIImagePickerController.InfoKey.originalImage] != nil {
            pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            performSegue(withIdentifier: "toPostImage", sender: nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    // 画面遷移時
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostImage" {
            // 次の画面に取得した画像を渡す
            let vc = segue.destination as! ImagePostViewController
            vc.pickedImage = self.pickedImage
        }
    }
}
