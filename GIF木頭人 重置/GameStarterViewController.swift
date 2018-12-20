//
//  GameStarterViewController.swift
//  GIF木頭人 重置
//
//  Created by 游宗諭 on 2018/12/18.
//  Copyright © 2018 游宗諭. All rights reserved.
//

import UIKit

class GameStarterViewController: UIViewController {

	let token = UserDefaults.standard.object(forKey: "token") as! String
	
	@IBOutlet weak var startGameButtom: UIButton!
	override func viewDidLoad() {
        super.viewDidLoad()
		if let balance:Int = UserDefaults.standard.object(forKey: "balance") as? Int
		{
			startGameButtom.isEnabled = balance > 10
		}
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: self, action: #selector(doDiss))
        // Do any additional setup after loading the view.
    }
	
	@objc func doDiss(sender: AnyObject) {
		print("about to dismiss")
		self.dismiss(animated: false, completion: nil)
	}
	@IBAction func buttonPressed(_ sender: UIButton) {
		let tuple = API.forDeduction(token: token )
		print("buttonPressed :", tuple)
		if tuple .0{
			UserDefaults.standard.set(Int(tuple.1) ?? 0, forKey: "balance")
			if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GIFGamingViewController") as? GIFGamingViewController {
				self.present(vc, animated: true, completion: {
					
				})
				//				self.presentedViewController!.dismiss(animated: false, completion: nil)
			}
			
//		let vc = GIFGamingViewController()
//		self.show(vc, sender: self)
		}
		else
		{
			print("token fail")
		}
	}
	
}
