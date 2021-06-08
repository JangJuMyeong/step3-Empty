//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MenuViewController: UIViewController {
    // MARK: - Life Cycle
    let cellID = "MenuItemTableViewCell"
    let viewModel = MenuListViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        //Rxcocoa
        //UIKit을 Rxswift에서 사용하기위해 extension한것이다.
        
//        viewModel.itemsCount
//            .map{ "\($0)"}
//            .subscribe(onNext: {
//                self.itemCountLabel.text = $0
//            })
//            .disposed(by: disposeBag)
        
        // 위 코드를 사용하여 순환참조를 막으면서 줄수도 줄일수 있다
        viewModel.itemsCount
            .map{"\($0)"}
            
            .bind(to: itemCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.totalPrice
            .map { $0.currencyKR() }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.totalPrice.text = $0
            })
            .disposed(by: disposeBag)
        
        viewModel.menuObservable // 이렇게 작성시 데이터소스 부분이 필요가 없다.
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: cellID, cellType: MenuItemTableViewCell.self)) { index, item, cell in
                cell.title.text = item.name
                cell.price.text = "\(item.price)"
                cell.count.text = "\(item.count)"
                
                cell.onChange = { [weak self] increase in
                    self?.viewModel.chagneCount(item: item, increase: increase)
                }

            }
            .disposed(by: disposeBag)
        
        
        //이러한 일련의 과저을 스트림이라고한다.
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let identifier = segue.identifier ?? ""
//        if identifier == "OrderViewController",
//            let orderVC = segue.destination as? OrderViewController {
//            // TODO: pass selected menus
//        }
//    }
//
//    func showAlert(_ title: String, _ message: String) {
//        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alertVC, animated: true, completion: nil)
//    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var itemCountLabel: UILabel!
    @IBOutlet var totalPrice: UILabel!

    @IBAction func onClear() {
        viewModel.clearAllItemSelections()
        
    }

    @IBAction func onOrder(_ sender: UIButton) {
        // TODO: no selection
//        // showAlert("Order Fail", "No Orders")
//        performSegue(withIdentifier: "OrderViewController", sender: nil)
//        updateUI()
//        viewModel.totalPrice += 100
//        viewModel.totalPrice.onNext(100) // PublishSubject로 만들어서 해당 값을 넣어줄수 있다.
        
//        viewModel.menuObservable.onNext([
//            Menu(name: "change", price: Int.random(in: 100...1000), count: Int.random(in: 0...3)),
//            Menu(name: "change", price: Int.random(in: 100...1000), count: Int.random(in: 0...3)),
//            Menu(name: "change", price: Int.random(in: 100...1000), count: Int.random(in: 0...3)),
//            Menu(name: "change", price: Int.random(in: 100...1000), count: Int.random(in: 0...3)),
//        ])
        viewModel.Onorder()
    }
    
//    func updateUI() {
//        itemCountLabel.text = "\(viewModel.itemsCount)"
//        totalPrice.text = viewModel.totalPrice.currencyKR()
//    }
}

//extension MenuViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.menus.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell") as! MenuItemTableViewCell
//
//        let menu = viewModel.menus[indexPath.row]
//
//
//        return cell
//    }
//}
