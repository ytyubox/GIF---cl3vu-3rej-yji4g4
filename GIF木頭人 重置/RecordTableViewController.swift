//
//  RecordTableViewController.swift
//  GIF木頭人 重置
//
//  Created by 游宗諭 on 2018/12/18.
//  Copyright © 2018 游宗諭. All rights reserved.
//

import UIKit

class RecordTableViewController: UITableViewController {
	
	var list:[[String]] = UserDefaults.standard.object(forKey: "game") as! [[String]]
	let balance:Int = UserDefaults.standard.object(forKey: "balance") as! Int
	var token = UserDefaults.standard.object(forKey: "token") as? String
	var Accomplishment:[String] = []
	
	@objc func doDiss(sender: AnyObject) {
//		print("about to dismiss")
		self.dismiss(animated: false, completion: nil)
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: self, action: #selector(doDiss))
		if let tmp = API.forProfile(token: token!) as? (Bool, Int, [String]) {
			Accomplishment = tmp.2}
//		if let tmp = API.personalAccomplishment(token: token) {
//			if Accomplishment
//		}
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		switch section {
		case 0:
			return 1
		case 1:
			return Accomplishment.count
		case 2:
			return list.count
		default:
			return 0
		}
//		return 0
    }

    /*
	*/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			let cell = UITableViewCell()
			cell.textLabel?.text = "餘額：\(balance)元"
			return cell
		case 1:
			let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)
			let key = Accomplishment[indexPath.row]
			cell.textLabel?.text = "成就：" + key
			cell.detailTextLabel?.text = UserDefaults.standard.object(forKey: key) as? String
			return cell
		case 2:
			let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)
			cell.textLabel?.text = "\(indexPath.row  + 1). " + list[indexPath.row].first!
			cell.detailTextLabel?.text = "\t" + list[indexPath.row].last!
			return cell
		default:
			return UITableViewCell()
		}

        // Configure the cell...

    }

	func getMark() -> Bool
	{
		guard let tmp = UserDefaults.standard.object(forKey: "game") as? [[String]] else { return false }
		for i in tmp
		{
			let tmp = i.last ?? ""
			if Int(tmp) == 10
			{
				return true
			}
		}
		return false
		
	}
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
