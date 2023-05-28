//
//  HomeViewController.swift
//  20230516_KebukeAPP
//
//  Created by Yen Lin on 2023/5/16.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailPriceLabel: UILabel!
    @IBOutlet weak var detailDescTextView: UITextView!
    
    @IBOutlet weak var capacitySegmentControl: UISegmentedControl!
    @IBOutlet weak var iceButton: UIButton!
    @IBOutlet weak var sugarButton: UIButton!
    @IBOutlet weak var extraButton: UIButton!
    @IBOutlet weak var inputNameTextField: UITextField!
    
    @IBOutlet weak var AddButton: UIButton!
    
    //容量 Segment Control
    let capacity = ["中杯", "大杯"]
    
    //要上傳的訂單資料
    var orders = [uploadFields]()
    
    //飲料容量價錢
    var selectSizePrice: Int = 0
    
    //飲料加料價錢
    var selectExtraPrice: Int = 0
    
    //飲料圖片網址
    var imgString: String!
    
    //上一頁傳來的飲料資訊
    let detailDrink: Fields
    
    required init?(coder: NSCoder, detailDrink: Fields) {
        self.detailDrink = detailDrink
        super.init(coder: coder)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //選定飲料資訊顯示
        mainUI()

        //設定輸入框顏色樣式
        setTextFieldColor()

        //下拉選單 冰塊、糖度、加料
        setDropDownMenu(buttonName: iceButton)
        setDropDownMenu(buttonName: sugarButton)
        setDropDownMenu(buttonName: extraButton)

        //設定選中時的文字顏色
        capacitySegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)

        //設定未選中時的文字顏色
        capacitySegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        
        
    }
    
    //頁面主要資訊 - 選定飲料
    func mainUI(){
  
        navigationItem.title = detailDrink.fields.drinks
        
        imgString = detailDrink.fields.img_url
        let imgUrl = URL(string: imgString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)

        detailImageView.kf.setImage(with: imgUrl)
        detailPriceLabel.text = "中：\(detailDrink.fields.med_price) / 大：\(detailDrink.fields.large_price)"
        detailDescTextView.text = detailDrink.fields.desc
        
        selectSizePrice = detailDrink.fields.med_price
        
        //訂購按鈕預設顯示 中杯飲料價錢
        AddButton.setTitle("訂購 ($\(selectSizePrice.description))", for: .normal)

    }
    

    
    //訂購人輸入Text Field樣式設定
    func setTextFieldColor(){
        let placeholderText = "請輸入您的姓名"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14),
            .paragraphStyle: paragraphStyle
        ]

        inputNameTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        
        inputNameTextField.textAlignment = .center

    }
    
    //容量大小 Segment Control 改變價錢
    @IBAction func changeCapacity(_ sender: UISegmentedControl) {
        switch capacitySegmentControl.selectedSegmentIndex{
        case 0:
            selectSizePrice = detailDrink.fields.med_price
        case 1:
            selectSizePrice = detailDrink.fields.large_price
        default:
            selectSizePrice = detailDrink.fields.med_price
        }
        updatePriceUI()
    }
    
    
    
    
    
    //更多選項 下拉選單
    func setDropDownMenu(buttonName: UIButton){
        
        var selectArray = [String]()
        var menuActions = [UIAction]()
        
        //根據UIButton Name 選擇飲料細項
        switch buttonName{
        case iceButton:
            selectArray = ["正常冰","少冰","微冰","去冰","完全去冰","常溫","溫","熱"]
        case sugarButton:
            selectArray = ["正常糖","少糖","半糖","微糖","兩分糖","一分糖","無糖"]
        case extraButton:
            selectArray = ["無", "白玉", "水玉", "甜杏"]
        default:
            selectArray = []
        }

        buttonName.showsMenuAsPrimaryAction = true
        buttonName.changesSelectionAsPrimaryAction = true
        buttonName.layer.cornerRadius = 5
        buttonName.layer.masksToBounds = true
        
        selectExtraPrice = 0
        
        //下拉選單的選項
        for selectItems in selectArray{
            menuActions.append(UIAction(title: selectItems, state: .on, handler: { action in
                
                //判斷有沒有加料要加錢
                switch action.title {
                case "白玉":
                    self.selectExtraPrice = 10
                case "水玉":
                    self.selectExtraPrice = 10
                case "甜杏":
                    self.selectExtraPrice = 15
                default: self.selectExtraPrice = 0
                }
                self.updatePriceUI()

            }))
        }

        buttonName.menu = UIMenu(children: menuActions)

    }
    
    //訂購按鈕的價錢
    func updatePriceUI(){
        AddButton.setTitle("訂購 ($\(selectSizePrice + selectExtraPrice))", for: .normal)
    }
    
    
    @IBAction func addToCart(_ sender: Any) {
        
        
        let selectCapacity = capacity[capacitySegmentControl.selectedSegmentIndex]
        
        let selectedDrink = detailDrink.fields.drinks
        
        if let selectedIce = iceButton.titleLabel?.text,
           let selectedSugar = sugarButton.titleLabel?.text,
           let selectedExtra = extraButton.titleLabel?.text,
           let inputName = inputNameTextField.text,
           inputName.count != 0 {

            //飲料訂購確認通知
            let confirmMessage = "\(selectedDrink), \(selectCapacity)\n \(selectedIce), \(selectedSugar), 加料：\(selectedExtra),\n 訂購人：\(inputName),\n $\(selectSizePrice + selectExtraPrice)"
            
            let controller = UIAlertController(title: "訂購確認", message: confirmMessage, preferredStyle: .alert)
            
            //確認
            let okAction = UIAlertAction(title: "確認", style: .default) { _ in
                
                //再多跳一個訂購成功通知
                let successController = UIAlertController(title: "訂購成功", message: "", preferredStyle: .alert)
                   let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                successController.addAction(okAction)
                self.present(successController, animated: true)
                
                //訂單資訊
                self.orders.append(uploadFields(fields: uploadOrder(Name: inputName, Drink: selectedDrink, Sugar: selectedSugar, Ice: selectedIce, Capacity: selectCapacity, Others: selectedExtra, Img_url: self.imgString, Price: self.selectSizePrice + self.selectExtraPrice)))
                
                //上傳AirTable
                self.uploadItems()
                
            }
            controller.addAction(okAction)
            
            //取消
            let cancelAction = UIAlertAction(title: "取消", style: .cancel)
            controller.addAction(cancelAction)
            present(controller, animated: true)
            

        } else{
            let controller = UIAlertController(title: "訂購失敗", message: "請輸入訂購人姓名", preferredStyle: .alert)
               let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
               controller.addAction(okAction)
               present(controller, animated: true)
        }
    }
    
    
        
    //抓取AirTable資料
    func uploadItems(){
        let url = URL(string: "https://api.airtable.com/v0/appUt8q96SSLnVvKS/Imported%20table")!
        var request = URLRequest(url: url)
        
        request.setValue("Bearer pat8hEsRPuvajaQZG.0a546e5968b51e45ea8a90f7942485d620072c41fd8eaeedaad7253e136bea3c", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        let encoder = JSONEncoder()

        let data = try? encoder.encode(["records": orders])
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
        if let data {
        let decoder = JSONDecoder()
            do {
                let createUserResponse = try decoder.decode(uploadRecords.self, from: data)
//                print(createUserResponse)
                print("資料已上傳")
            } catch {
            print(error)
            }
        }
        }.resume()

        
    }
        
        
       
        
  
                
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
