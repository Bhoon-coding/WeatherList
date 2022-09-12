//
//  WeatherViewController.swift
//  WeatherList
//
//  Created by BH on 2022/09/06.
//

import UIKit

import RxSwift
import RxRelay
import RxDataSources
import SnapKit

final class MainViewController: UIViewController {
    
    // MARK: - UIProperties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    // MARK: - Properties
    
    private let viewModel: MainViewModel
    private let disposeBag = DisposeBag()
    private var dataSource = RxTableViewSectionedReloadDataSource<SectionOfWeatherResponse>(
        configureCell: { dataSource, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: WeatherCell.self),
            for: indexPath
        ) as? WeatherCell else { return UITableViewCell() }
        cell.weatherResponse.onNext(item)
            
            switch indexPath.row {
            case 0:
                cell.dateLabel.text = "Today"
            case 1:
                cell.dateLabel.text = "Tomorrow"
            default:
                break
            }
        
        return cell
        
    })
    
    private let weatherResponse = BehaviorRelay<[SectionOfWeatherResponse]>(value: [])
    private var weatherResponseObserver: Observable<[SectionOfWeatherResponse]> {
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
    }
    
    func configureUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureTableView() {
        tableView.rowHeight = 120
        tableView.register(
            WeatherCell.self,
            forCellReuseIdentifier: String(describing: WeatherCell.self)
        )
    }
    
    func fetchWeathers() {
        self.viewModel.fetchWeathers()
            .subscribe(onNext: { weatherRes in
                guard let weatherInfo = weatherRes[0].list else {
                    print("there is no weatherInfo")
                    return }
                let sections = [
                    SectionOfWeatherResponse(header: "Seoul", items: weatherInfo),
                    SectionOfWeatherResponse(header: "London", items: weatherInfo),
                    SectionOfWeatherResponse(header: "Chicago", items: weatherInfo)
                ]
                self.weatherResponse.accept(sections)
                
                self.dataSource.titleForHeaderInSection = { dataSource, index in
                    return dataSource.sectionModels[index].header
                }
                
                self.bind()
        }).disposed(by: disposeBag)
        
        
    }
    
    func bind() {
        weatherResponse
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

}
