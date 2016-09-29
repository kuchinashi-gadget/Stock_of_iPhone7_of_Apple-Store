//
//  SetteingViewController.swift
//  apple_store
//
//  Created by KosukeOkano on 2016/09/29.
//  Copyright © 2016年 岡野光祐. All rights reserved.
//

import UIKit

class SetteingViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    let store_name_array = ["心斎橋","仙台一番町","名古屋栄","渋谷","福岡天神","表参道","銀座"]
    let store_code_array = ["R091","R150","R005","R119","R048","R224","R079"]
    
    let rs = Read_setting()
    
    var apple_store_no = 0
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var table_view: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        apple_store_no = rs.read_setting()
        
        print("apple_store_no:" + String(apple_store_no))

        table_view.delegate = self
        table_view.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 6. 必要なtableViewメソッド
    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store_name_array.count
    }
    
    //セルの高さを決める
    func tableView(_ table_view: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 80
    }
    
    // 6. 必要なtableViewメソッド
    // セルのテキストを追加
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table_view.dequeueReusableCell(withIdentifier: "Cell" ,for: indexPath)
        
        let name_label = cell.viewWithTag(1) as! UILabel
        let image_label = cell.viewWithTag(2) as! UIImageView
        
        if apple_store_no == indexPath.row {
            
            let myimage = UIImage(named: "check")
            image_label.image = myimage
            
            image_label.isHidden = false
            
        }else{
            image_label.image = nil
            
            image_label.isHidden = true
//            let myimage = UIImage(named: "check")
//            image_label.image = myimage
//            
//            image_label.isHidden = false
        }
        
        name_label.text = store_name_array[indexPath.row]
        
        
        return cell
    }
    
//    // 7. セルがタップされた時
//    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
//        
//        print("セルタップされる")
//        apple_store_no = indexPath.row
//    
//        table_view.reloadData()
//        
//        
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Num: \(indexPath.row)")
        
        apple_store_no = indexPath.row

        table_view.reloadData()
    }

    
    @IBAction func return_button_pushed(_ sender: AnyObject) {
        
        rs.write_setting(NO: apple_store_no)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
