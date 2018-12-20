//
//  GIFGamingViewController.swift
//  GIF木頭人 重置
//
//  Created by 游宗諭 on 2018/12/18.
//  Copyright © 2018 游宗諭. All rights reserved.
//

import UIKit

class GIFGamingViewController: UIViewController {
	
	@IBOutlet weak var progressLabel: UILabel!
	@IBOutlet weak var questLabel: UILabel!
	@IBOutlet weak var countProgress: UIProgressView!
	@IBOutlet weak var gifImageView: UIImageView!
	
	let total = 10
	var answer = 0
	var show = 0
	var range = (0...8).lazy
	var count = 1
	var score = 0
	var timer = Timer()
	var picSeed = 99
	var balance = 0
	var isSpecial = false
	var specialCount = 0
	var imageArray :[UIImage] = [UIImage(named: "pic1")!,UIImage(named: "pic2")!,UIImage(named: "pic3")!,UIImage(named: "pic4")!,UIImage(named: "pic5")!,UIImage(named: "pic6")!,UIImage(named: "pic7")!,UIImage(named: "pic8")!,UIImage(named: "pic9")!]
	var imageName = ["Beer","Camel","Cat","Girl","Boy","Owl","Pancake","Car","Flower"]
	
	///確定按鈕的功能，每按一次增加次數，到達次數的邊界時，啟動警告視窗，警告視窗將直接帶離畫面
	@IBAction func buttomPressed(_ sender: UIButton) {
		count += 1
		progressLabel.text = "已完成：\(count - 1)"
		score = (answer == show) ? score + 1: score
		specialCount = (isSpecial) ? specialCount + 1 : specialCount
		countProgress.progress = Float(count) / Float(total)
		if count != total
		{
			answer = range.randomElement() ?? 0
			questLabel.text = "Find \(imageName[answer])"
		}
		else
		{
			timer.invalidate()
			count +=  specialCount
			let title = (score > 5) 		? "大成功" 						: "遊戲結束!"
			let event = (specialCount > 0 ) ? "找到了\(specialCount)個矮人"   : ""
			self.setUserDefaults()
			let alert = UIAlertController(title: title, message: "你得到 \(score) 分!  " + event, preferredStyle: .alert)
			let alertaction = UIAlertAction(title: "OK", style: .destructive) { (alertAction) in
				self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
			}
			alert.addAction(alertaction)
			self.present(alert, animated: false, completion: nil)
		}
	}
	
	///完成遊戲時儲存遊戲資料到資料庫，包含時間與分數
	func setUserDefaults()
	{
		print("start setUserDefaults")
		let date = Date()
		let timeformatter = DateFormatter()
		timeformatter.dateFormat = "yyyy年MM月dd日 HH:mm"
		let userDefaults = UserDefaults.standard
		let gameData = [String("日期： " + timeformatter.string(from: date)),"得分： " +  String(score)]
		if var tmp:[[String]] = userDefaults.object(forKey: "game") as? [[String]]
		{
			if tmp.first?.first != "尚未開始遊戲"	 {tmp.insert(gameData, at: 0)}
			else								 {tmp = [gameData] }
			
			userDefaults.set(tmp, forKey: "game")
		}
		else
		{
			userDefaults.set([gameData], forKey: "game")
		}
		if var special:Int = userDefaults.object(forKey: "dwaft") as? Int
		{
			special += specialCount
			let token = userDefaults.object(forKey: "token") as? String
			if special == 20 && API.forTheDwaft(token: token!).0 {print("達成成就！")}
		}
		else { userDefaults.set(specialCount, forKey: "dwaft")}
		
	}
	
	///以定時器的方法設定動畫
	func setGIF()
	{
		timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GIFGamingViewController.runAni), userInfo: nil, repeats: true)
	}
	
	///設定計時器啟動時，每次迭代的動作，這裡同時間啟動特殊小矮人
	@objc func runAni(){
		isSpecial = false
		picSeed = (picSeed > 0) ? picSeed - 1 : 99
		show = picSeed % 9
		let date = Date()
		let calendar = Calendar.current
		let second = calendar.component(.second, from: date) % 10
		if second == answer{
			print("About to get dwarf.jpg")
			isSpecial = true
			questLabel.text = "Hey it's a dwarf!"
			gifImageView.image =  UIImage(named: "dwarf")
		}
		else
		{
			questLabel.text = "Find \(imageName[answer])"
			gifImageView.image =  imageArray[show]}
	}
	
	///每當頁面啟動時設定Label, progress, 設定動畫與嘗試取得系統餘額
	override func viewDidLoad() {
		super.viewDidLoad()
		questLabel.text = "Find \(imageName[answer])"
		progressLabel.text = "已完成：\(count - 1)"
		countProgress.transform = countProgress.transform.scaledBy(x: 1, y: 10)
		setGIF()
		if let tmp:Int = UserDefaults.standard.object(forKey: "balance") as? Int
		{
			UserDefaults.standard.set(tmp, forKey: "balance")
//			print("change balance")
		}
		else { print("Can't load balance")}
		
	}
}
