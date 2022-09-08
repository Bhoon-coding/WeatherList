//
//  WeatherViewController.swift
//  WeatherList
//
//  Created by BH on 2022/09/06.
//

import UIKit

import RxSwift
import RxRelay
import SnapKit

final class MainViewController: UIViewController {
    
    // MARK: - UIProperties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    // MARK: - Properties
    
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
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        fetchWeathers()
        subscribe()
    }
    
    func configureUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    func configureTableView() {
        tableView.rowHeight = 120
        tableView.register(
            WeatherCell.self,
            forCellReuseIdentifier: String(describing: WeatherCell.self)
        )
        tableView.dataSource = self
    }
    
    func fetchWeathers() {
        self.viewModel.fetchWeathers()
            .subscribe(onNext: { weatherRes in
                self.weatherResponse.accept(weatherRes)
        }).disposed(by: disposeBag)
    }
    
    func subscribe() {
        self.weatherResponseObserver.subscribe(onNext: { weatherResponse in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
    }

}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherResponse.value.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WeatherCell.self), for: indexPath) as? WeatherCell else { return UITableViewCell() }
        
        let weatherResponse = self.weatherResponse.value
        cell.weatherResponse.onNext(weatherResponse)
        
        
        return cell
    }
    
    
    
    
}
