//
//  API.swift
//  GIF木頭人 重置
//
//  Created by 游宗諭 on 2018/12/18.
//  Copyright © 2018 游宗諭. All rights reserved.
//

import Foundation

class API{
	static var address : String {get{return "http://ead729ee.ngrok.io/"}}
	static var apiUrl : String {get{return address + "api/"}}
	
	enum requestType:String {
		case 註冊 		= "register"
		case 登入 		= "login"
		case 找到小矮人	= "findTheLittleMan"
		case 個人資料區	= "profile"
		case 扣點數 		= "deduction"
		case 個人成就		= "personalAccomplishment"
		case 儲值成就		= ""
	}
	static func signUp(account:String,password:String,password_confirmation:String)	->(Bool, String) {
		let data: [String: String] = [
			"email" : account,
			"password" : password,
			"password_confirmation" : password_confirmation
		]
		let tuple = sentRequest(info: data, type: .註冊)
		guard let message 	= tuple.1["response"] 	else {return (false, "NetWork Unable")}
//		guard let token	 	= tuple.1["token"] 		else {return (false, message, "")}
		return (tuple.0, message)
	}
		///回傳成功，訊息，ＴＯＫＥＮ
	static func logIn(account:String,password:String)								->(Bool, String,String) {
		let data: [String: String] = ["email" : account,"password" : password]
		let tuple = sentRequest(info: data, type: .登入)
		guard let message 	= tuple.1["response"] 	else {return (false, "NetWork Unable", "")}
		guard let token 	= tuple.1["token"] 		else {return (false, message, "")}
		return (tuple.0, message, token)
		
	}
	static func forTheDwaft(token:String)											->(Bool, String, String) {
		let data = ["token": token,
					"game": "gifStop",
					"accomplishment": "findTheLittleMan"]
		let tuple =  sentRequest(info: data, type: .找到小矮人)
		guard let message 	= tuple.1["response"] 			else {return (false, "NetWork Unable", "")}
		guard let note 	= tuple.1["findTheLittleMan"] 		else {return (false, "NetWork Unable", "")}
		return (tuple.0, message, note)
		
	}
	///bool, point, array
	///	re = (bool, ["RemainingPoint":"\(balance)","FindLittleMan":statusAccomplishment[0],"YouAreFilthyRich": statusAccomplishment[1]])
	static func forProfile(token:String)											->(Bool, Int, [String]) {
		let data = ["token":token,"game":"gifStop"]
		let tuple =  sentRequest(info: data, type: .個人資料區)
		guard let point 	= tuple.1["RemainingPoint"] 			else {return (false, 0, [])}
		guard var dic		= tuple.1		as? [String:String]		else {return (false, Int(point) ?? 0, [])}
		var mytuple:[String] = []
		dic.removeValue(forKey: "RemainingPoint")
		for (k,v) in dic
		{
			UserDefaults.standard.set(v, forKey: k)
			mytuple.append(k + " : " + v)
		}
		return (tuple.0, Int(point) ?? 0, mytuple)
		
	}
	static func forDeduction(token:String)											->(Bool, String) {
		let data = ["token":token,"game":"gifStop"]
		let tuple = sentRequest(info: data, type: .扣點數)
		print("forDuction: ", tuple)
		let tmp = tuple.1["response"] ?? ""
		return (tuple.0, tmp)
	}
	
	static func personalAccomplishment(token:String) 								->(Bool, String){
		let data = ["token":token,"game":"gifStop","accomplishment":"APerfectScore"]
		let tuple = sentRequest(info: data, type: .個人成就)
		print("forDuction: ", tuple)
		let tmp = tuple.1["response"] ?? ""
		return (tuple.0, tmp)
	}
	
	private class func sentRequest(info:[String:String], type:API.requestType)		->(Bool, [String:String]) {
		var isOK = false
		let data = try? JSONSerialization.data(withJSONObject: info, options: [])
		var re = (false, [:])
		if let url = URL(string: API.apiUrl + type.rawValue) {
			var request = URLRequest(url: url)
			request.httpBody = data
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpMethod = "POST"
			
			URLSession.shared.dataTask(with: request) { (data, response, error) in
				print("type: ", type.rawValue ,error?.localizedDescription)
				print("type: ",type.rawValue ,data)
				print("type: ",type.rawValue ,(response as? HTTPURLResponse)?.statusCode)
				guard let data1 = data else { return }
				if type == API.requestType.個人資料區 {
					let json = try? JSONSerialization.jsonObject(with: data1, options: []) as? [String:Any]
					var bool = false
					var balance = 0
					var Accomplishment = ["":""]
					var statusAccomplishment = ["","",""]
					for (key, value) in json!!
					{
						if key == "result"{ bool = ( value as? String == "true") ? true:false}
						if key == "response" {
							if let dic = value as? [String:Any]{
								for (key2, value2) in dic {
									if key2 == "Accomplishment" {Accomplishment = (value2 as? [String:String])!}
									if key2 == "RemainingPoint" {balance = (value2 as? Int)!}
								}}
						}
					}
					for(key, value) in Accomplishment
					{
						if key == "FindLittleMan"	 { statusAccomplishment[0] = ( value == "true") ? "完成":"未完成"}
						if key == "YouAreFilthyRich" { statusAccomplishment[1] = ( value == "true") ? "完成":"未完成"}
						if key == "APerfectScore"	 { statusAccomplishment[2] = ( value == "true") ? "完成":"未完成"}
					}
					isOK = true
					//					print("type: " ,type.rawValue,"\n\n" ,json,"\n\n")
					//					print("個人資料 bool:",bool,"餘額：", balance, "Accomplishment:",Accomplishment)
					re = (bool, ["RemainingPoint":"\(balance)","FindLittleMan":statusAccomplishment[0],"YouAreFilthyRich": statusAccomplishment[1],"APerfectScore":statusAccomplishment[2]])
				}
				else if type == API.requestType.扣點數{
					let json = try? JSONSerialization.jsonObject(with: data1, options: []) as? [String:Any]
					var bool = false
					var balance = ""
					for (key, value) in json!!
					{
						if key == "result"{ bool = ( value as? String == "true") ? true:false}
					}
					for (key, value) in json!!
					{
						if key == "response" {balance = (bool) ? String(value as? Int ?? 0) : (value as? String)!}
					}
					isOK = true
					re = (bool,  ["response":balance])
				}
					
				else{
					let json = try? JSONSerialization.jsonObject(with: data1, options: []) as? [String:String]
					print("type: " ,type.rawValue,"\n\n" ,json, "\n\n")
					let bool = ((json??["result"]) == "true") ? true:false
					isOK = true
					print("type: " ,type.rawValue ,"bool = " , bool)
					//let dic = json!
					re = (bool, json! ?? [:])
				}
				}.resume()
		}
		while !isOK {
		}
		print("line 92 : ", type.rawValue , info,"\n re =",re)
		return re as! (Bool, [String : String])
	}
}
