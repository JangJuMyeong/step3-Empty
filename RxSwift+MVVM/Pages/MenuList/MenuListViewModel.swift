//
//  menuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by 장주명 on 2021/06/07.
//  Copyright © 2021 iamchiwon. All rights reserved.
//

import Foundation

class MenuListViewModel {
    
    let menus : [Menu] = [
        Menu(name: "가지튀김", price: 2000, count: 0),
        Menu(name: "오징어튀김", price: 2000, count: 0),
        Menu(name: "새우튀김", price: 2000, count: 0),
        Menu(name: "고구마튀김", price: 2000, count: 0)
    ]
    
    let itemsCount : Int = 5
    let totalPrice : Int = 10000
    
}
