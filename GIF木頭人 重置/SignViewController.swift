//
//  SignViewController.swift
//  GIF木頭人 重置
//
//  Created by 游宗諭 on 2018/12/18.
//  Copyright © 2018 游宗諭. All rights reserved.
//

import UIKit

class SignViewController: UIViewController, UITextFieldDelegate {
	
	@IBOutlet weak var comfirmLabel: UILabel!
	@IBOutlet weak var accountTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var confirmPasswordTextFiled: UITextField!
	@IBOutlet weak var logInButtom: UIButton!
	@IBOutlet weak var signUpButtom: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	override func viewDidLoad() {
		super.viewDidLoad()
		comfirmLabel.isHidden = true
		
		accountTextField		.delegate = self
		passwordTextField		.delegate = self
		confirmPasswordTextFiled.delegate = self
		
		confirmPasswordTextFiled.isHidden = true
		cancelButton			.isHidden = true
		UserDefaults.standard.set(""								, forKey: "user")
		UserDefaults.standard.set(0									, forKey: "balance")
		UserDefaults.standard.set([["尚未開始遊戲","回主畫面開始遊戲"]]	, forKey: "game")
		UserDefaults.standard.set(0									, forKey: "dwaft")
		
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: self, action: #selector(doDiss))
		// Do any additional setup after loading the view.
	}
	
	@objc func doDiss(sender: AnyObject) {
		self.dismiss(animated: false, completion: nil)
	}
	
	@IBAction func ButtomPressed(_ sender: UIButton) {
		let account = accountTextField.text ?? ""
		let pwd = passwordTextField.text ?? ""
		var re = (false,"","")
		var profileRe = (false, 0, [""])
		var isInfoSafe = pwd.count > 5 && account.contains("@") && account.contains(".com")
		switch sender.tag {
		case 0: ///登入
			if isInfoSafe{
				print("Send  user: \(account), pwd:\(pwd) to server.")
				//ＴＯＤＯ撈資料庫登入
				re = API.logIn(account: account, password: pwd)
				//				if re.0 { re = API.logIn(account: account, password: pwd)}
				if re.0 { profileRe = API.forProfile(token: re.2)}
				//				profileRe = API.forProfile(token: re.2)
				
			}
		case 1:
			if !(logInButtom.isHidden){
				logInButtom.isHidden = !logInButtom.isHidden
				comfirmLabel.isHidden = !comfirmLabel.isHidden
				confirmPasswordTextFiled.isHidden = !confirmPasswordTextFiled.isHidden
				cancelButton.isHidden = !cancelButton.isHidden
				return
				
			}
			else ///註冊
			{
				guard let secondPwd = confirmPasswordTextFiled.text else {break}
				isInfoSafe =   isInfoSafe &&  pwd == secondPwd
				
				//TODO: API change isInfoSafe
				
				if isInfoSafe {
					let tmp = API.signUp(account: account, password: pwd, password_confirmation: secondPwd)
					re.0 = tmp.0
					re.1 = tmp.1
					if re.0 { re = API.logIn(account: account, password: pwd)}
					if re.0 { profileRe = API.forProfile(token: re.2)}
				}
			}
		case 2:
			logInButtom				.isHidden 	= !logInButtom.isHidden
			comfirmLabel			.isHidden	= !comfirmLabel.isHidden
			confirmPasswordTextFiled.isHidden 	= !confirmPasswordTextFiled.isHidden
			cancelButton			.isHidden	= !cancelButton.isHidden
			return
		default:
			print("Error, SignVC.Buttom Sender go default.")
		}
		print("signVC 的 Token is ",profileRe)
		let alearMessage = isInfoSafe && re.0 ? ["成功",re.1] : ["輸入資料錯誤",re.1]
		var action = UIAlertAction()
		action = (UIAlertAction(title: "OK", style: .default, handler: { (action) in
			if re.0 //&& profileRe.0
			{
				UserDefaults.standard.set(account, 		forKey: "user")
				UserDefaults.standard.set(re.2, 		forKey: "token")
				UserDefaults.standard.set(profileRe.1,	forKey: "balance")
				UserDefaults.standard.set(profileRe.2,	forKey: "Accomplishment")
				self.dismiss(animated: false, completion: nil)
			}
		}))
		let alert = UIAlertController(title: alearMessage.first, message: alearMessage.last, preferredStyle: .alert)
		alert.addAction(action)
		self.present(alert, animated: false, completion: nil)
	}
}
