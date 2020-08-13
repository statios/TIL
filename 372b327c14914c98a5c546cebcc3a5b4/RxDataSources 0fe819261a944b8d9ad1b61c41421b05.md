# RxDataSources

[RxSwiftCommunity/RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources)

### 특징

- 차이점을 계산하기 위한 O(n) 알고리즘
    - 모든 섹션과 아이템은 유니크하다고 가정
    - 모호한 경우에는 애니메이션 없이 자동으로 리프레시됨
- 단면 뷰에 최소 명령 수를 전송하기 위해 추가 경험적 특성을 적용
    - 시간복잡도가 선형이더라도 실제 연산은 그보다 훨씬 적다
    - 업데이트 되는 뷰의 개수가 선형이라면 전체를 리로드 하지만, 뷰 업데이트(리로드)는 최소화 하는 것을 선호함
- 셀과 섹션의 구조 확장을 지원함
    - 셀에 IdentifiableType, Equtable을 채택하여 정의하기만 하면됨
    - 섹션에 AnimatableSectionModelType을 채택하여 정의하기만 하면됨
- 섹션-셀에 모든 애니메이션 결합 조합을 지원
    - section animations: insert, delete, move
    - item animations: insert, delete, move, reload
- 애니메이션 설정가능 (자동, 페이드 등)
- UITableView, UICollectionView 와 연동

---

### why

- 수많은 델리게이트 메서드를 사용하지 않아도됨
- 데이타 바인딩을 간단하게 해줌
    1. data를 observable 로 래핑하여 → 시퀀스를 생성함
    2. 아래와 같이 tableview나 Collectionview에 바인딩함
    - rx.items(dataSource:protocol<RxTableViewDataSourceType, UITableViewDataSource>
    - rx.items(cellIdentifider:String)
    - rx.items(cellIdentifier:String:Cell.Type:_:)
    - rx.items(_: _: )

    ```swift
    let data = Observable<[String]>.just([1,2,3])
    data.bind(to: tableView.rx.items(cellIdentifier: "Cell")) { index, model, cell in
    	cell.textLabel?.text = model
    }
    .disposed(by: disposeBag)
    ```

    - 위의 예시는 간단한 테이블 뷰 바인딩을 표현한 것
    - 여러 섹션이나 특정 액션에 대한 애니메이션을 정의하지는 않음
    - 아래는 이것들을 구현해본것임 간단하다..!

    ```swift
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(configureCell: configureCell)
    Observable.just([SectionModel(model: "title", items: [1, 2, 3])])
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    ```

    ![RxDataSources%200fe819261a944b8d9ad1b61c41421b05/image.gif](RxDataSources%200fe819261a944b8d9ad1b61c41421b05/image.gif)

---

### How

데이터 모델 구조를 먼저 잡자

![RxDataSources%200fe819261a944b8d9ad1b61c41421b05/Untitled.png](RxDataSources%200fe819261a944b8d9ad1b61c41421b05/Untitled.png)

SectionModelType을 채택한 구조체에서 섹션에 대한 정의를 해보자

- item typealias: 섹션에 포함될 아이템들의 타입을 정의
- items property 선언 : 아이템 타입의 배열로 선언하자

![RxDataSources%200fe819261a944b8d9ad1b61c41421b05/Untitled%201.png](RxDataSources%200fe819261a944b8d9ad1b61c41421b05/Untitled%201.png)

datasource 객체를 만들어서 SectionOfCustomData에 pass한다.

![RxDataSources%200fe819261a944b8d9ad1b61c41421b05/Untitled%202.png](RxDataSources%200fe819261a944b8d9ad1b61c41421b05/Untitled%202.png)

필요시 dataSource에서 클로져를 커스텀 할 수 있다

![RxDataSources%200fe819261a944b8d9ad1b61c41421b05/Untitled%203.png](RxDataSources%200fe819261a944b8d9ad1b61c41421b05/Untitled%203.png)

바인딩 해보자

![RxDataSources%200fe819261a944b8d9ad1b61c41421b05/Untitled%204.png](RxDataSources%200fe819261a944b8d9ad1b61c41421b05/Untitled%204.png)

---

### summary

![RxDataSources%200fe819261a944b8d9ad1b61c41421b05/Untitled%205.png](RxDataSources%200fe819261a944b8d9ad1b61c41421b05/Untitled%205.png)

![RxDataSources%200fe819261a944b8d9ad1b61c41421b05/Untitled%206.png](RxDataSources%200fe819261a944b8d9ad1b61c41421b05/Untitled%206.png)