//
//  WeatherViewController.swift
//  WeatherList
//
//  Created by BH on 2022/09/06.
//

import UIKit

import RxSwift

final class WeatherViewController: UIViewController {
    
    let viewModel: WeatherViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeathers()

    }
    
    func fetchWeathers() {
        self.viewModel.fetchWeathers().subscribe(onNext: { weather in
         dump(weather)
        }).disposed(by: disposeBag)
    }
    

}
