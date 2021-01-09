# Unit Test in Clean Swift

[How to write unit tests in Clean-Swift](https://medium.com/short-swift-stories/how-to-write-unit-tests-in-clean-swift-4d297bcc559d)

## 유닛 테스트 구조

유닛 테스트는 아래의 테스트할 구성요소들을 포함한다.

subject — 대상

input —  입력

output —  출력

따라서 테스트 코드를 작성하기 위해서 위의 구성 요소를 먼저 파악하는 것이 좋다.

전형적인 유닛 테스트 구조는 다음과 같다.

- Given — mock 생성, input 준비
- When — subject 메서드 실행
- Then — ouput 검증

## 다양한 Test Doubles — 대역

**Dummy** 

더미가 어떤 값을 가지든지 상관없는 경우에 사용한다. 예를들면 파라미터로 전달받지만 실제로 사용하지 않는 경우 등이다.

**Stub**

특정 값을 리턴하는 더미가 필요할 때 사용한다.

**Spy** 

메서드가 호출되었는지만 테스트 하려고 할 때 사용한다. 실제 implementaion 과 거의 같은 형태를 띄게 되므로 앱 구현과 결합되는 단점이 있다.

**Mock**

assertion을 포함한 spy이다. 특정 함수가 어떤 인자를 받고 얼마나 자주 호출 되는지를 체크하기 위해 사용된다.

**Fake**

위의 test doubles는 인자로 무엇을 받았는지 상관하지 않는다. 하지만 fake는 다양한 input과 그에 따른 output을 고려하여 작성된다.

## Add unit test files to your project

테스트 파일을 추가하면 아래의 형태로 템플릿이 작성되어 있다.

```swift
import XCTest
@testable import [TARGET]

class TEST_CLASS: XCTestCase {
	func setUp() {
		//테스트가 시작하기전에
		//필요한 인스턴스 생성 등
	}

	func testMethd() {
		//테스트 항목 작성
		//접두사: test
	}

	func tearDown() {
		//테스트가 끝나고나서
		//불필요한것들 제거 등
	}
}
```

## Put yout test data in one file

테스트 데이터를 쉽게 찾고 중복하여 작성하는 것을 예방하기 위해서 테스트에 필요한 데이터를 하나의 파일에서 관리하는 것이 좋다. 네이밍 팁은 Seeds.

```swift
struct Seeds {
    struct Movies {
        static let slumdogMillionaire = Movie(title: “Slumdog
         Millionaire”, releaseDate: “2008–11–12”)
        static let hurtLocker = Movie(title: “The Hurt Locker”,
         releaseDate: “2009–01–29”)
 
        static let kingsSpeech = Movie(title: “The King’s Speech”,
         releaseDate: “noDate”)
        static let all = [slumdogMillionaire, hurtLocker, 
         kingsSpeech]
    }
}
```

테스트 파일을 추가할 경우에 Seeds를 extension하여 사용하자.

## Test the interactor

interactor는 viewController로 부터 전달받은 Inputs의 블랙 박스의 개념이다.

interactor에서 테스트 구성요소는 다음과 같다

**subject** 

— interactor

**input** 

— methods defined in SomeBusinessLogic (protocol adopted by interactor)

**output** 

— methods defined in SomePresentationLogic (protocol adopted by presenter)

우선은 내부적으로 어떤 일이 벌어지는지 상관없이 ouput 메서드가 실제로 호출되는지를 테스트해야 할것이다. 

그러기 위해서 PresenterSpy를 작성해야한다. 

```swift
protocol SomePresentationLogic {
	//...
}
class SomePresenterSpy: SomePresentationLogic {
	//...
}
```

테스트 메서드는 무엇을 테스트하는지를 나타내어 적절하게 네이밍 되어야한다.

또한 하나의 테스트 메서드는 하나의 메서드만을 테스트 해야한다.

따라서 Presenter를 호출하는 테스트와 Interactor를 호출하는 테스트를 분리하여 작성한다.

Given에서 WorkerSpy를 setup한다.

When에서 interactor의 테스트 대상 메서드를 호출한다

Then에서 assert를 통해 worker의 메서드가 호출되었는지 체크한다.

```swift
// worker method가 호출되었는지 테스트
func testFetchMoviesCallsWorkerToFetch() {
  // Given
  let moviesWorkerSpy = MoviesWorkerSpy()
  let sut = ListMoviesInteractor(presenter: 
   PresenterSpy(), worker: moviesWorkerSpy)
  // When
  sut.fetchMovies()
  // Then
  XCTAssert(moviesWorkerSpy.fetchMoviesCalled, "fetchMovies()
   should ask the worker to fetch movies")
}
```

```swift
// presenter method가 호출되었는지 테스트
func testFetchMoviesCallsPresenterToFormatMovies() {
    
    // Given
    let presenterSpy = PresenterSpy()
    let sut = ListMoviesInteractor(presenter:
     presenterSpy, worker: MoviesWorkerSpy())
    // When
    sut.fetchMovies()
    // Then
    XCTAssert(presenterSpy.presentMoviesCalled,
     “fetchMovies() should ask the presenter to format the
     movies”)
}
```

```swift
// presenter로 적절한 데이터가 전달되었는지 테스트
func testFetchMoviesCallsPresenterToFormatFetchedMovies() {
    
    // Given
    let movies = Seeds.Movies.all
    let presenterSpy = PresenterSpy()
    let moviesWorkerSpy = MoviesWorkerSpy(movies: movies)
    let sut = ListMoviesInteractor(presenter:
     presenterSpy, worker: moviesWorkerSpy)
    // When
    sut.fetchMovies()
    // Then
    XCTAssertEqual(presenterSpy.movies?.count,
     movies.count, "fetchMovies() should ask the presenter to format
     the same amount of movies it fetched")
    XCTAssertEqual(presenterSpy.movies, movies,
     "fetchMovies() should ask the presenter to format the same 
     movies it fetched")
}
```

## Test the Presenter

```swift
// viewController method가 호출되었는지 테스트
// MARK: - Test doubles
class ViewControllerSpy: ListMoviesDisplaying {
    var displayFetchedMoviesCalled = false
    var displayedMovies: [ListMoviesViewModel] = []
    func displayFetchedMovies(_ movies: [ListMoviesViewModel]) {
        displayFetchedMoviesCalled = true
        displayedMovies = movies
    }
}
// MARK: - Tests
func testDisplayFetchedMoviesCalledByPresenter() {
    // Given
    let viewControllerSpy = ViewControllerSpy()
    let sut = ListMoviesPresenter(viewController: viewControllerSpy)
    // When
    sut.presentFetchedMovies([])
    // Then
    XCTAssert(
			viewControllerSpy.displayFetchedMoviesCalled,
			"presentFetchedMovies() should ask the view controller to display them"
		)
}
```

```swift
// ViewController로 데이터가 잘 전달되었는지 테스트
func testPresentFetchedMoviesShouldFormatFetchedMoviesForDisplay() {
    
    // Given
    let viewControllerSpy = ViewControllerSpy()
    let sut = ListMoviesPresenter(viewController: viewControllerSpy)
    let movies = Seeds.Movies.slumdogMillionaire

    // When
    sut.presentFetchedMovies(movies)

    // Then
    let displayedMovies = viewControllerSpy.displayedMovies
    
    XCTAssertEqual(
			displayedMovies.count, 
			movies.count,
			"presentFetchedMovies() should ask the view controller to display same amount of movies it receive"
		)
    
    for (index, displayedMovie) in displayedMovies.enumerated() 
        XCTAssertEqual(displayedMovie.title, "Slumdog Millionaire"
        XCTAssertEqual(displayedMovie.year, "2008") 
    }
}
```

## Test the ViewController

ViewController의 유닛 테스트는 View로부터 발생하는 이벤트들을 input으로 받아야 하는 경우가 있으므로 viewController life cyle을 고려하여야한다.

아래의 ViewController 유닛 테스트 시나리오를 예시로 알아보자.

1. view lifecycle methods:

    `viewDidLoad()` 에서 `fetchMovies()` 가 호출되어 Interactor에 request를 전달

2. methods in the ListMoviewsDisplaying protocol:

    `displayFetchedMovies(_ movies: [ListMoviewsViewModel])` 

3. IBAction methods: none

먼저 테스트 제반사항을 준비하기 위해서 setUp 메소드를 정의해준다.

```swift
// MARK: — Test lifecycle

var sut: ListMoviesViewController!
var interactorSpy: InteractorSpy!

override func setUp() {
  super.setUp()
  interactorSpy = InteractorSpy!
	sut = ListMoviesViewController(interactor: interactorSpy)
  sut.beginAppearanceTransition(true, animated: false)
  sut.endAppearanceTransition()
}
```

해당 테스트의 given에 포함되는 내용은 setUp에서 이미 작성되어 given은 패스.

```swift
// Interactor에서 특정 메서드가 호출되었는지를 테스트
func testShouldFetchMoviesWhenViewDidLoad() {
  // When
  sut.viewDidLoad()
    
  // Then
  XCTAssert(
		interactorSpy.fetchMoviesCalled, 
		"Should fetch movies when view is loaded"
	)
}
```

다음으로 orders 가 display 되는지를 테스트하는 케이스를 알아보자.

아래의 TableView spy를 작성해준다.

```swift
class TableViewSpy: UITableView {

  var reloadDataCalled = false

  override func reloadData() {
		reloadDataCalled = true
  }
}
```

테스트 코드를 작성하자.

```swift
// 특정 메서드를 호출했을 때 테이블 뷰가 리로드 되는지 체크하는 테스트
func testShouldDisplayFetchedMovies() {
    
    // Given
    let tableViewSpy = TableViewSpy()
    sut.tableView = tableViewSpy
    let viewModels: [ListMoviesViewModel] = []

    // When
    sut.displayFetchedMovies(viewModels) //trigger

    // Then
    XCTAssert(
				tableViewSpy.reloadDataCalled, 
				“Displaying fetched movies should reload the table view”
		)
}
```

다음으로 테이블 뷰의 셀 개수 테스트 코드를 작성해보자.

```swift
func testNumberOfRowsInAnySectionShouldEqualNumberOfMoviesToDisplay() {
    // Given
    let tableView = sut.tableView
    let viewModels: [ListMoviesViewModel] =
     [ListMoviesViewModel(title: "Test", year: "1988")]
    sut.displayFetchedMovies(viewModels)
    // When
    let numberOfRows = sut.tableView(tableView!, 
     numberOfRowsInSection: 1)
    // Then
    XCTAssertEqual(numberOfRows, viewModels.count, “The number of 
     tableview rows should equal the number of movies to display”)
}
```

다음은 전달받은 데이터를 셀에 UI 바인딩하는것이 제대로 되었는지 체크하는 테스트이다.

```swift
func testShouldConfigureTableViewCellToDisplayOrder() {
    // Given
    let tableView = sut.tableView
    let viewModels: [ListMoviesViewModel] =
     [ListMoviesViewModel(title: “E.T.”, year: “1982”) ]
    sut.displayFetchedMovies(viewModels)
    // When
    let indexPath = IndexPath(row: 0, section: 0)
    let cell = sut.tableView(tableView!, cellForRowAt: indexPath)
     as! ListMoviesTableViewCell
    // Then
    XCTAssertEqual(cell.titleLabel?.text, “E.T.”, “A properly
     configured table view cell should display the movie title”)
    XCTAssertEqual(cell.yearLabel?.text, “1982”, “A properly
     configured table view cell should display the movie year”)
}
```

## Running the tests

Shortcut — ⇧⌘U or ⌘U

Test Navigator — ⌘6 (테스트 결과 확인)

Coverage — ⌘9