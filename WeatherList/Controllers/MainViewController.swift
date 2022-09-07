//
//  WeatherViewController.swift
//  WeatherList
//
//  Created by BH on 2022/09/06.
//

import UIKit

import RxSwift
import RxRelay

final class MainViewController: UIViewController {
    
    let viewModel: MainViewModel
    let disposeBag = DisposeBag()
    
    private let weatherResponse = BehaviorRelay<WeatherResponse>(
        value: WeatherResponse(statusCode: nil,
                               count: nil,
                               list: nil,
                               city: nil)
    )
    var weatherResponseObserver: Observable<WeatherResponse> {
        return weatherResponse.asObservable()
    }
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeathers()
        subscribe()
    }
    
    func fetchWeathers() {
        self.viewModel.fetchWeathers()
            .subscribe(onNext: { weatherRes in
                self.weatherResponse.accept(weatherRes)
        }).disposed(by: disposeBag)
    }
    
    func subscribe() {
        self.weatherResponseObserver.subscribe(onNext: { weatherResponse in
            dump(weatherResponse)
        }).disposed(by: disposeBag)
    }

}
