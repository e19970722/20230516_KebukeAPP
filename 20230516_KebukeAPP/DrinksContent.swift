//
//  DrinksContent.swift
//  20230516_KebukeAPP
//
//  Created by Yen Lin on 2023/5/16.
//

import Foundation

//顯示JSON內容
struct Records: Codable {
    let records : [Fields]
}

struct Fields: Codable {
    let fields : DrinksContent
}

struct DrinksContent: Codable {
    let drinks: String
    let desc: String
    let med_price: Int
    let large_price: Int
    let img_url: String
}


//上傳JSON內容
struct uploadRecords: Codable {
    let records : [uploadFields]
}

struct uploadFields: Codable {
    let fields : uploadOrder
}

struct uploadOrder: Codable {
    let Name: String
    let Drink: String
    let Sugar: String
    let Ice: String
    let Capacity: String
    let Others: String
    let Img_url: String
    let Price: Int
}
