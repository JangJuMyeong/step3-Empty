//
//  Menu.swift
//  RxSwift+MVVM
//
//  Created by 장주명 on 2021/06/07.
//  Copyright © 2021 iamchiwon. All rights reserved.
//

import Foundation

//MARK: - view를 위한 모델 ViewModel
struct Menu {
    var id : Int
    var name : String
    var price : Int
    var count : Int
}

extension Menu {
    static func fromMenuItem(id: Int, item : MenuItem) -> Menu {
        return Menu(id: id, name: item.name, price: item.price, count: 0)
    }
}
