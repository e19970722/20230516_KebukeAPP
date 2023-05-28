//
//  OrderTableViewController.swift
//  20230516_KebukeAPP
//
//  Created by Yen Lin on 2023/5/27.
//

import UIKit
import Kingfisher

class OrderTableViewController: UITableViewController {
    
    
    var drinkOrders = [uploadFields]()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchItems()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return drinkOrders.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderTableViewCell.self)", for: indexPath) as? OrderTableViewCell else { fatalError("DequeueReuse OrderTableViewCell Failed.") }
        
        let drinkOrder = drinkOrders[indexPath.row]
        
        let imgUrl = URL(string: drinkOrder.fields.Img_url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        cell.orderImageView.kf.setImage(with: imgUrl)
        
        cell.orderNameLabel.text = drinkOrder.fields.Name
        cell.orderDrinkLabel.text = drinkOrder.fields.Drink
        cell.orderDetailLabel.text = "\(drinkOrder.fields.Capacity) / \(drinkOrder.fields.Ice) / \(drinkOrder.fields.Sugar) / \(drinkOrder.fields.Others)"
        cell.orderPriceLabel.text = "$\(drinkOrder.fields.Price.description)"
        
        return cell
    }
    
    func fetchItems(){
        let url = URL(string: "https://api.airtable.com/v0/appUt8q96SSLnVvKS/Imported%20table")!
        var request = URLRequest(url: url)
        
        request.setValue("Bearer pat8hEsRPuvajaQZG.0a546e5968b51e45ea8a90f7942485d620072c41fd8eaeedaad7253e136bea3c", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data{
                let decoder = JSONDecoder()
                do{
                    let searchResponse = try decoder.decode(uploadRecords.self, from: data)
                    self.drinkOrders = searchResponse.records
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                } catch{
                    print(error)
                }
            }
        }.resume()
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
