//
//  HomeViewController.swift
//  GIF木頭人 重置
//
//  Created by 游宗諭 on 2018/12/18.
//  Copyright © 2018 游宗諭. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
	
	///取得UserDefaults的使用者資料
	var user 	= UserDefaults.standard.object(forKey: "user" ) as? String
	///取得UserDefaults的token資料
	var token 	= UserDefaults.standard.object(forKey: "token") as? String
	///設定成就資料
	var Accomplishment:[String] = []

	///『開始』按鈕
	@IBOutlet weak var StartGameButtom: UIButton!
	///『歷史紀錄』按鈕
	@IBOutlet weak var recordButton: UIButton!
	
	///首頁頁面第一次開始時的動作
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	///每次回到首頁時重做user與token的查詢，只要user沒有，將開始按鈕和歷史按鈕失效
	override func viewWillAppear(_ animated: Bool) {
		if let user:String = UserDefaults.standard.object(forKey: "user") as? String{
			token = UserDefaults.standard.object(forKey: "token") as? String
			
			if user.isEmpty	{	showAlert()	}
			StartGameButtom .isEnabled = !user.isEmpty
			recordButton	.isEnabled = !user.isEmpty
		}
	}
	func showAlert(){
		let aleat = UIAlertController(title: "請登入", message: "", preferredStyle: .alert)
		aleat.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.present(aleat, animated: true, completion: nil)
	}
}
