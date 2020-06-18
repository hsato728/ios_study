//
//  ViewController.swift
//  PhotoShare
//
//  Created by 佐藤浩樹 on 2020/06/11.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import NCMB

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos = NSMutableArray() // 写真リスト

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "TimeLineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeLineCollectionViewCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // ログインチェック
        self.loginCheck()
    }
    
    func loginCheck(){
        if (NCMBUser.current() != nil) {
            print("ログイン済み")
            self.fetchPhotos()
        } else {
            print("未ログイン")
            // ログイン画面へ遷移
            self.performSegue(withIdentifier: "toLogin", sender: nil)
        }
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        NCMBUser.logOut()
        self.loginCheck()
    }
    
    // 画像データ取得
    func fetchPhotos(){
        // データリセット
        photos = NSMutableArray()
        // クエリ1 FriendRequestテーブルから友達取得
        let friendQuery = NCMBQuery(className: "FriendRequest")
        friendQuery?.whereKey("from", equalTo: NCMBUser.current())
        friendQuery?.whereKey("status", equalTo: "accepted")
        // クエリ2 クエリ1の友達リストのtoのユーザがownerのPhotoデータを取得
        let photoQueryA = NCMBQuery(className: "Photo")
        photoQueryA?.whereKey("owner", matchesKey: "to", in: friendQuery)
        // クエリ3 ログインユーザがownerのPhotoデータを取得
        let photoQueryB = NCMBQuery(className: "Photo")
        // クエリ4 クエリ2とクエリ3をOR条件で取得
        photoQueryB?.whereKey("owner", equalTo: NCMBUser.current())
        let query = NCMBQuery.orQuery(withSubqueries: [photoQueryA!,photoQueryB])
        query?.findObjectsInBackground({(objects, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if (error == nil) {
                print("画像データ取得成功: \(String(describing: objects))")
                for photo in objects! {
                    // let p = photo as! Photo
                    let filename = (photo as AnyObject).object(forKey: "filename") as! String
                    print("ObjectId: \(String(describing: (photo as AnyObject).objectId)) filename: \(filename)")
                    self.photos.add(photo)
                }
                self.collectionView.reloadData()
            } else {
                print("画像データ取得失敗: \(String(describing: error))")
            }
        })
    }
    
    // コレクションビューのセクションの数を定義（今回は1つ）
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    // コレクションビューのアイテム数を定義（今回は取得画像分）
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    // コレクションビューのアイテムの表示要素を定義
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeLineCollectionViewCell", for: indexPath) as! TimeLineCollectionViewCell
        let photo = photos.object(at: indexPath.row) as! NCMBObject
        let user = photo.object(forKey: "owner") as! NCMBUser
        cell.userIdLabel.text = user.userName
        cell.postDateLabel.text = photo.object(forKey: "createDate") as? String
        
        if cell.imageView?.image == nil {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let fileData = NCMBFile.file(withName: photo.object(forKey: "filename") as! String, data: nil) as! NCMBFile
            fileData.getDataInBackground({(imageData, error) -> Void in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if error != nil {
                    print("写真の取得失敗\(String(describing: error))")
                } else {
                    cell.imageView?.image = UIImage(data: imageData!)
                    cell.layoutSubviews()
                }
            })
        }
        
        // いいね数更新
        fetchNumberOfLike(photo: photo,index:indexPath as NSIndexPath)
         // いいねボタン
         cell.likeButton.addTarget(self, action: #selector(ViewController.checkButtonTapped(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    // コレクションビューのアイテムのサイズを定義
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.view.frame.width
        return CGSize(width: size, height: size + 70)
    }
    
    @objc func checkButtonTapped(sender:UIButton) {
        // いいねボタンをタップしたPhotoデータを特定
        let buttonPosition = sender.convert(CGPoint.zero, to: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: buttonPosition)
        if indexPath != nil {
            print(indexPath!.row)
            // 特定したPhotoデータのいいね更新
            let photo = photos.object(at: indexPath!.row) as! NCMBObject
            addLike(photo: photo,index: indexPath! as NSIndexPath)
        }
    }

    // いいね追加
    func addLike(photo:NCMBObject,index:NSIndexPath){
        let like = NCMBObject(className: "Like")
        like?.setObject(NCMBUser.current(), forKey: "user")
        like?.setObject(photo, forKey: "photo")
        like?.saveInBackground({(error) in
            if (error != nil) {
                print("いいね保存失敗:\(String(describing: error))")
            }else{
                print("いいね保存成功")
                // アイテムの更新
                let cell = self.collectionView.cellForItem(at: index as IndexPath) as! TimeLineCollectionViewCell
                // いいねボタンを無効化
                cell.likeButton.isEnabled = false
                // いいね数取得
                self.fetchNumberOfLike(photo: photo, index: index)
            }
        })
    }
    // いいね数取得
    func fetchNumberOfLike(photo:NCMBObject,index:NSIndexPath){
        let query = NCMBQuery(className: "Like")
        query?.whereKey("photo", equalTo: photo)
        query?.findObjectsInBackground({(objects, error) in
            if (error == nil) {
                print("いいね数取得成功: \(String(describing: objects?.count))")
                // アイテム更新
                let cell = self.collectionView.cellForItem(at: index as IndexPath) as! TimeLineCollectionViewCell
                cell.likeLabel.text = "いいね \(objects!.count)人"
            } else {
                print("いいね数取得失敗: \(String(describing: error))")
            }
        })
    }

}

