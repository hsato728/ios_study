//
//  SecondViewController.swift
//  Pedometer
//
//  Created by 佐藤浩樹 on 2020/06/09.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class SecondViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView! // GoogleMap用のView
    
    //Location Manager
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //地図を初期化
        self.initMapView()
        //位置情報取得準備
        self.initLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initLocation() {
        //Location Managerの設定
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //位置情報取得開始
        locationManager.startUpdatingLocation()
    }
    
    //位置情報が更新された時呼ばれるメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        //ラベルを更新
        longitudeLabel.text = String(format: "%f", newLocation.coordinate.longitude)
        latitudeLabel.text = String(format: "%f", newLocation.coordinate.latitude)
        //誤差値
        let accuracy = newLocation.horizontalAccuracy
        //誤差のラベルを更新
        if (accuracy < 15) {
            accuracyLabel.text = String(format: "高 (%.0f m)", accuracy)
        } else {
            accuracyLabel.text = String(format: "低 (%.0f m)", accuracy)
        }
        
        // GoogleMapに現在位置を表示するために現在位置情報を渡す
            let pos : GMSCameraPosition = GMSCameraPosition.camera(
                withLatitude: newLocation.coordinate.latitude, // 緯度
                longitude: newLocation.coordinate.longitude, // 経度
                zoom: 16.0 // ズーム（0 - 19）数が大きいほどクローズアップ
            )
            mapView.camera = pos
        }
        
        func initMapView() {
            mapView.isMyLocationEnabled = true
            mapView.delegate = self
        }
    //位置取得失敗時に呼ばれるメソッド
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let message = "位置情報の取得に失敗しました。"
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) -> Void in
            print("後で")
        }
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
}
