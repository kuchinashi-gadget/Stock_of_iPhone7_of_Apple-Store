//
//  ViewController.swift
//  apple_store
//
//  Created by KosukeOkano on 2016/09/29.
//  Copyright © 2016年 岡野光祐. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let taget_url = "https://reserve.cdn-apple.com/JP/ja_JP/reserve/iPhone/availability.json"
    
    @IBOutlet weak var table_view: UITableView!
    
    @IBOutlet weak var title_label: UILabel!
    
    var iPhone_name_array = ["iPhone7 32GB\n ブラック","iPhone7 32GB\n シルバー","iPhone7 32GB\n ゴールド","iPhone7 32GB\n ローズゴールド","iPhone7 128GB\n ジェットブラック","iPhone7 128GB\n ブラック","iPhone7 128GB\n シルバー","iPhone7 128GB\n ゴールド","iPhone7 128GB\n ローズゴールド","iPhone7 256GB\n ジェットブラック","iPhone7 256GB\n ブラック","iPhone7 256GB\n シルバー","iPhone7 256GB\n ゴールド","iPhone7 256GB\n ローズゴールド","iPhone7+ 32GB\n ブラック","iPhone7+ 32GB\n シルバー","iPhone7+ 32GB\n ゴールド","iPhone7+ 32GB\n ローズゴールド","iPhone7+ 128GB\n ジェットブラック","iPhone7+ 128GB\n ブラック","iPhone7+ 128GB\n シルバー","iPhone7+ 128GB\n ゴールド","iPhone7+ 128GB\n ローズゴールド","iPhone7+ 256GB\n ジェットブラック","iPhone7+ 256GB\n ブラック","iPhone7+ 256GB\n シルバー","iPhone7+ 256GB\n ゴールド","iPhone7+ 256GB\n ローズゴールド",]
    
    var iPhone_model_number_array = ["MNCE2J/A","MNCF2J/A","MNCG2J/A","MNCJ2J/A","MNCP2J/A","MNCK2J/A","MNCL2J/A","MNCM2J/A","MNCN2J/A","MNCV2J/A","MNCQ2J/A","MNCR2J/A","MNCT2J/A","MNCU2J/A","MNR92J/A","MNRA2J/A","MNRC2J/A","MNRD2J/A","MN6K2J/A","MN6F2J/A","MN6G2J/A","MN6H2J/A","MN6J2J/A","MN6Q2J/A","MN6L2J/A","MN6M2J/A","MN6N2J/A","MN6P2J/A"]
    
    let store_name_array = ["心斎橋","仙台一番町","名古屋栄","渋谷","福岡天神","表参道","銀座"]
    let store_code_array = ["R091","R150","R005","R119","R048","R224","R079"]
    
    
    var iphone_object_arry = [iPhone_object]()
    
    let rs = Read_setting()
    var apple_store_no = 0
    
    var apple_store_code = ""
    
    var myActivityIndicator: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        table_view.delegate = self
        table_view.dataSource = self

        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        apple_store_no = rs.read_setting()
        apple_store_code = store_code_array[apple_store_no]
        
        title_label.text = "AppleStore" + store_name_array[apple_store_no] + "店の\niPhone7の在庫状況"
        
        get_json()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 6. 必要なtableViewメソッド
    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iphone_object_arry.count
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
        let hantei_label = cell.viewWithTag(2) as! UILabel
        let data_label = cell.viewWithTag(3) as! UILabel
        
        
        var tmp_object = iphone_object_arry[indexPath.row]
        
        
        name_label.text = tmp_object.iPhone_name
        hantei_label.text = tmp_object.zaiko_joukyou
        data_label.text = tmp_object.result
        
        
        return cell
    }
    
    @IBAction func reload_button_pushed(_ sender: AnyObject) {
        
        get_json()
    }

    @IBAction func setting_button_pushed(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "segue1",sender:nil)
    }
    
    
    func get_json(){
        
        start_Indicator()
        
        Alamofire.request(taget_url).responseJSON { response in

            
            if let JSON = response.result.value {
                
                
                self.iphone_object_arry.removeAll()
                
                var jsonDic = JSON as! NSDictionary
                
                let responseData = jsonDic[self.apple_store_code] as! NSDictionary
                
                if responseData != nil{
                
                
                    for s in (0..<self.iPhone_model_number_array.count){
                        
                        var iphone_object = iPhone_object()
                        
                        let responseData1 = responseData[self.iPhone_model_number_array[s]] as! String
                        
                        if responseData1 != nil {
                            iphone_object.result = responseData1
                            
                            if responseData1 == "NONE" || responseData1 == "null"{
                                iphone_object.zaiko_joukyou = "x"
                                
                            }else {
                                iphone_object.zaiko_joukyou = "○"
                            }
                            iphone_object.iPhone_model_number = self.iPhone_model_number_array[s]
                            iphone_object.iPhone_name = self.iPhone_name_array[s]
                            
                            
                            self.iphone_object_arry.append(iphone_object)
                        }

                    }

 
                }
                
                //配列の再表示
                self.table_view.reloadData()
                self.table_view.setContentOffset(CGPoint(x: 0,y :0), animated: false)
                
                self.stop_Indicator()

                
            }
        }
    }
    
    /////////////////////////
    //インジケーターの設定
    /////////////////////////
    
    func start_Indicator(){
        
        
        
        // インジケータを作成する.
        myActivityIndicator = UIActivityIndicatorView()
        myActivityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        myActivityIndicator.center = self.view.center
        
        // アニメーションが停止している時もインジケータを表示させる.
        myActivityIndicator.hidesWhenStopped = true
        //myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        //myActivityIndicator.color = UIColor.redColor()
        
        myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        myActivityIndicator.backgroundColor = UIColor.gray
        myActivityIndicator.layer.masksToBounds = true
        myActivityIndicator.alpha = 0.6
        myActivityIndicator.layer.cornerRadius = 5.0
        myActivityIndicator.layer.opacity = 0.8
        
        // アニメーションを開始する.
        myActivityIndicator.startAnimating()
        
        // インジケータを表示する
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // インジケータをViewに追加する.
        self.view.addSubview(myActivityIndicator)
        
        
        
    }
    
    func stop_Indicator(){
        
        
        
        // インジケータを表示する
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        
        myActivityIndicator.stopAnimating()
        
        
        
    }


}

