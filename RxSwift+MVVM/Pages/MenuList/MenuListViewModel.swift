//
//  menuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by 장주명 on 2021/06/07.
//  Copyright © 2021 iamchiwon. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MenuListViewModel {
    
//    var menus : [Menu] = [
//        Menu(name: "가지튀김", price: 2000, count: 0),
//        Menu(name: "오징어튀김", price: 2000, count: 0),
//        Menu(name: "새우튀김", price: 2000, count: 0),
//        Menu(name: "고구마튀김", price: 2000, count: 0)
//    ]
//
    
//    lazy var menuObservable = PublishSubject<[Menu]>() // 초기모델을 가져야한다면 BehaborSubject로 해야만한다.
    var menuObservable = BehaviorSubject<[Menu]>(value: [])
    lazy var itemsCount = menuObservable.map { $0.map { $0.count }.reduce(0, +)}
//    var totalPrice : PublishSubject<Int> = PublishSubject()
    lazy var totalPrice = menuObservable.map { $0.map { $0.price * $0.count }.reduce(0, +)}
    
    //Subject은 여러가지의 종류가있다.
    //Observable처럼 값을 받을수도있지만 수정할수도 있다.
    
    init() {
        
        _ = APIService.fetchAllMenusRx()
            .map{ data -> [MenuItem] in
                struct Response: Decodable {
                    let menus: [MenuItem]
                }
                let resopone = try! JSONDecoder().decode(Response.self, from: data)
                
                return resopone.menus

            }
            .map { menuItems -> [Menu] in
                var menus : [Menu] = []
                menuItems.enumerated().forEach { (index , item) in
                    let menu = Menu.fromMenuItem(id: index, item: item)
                    menus.append(menu)
                }
                return menus
            }
            .take(1)
            .bind(to: menuObservable)
        
    }
    
    func clearAllItemSelections() {
        _ = menuObservable
            .map { menus in
                menus.map { m in
                    Menu(id:m.id,name:m.name,price: m.price,count: 0)
                }
            }
            .take(1) // 몇번 수행할지 정하는법 그래서 disposed가 필요없다.
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
            })
            
        
    }
    
    func chagneCount(item : Menu, increase : Int) {
        _ = menuObservable
            .map { menus in
                menus.map { m in
                    if m.id == item.id {
                        return Menu(id: m.id ,
                                    name: m.name,
                                    price: m.price,
                                    count: max(m.count + increase, 0))
                    } else {
                        return Menu(id: m.id,
                                    name: m.name,
                                    price: m.price,
                                    count: m.count)
                    }
                }
            }
            .take(1) // 몇번 수행할지 정하는법 그래서 disposed가 필요없다.
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
            })
    }
    
    func Onorder() {
        
    }
    
}
