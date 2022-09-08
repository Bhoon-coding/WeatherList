//
//  WeatherCell.swift
//  WeatherList
//
//  Created by BH on 2022/09/07.
//

import UIKit
import RxSwift

class WeatherCell: UITableViewCell {
    
    // MARK: - UIProperties
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private lazy var weatherLabel: UILabel = {
       let label = UILabel()
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var tempStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tempMaxLabel, tempMinLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var tempMinLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var tempMaxLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()
    
    // MARK: - Properties

    var weatherResponse = PublishSubject<WeatherResponse>()
    let disposeBag = DisposeBag()
    
    // MARK: - LifeCycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        subscribe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func subscribe() {
        self.weatherResponse.subscribe(onNext: { weatherResponse in
            self.dateLabel.text = weatherResponse.list?[0].date
            // imageView
            self.weatherImageView.image = UIImage(systemName: "square.and.arrow.up")
            self.weatherLabel.text = weatherResponse.list?[0].weather?[0].main
            self.tempMaxLabel.text = String(describing: weatherResponse.list?[0].temp.tempMax)
            self.tempMinLabel.text = String(describing: weatherResponse.list?[0].temp.tempMin)
            
            
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    
    func configureCell() {
        backgroundColor = .systemBackground
        
        [dateLabel,
         weatherImageView,
         weatherLabel,
         tempStackView].forEach { addSubview($0) }
        
        dateLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(8)
        }
        
        weatherImageView.snp.makeConstraints {
            $0.leading.equalTo(dateLabel)
            $0.bottom.equalToSuperview().inset(8)
            $0.width.height.equalTo(40)
        }
        
        weatherLabel.snp.makeConstraints {
            $0.leading.equalTo(weatherImageView.snp.trailing).offset(8)
            $0.bottom.equalTo(weatherImageView)
        }
        
        tempStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(24)
        }
    }

}
