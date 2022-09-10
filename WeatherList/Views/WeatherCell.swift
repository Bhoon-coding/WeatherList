//
//  WeatherCell.swift
//  WeatherList
//
//  Created by BH on 2022/09/07.
//

import UIKit

import Kingfisher
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

    var weatherResponse = PublishSubject<WeatherInfo?>()
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
        self.weatherResponse.subscribe(onNext: { weatherInfo in
            guard let weatherInfo = weatherInfo,
                  let icon = weatherInfo.weather?[0].icon,
                  let url = URL(string: "http://openweathermap.org/img/wn/\(icon).png") else {
                self.dateLabel.text = "날짜없음"
                self.weatherImageView.backgroundColor = .secondarySystemBackground
                self.weatherLabel.text = "날씨없음"
                self.tempMaxLabel.text = "온도없음"
                self.tempMinLabel.text = "온도없음"
                return
            }
            self.dateLabel.text = weatherInfo.date?.setDate()
            self.weatherImageView.kf.setImage(with: url)
            self.weatherLabel.text = weatherInfo.weather?[0].main
            self.tempMaxLabel.text = "Max: \(Int(weatherInfo.temp.tempMax))℃"
            self.tempMinLabel.text = "Min: \(Int(weatherInfo.temp.tempMin))℃"

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
            $0.leading.equalTo(contentView.snp.centerX).inset(16)
        }
    }

}
