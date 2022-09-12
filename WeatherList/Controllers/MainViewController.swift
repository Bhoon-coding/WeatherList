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
    
    let weatherResponse = BehaviorRelay<[SectionOfWeatherResponse]>(value: [])
    private let disposeBag = DisposeBag()
    private let viewModel: MainViewModel
    private var dataSource = RxTableViewSectionedReloadDataSource<SectionOfWeatherResponse>(
        configureCell: { dataSource, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: WeatherCell.self),
            for: indexPath
        ) as? WeatherCell else { return UITableViewCell() }
        cell.weatherResponse.onNext(item)
            let today = 0
            let tomorrow = 1
            
            switch indexPath.row {
            case today:
                cell.dateLabel.text = "Today"
            case tomorrow:
                cell.dateLabel.text = "Tomorrow"
            default:
                break
            }
        return cell
    })
    
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

}

// MARK: - UI Extension

extension MainViewController {
    
    private func configureUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureTableView() {
        tableView.rowHeight = 120
        tableView.register(
            WeatherCell.self,
            forCellReuseIdentifier: String(describing: WeatherCell.self)
        )
    }
    
}

// MARK: - FetchWeather Extension

extension MainViewController {
    
    private func fetchWeathers() {
        viewModel.fetchWeathers()
            .subscribe(onNext: { [weak self] weatherRes in
                guard let self = self else { fatalError("Failed data fetch") }
                
                let sections = [
                    SectionOfWeatherResponse(header: weatherRes[0].city!.name,
                                             items: weatherRes[0].list!),
                    SectionOfWeatherResponse(header: weatherRes[1].city!.name,
                                             items: weatherRes[1].list!),
                    SectionOfWeatherResponse(header: weatherRes[2].city!.name,
                                             items: weatherRes[2].list!)
                ]
                
                self.weatherResponse.accept(sections)
                self.dataSource.titleForHeaderInSection = { dataSource, index in
                    return dataSource.sectionModels[index].header
                }
                
                self.bind()
            }).disposed(by: disposeBag)
    }
    
}

// MARK: - Binding Extension

extension MainViewController {
    
    private func bind() {
        weatherResponse
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}
