//
//  HomeCollectionViewController.swift
//  20230516_KebukeAPP
//
//  Created by Yen Lin on 2023/5/16.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "Cell"

class HomeCollectionViewController: UICollectionViewController {
    

    //從Airtable獲取飲料總覽資訊
    var menu_items = [Fields]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchItems()
        
        //設定Navigation Title變成Logo圖片
        let navImageView = UIImageView(image: UIImage(named: "logo"))
        navImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = navImageView
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    //抓取AirTable資料
    func fetchItems(){
        let url = URL(string: "https://api.airtable.com/v0/appcvXBVt0RmRZZqk/Imported%20table")!
        var request = URLRequest(url: url)

        //輸入Token，前面記得加Bearer。HeaderField打入Authorization
        request.setValue("Bearer patdTzmSDG0eGLoFm.e45750f8edffa607ce7db5e4a6642bc5de389fad57a5b5d5d43e1ec120a16f12", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response , error in
            if let data {
                let decoder = JSONDecoder()
                do {
                    let searchResponse = try decoder.decode(Records.self, from: data)
                    self.menu_items = searchResponse.records
                                        
                    //要到Main Thread更新資料
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                    } catch {
                        print(error)
                    }
                }
        }.resume()
    }
    
    //傳資料到下一頁
    
    @IBSegueAction func showDetail(_ coder: NSCoder) -> DetailViewController? {
        
        guard let item = collectionView.indexPathsForSelectedItems?.first?.item else { return nil }
        
        return DetailViewController(coder: coder, detailDrink: menu_items[item])
    }
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return menu_items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(DrinksCollectionViewCell.self)", for: indexPath) as! DrinksCollectionViewCell
        
        let menu_item = menu_items[indexPath.item]
        cell.drinksNameLabel.text = menu_item.fields.drinks
        cell.drinksPriceLabel.text = "中：\(menu_item.fields.med_price) / 大：\(menu_item.fields.large_price)"
        cell.drinksDescTextView.text = menu_item.fields.desc
        
        //注意：網址有中文，飲料名稱，要加addingPercentageEncoding作轉換
        let img_url_here = URL(string: menu_item.fields.img_url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)

        cell.drinksImageView.kf.setImage(with: img_url_here)
        
    
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    //設定Header Banner GIF
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:

            //寫上剛剛建立的HeaderCollectionReusableView
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath) as! HeaderCollectionReusableView
            
            //設定GIF輪播照片，照片名稱為我們剛剛匯入assets，檔名編號以前的部分，接著輸入稍大的duration來減緩播放速度
            headerView.bannerImageView.image = UIImage.animatedImageNamed("banner", duration: 10)
            
            return headerView
            
        default:
            fatalError("Unexpected element kind")
        }
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
