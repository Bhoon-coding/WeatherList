# WeatherList


# 목차
  1. [Developer](#Developer)
  2. [프로젝트 소개](#프로젝트-소개)
     1. [기능 소개](#기능-소개)
  3. [고민한점](#고민한점) 
  4. [회고](#회고)
  
---


# Developer
|이병훈 (1인 개발)|
|:--:|

--- 
<br>

# 프로젝트 소개
- 오픈 API ([openweather](https://openweathermap.org/forecast5))를 이용하여 서울,런던,시카고 3개의 도시에 대한 5일치의 날씨 정보를 보여주는 앱.

### API 예시

<details>
<summary>API response</summary>
<div markdown="1">       

```json 
{
    "cod": "200",
    "message": 0,
    "cnt": 40,
    "list": [
    {
            "dt": 1663426800,
            "main": {
                "temp": 21.66,
                "feels_like": 22,
                "temp_min": 21.66,
                "temp_max": 21.66,
                "pressure": 1007,
                "sea_level": 1007,
                "grnd_level": 1001,
                "humidity": 81,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 801,
                    "main": "Clouds",
                    "description": "few clouds",
                    "icon": "02n"
                }
            ],
            "clouds": {
                "all": 14
            },
            "wind": {
                "speed": 2.25,
                "deg": 59,
                "gust": 4.82
            },
            "visibility": 10000,
            "pop": 0,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2022-09-17 15:00:00"
        }
    ],
    "city": {
        "id": 1835848,
        "name": "Seoul",
        "coord": {
            "lat": 37.5683,
            "lon": 126.9778
        },
        "country": "KR",
        "population": 10349312,
        "timezone": 32400,
        "sunrise": 1663017118,
        "sunset": 1663062285
    }
}
```

</div>
</details>



<br>


## 기능 소개

- `MVVM 아키텍처` 사용
- `RxSwift` 적용
- `RxDataSource` 적용 (Section 분리)
- `KingFisher`사용으로 이미지 캐싱

<br>

### MainViewController

|날씨 데이터 Fetch|
|:--:|
|<img src = "https://i.imgur.com/viLa0L4.gif" width = "200">

<br>

<!-- # 고민한 부분

### 문제1

별표 버튼을 누를때마다 전체 컬렉션뷰 내부 전체 cell에 입력이 되는 상황
cell에 있는 별표 버튼을 index에 맞게 각각 눌리게 구현해야 했었음.

### 해결

cell 내부에서 `CellActionDelegate` 를 만들어준 후,
PhotoListVC에서 채택하여 `starButtonTapped` 메서드의 파라미터로`PhotoListCollectionViewCell`을 적용 -> collectionView.indexPath(for: cell)로 눌려지는 Index 파악

```swift
// PhotoListCollectionViewCell
protocol CellActionDelegate: AnyObject {
    
    func starButtonTapped(cell: PhotoListCollectionViewCell) { }
    
    
}

class PhotoListCollectionViewCell: UICollectionViewCell { 
    
    weak var cellDelegate: CellActionDelegate?

    //...
    
    @objc func starTapped() {
        cellDelegate?.starButtonTapped(cell: self)
    }
    
}
```

```swift
// PhotoListViewController
func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell { 
    // ... 
    
    cell.cellDelegate = self
    
}

extension PhotoListViewController: CellActionDelegate {
    
    func starButtonTapped(cell: PhotoListCollectionViewCell) {
     guard let indexPath = collectionView.indexPath(for: cell) else { return }       
    // ...
    }
}
```

### 문제2
CollectionViewCell에서 cornerRadius를 지정해도 반응이 없음.

### 해결

`clipsToBounds = true` 를 이용해 해결

```swift
clipsToBounds = true // subView가 view의 경계를 넘어갈 시 잘림.
clipsToBounds = false // 경계를 넘어가도 잘리지 않음
```

### 배운점

subView에 아무리 cornerRadius를 줘봤자 상위 view에서 설정이 되어있지 않으면 반응이없다.
 -->


<br>


---
# 고민한점

<details>
<summary>api 호출시 5일치 나오지만, 3시간 간격으로 날씨가 나옴.</summary>
<div markdown="1">       

### 문제

도시 1개당 3시간 간격으로 5일치 총 40개의 날씨 데이터가 불러와짐.
    
- 사용했던 api 
    ```
    api.openweathermap.org/data/2.5/forecast?q={city name}&appid={API key}
    ```
    
### 해결

`filter` 메서드를 활용하여 `09:00:00` 시간을 포함한 배열들만 반환하여 날짜별로 가져오게 구현.
</div>
</details>
    
<details>
<summary>도시 3개의 api 응답값들을 한 배열에 담을 수 없을까?</summary>
<div markdown="1">       

### 문제 

api 호출시 request 할 수 있는 도시는 하나,
총 세번을 호출해야 하고, 각각의 응답값들을 하나로 묶어줘야 하는 상황

### 해결
    
빈배열을 만들어놓고 각 응답값들을 생성한 빈배열에 넣어줌.
    
```swift
func fetchWeather(with city: [String]) -> Observable<[WeatherResponse]> {
        return Observable.create { observer -> Disposable in
            var results: [WeatherResponse] = [] // 1. 빈 배열 생성
            
            city.forEach { city in  // 2. 파라미터로 받아오는 도시들을 반복문으로 3번 호출
                let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(Bundle.main.apiKey)&units=metric"

                if let url = URL(string: urlString) {
                    AF.request(
                        url,
                        method: .get,
                        encoding: JSONEncoding.default
                    ).responseDecodable(of: WeatherResponse.self) { response in
                        if response.error != nil {
                            observer.onError(response.error ?? NetworkError.invalidResponse)
                        }
                        if var weathersResponse = response.value {
                            weathersResponse.list =  weathersResponse.list?
                                .filter { $0.date.contains("09:00:00") }
                            results.append(weathersResponse) // 3. 응답값 results에 넣어주기
                        }
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                observer.onNext(results)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
```

(개인적으로 아쉬운 부분)
시간이 부족해서 일단 구현은 했지만 Rx로 구현할 수 있는 방법이 있지 않을까 싶다. 추후 찾아보고 업데이트 해야겠다.
    




</div>
</details>
    
<details>
<summary>강제언래핑..</summary>
<div markdown="1">       

### 문제 

시간이 부족해 일단 강제언래핑을 했는데, 존재 자체가 문제다.. 값이 없을경우 앱이 꺼져버리기 때문에 위험하다.
이건 바로 리팩토링 들어가야겠다.
    
```swift
// MainViewController
    
private func fetchWeathers() {
        viewModel.fetchWeathers()
            .subscribe(onNext: { [weak self] weatherRes in
                guard let self = self else { fatalError("Failed data fetch") }
                // 문제의 부분..
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
```
    
### 해결

해결 후 업데이트 바로 해야겠다.


</div>
</details>


<!-- <details>
<summary>여기를 눌러주세요</summary>
<div markdown="1">       

😎숨겨진 내용😎

</div>
</details> -->



----




# 회고

RxSwift를 이해하고 적용하는데에 시간이 많이 소요되어 여러가지로 미흡했던 부분이 아쉬웠지만, 이번 프로젝트를 통해서 Rx에 대해 개념을 조금 잡아간것 같다.


----

[컨벤션](https://github.com/Bhoon-coding/WeatherList/wiki) <br>
[이슈 관리](https://github.com/Bhoon-coding/WeatherList/issues?q=is%3Aissue+is%3Aclosed)
