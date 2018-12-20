//
//  ForUserDeaults.swift
//  GIF木頭人 重置
//
//  Created by 游宗諭 on 2018/12/18.
//  Copyright © 2018 游宗諭. All rights reserved.
//

import Foundation

class LocalDataBase{
	static let base = UserDefaults.standard
	
	enum ForKey:String {
		case 帳號 		 = "user"
		case 遊戲紀錄		 = "game"
		case 授權碼		 = "token"
		case 代幣餘額		 = "balance"
		case 成就		 = ""
	}
	static func resetData()
	{
		
	}
	static func getData(data: inout Any, key: ForKey)->Bool{
		if let user:String = UserDefaults.standard.object(forKey: "user") as? String{
			data = user
			return true
		}
		return false
	}
	
	class func checkData(src:String,for key: ForKey)->Bool{
		return false
	}
	//	class getData()
}
extension UserDefaults {
	var onboardingCompleted: Bool {
		get { return bool(forKey: #function) }
		set { set(newValue, forKey: #function) }
	}
}
