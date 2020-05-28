# Moya+RxSwift networking

[Better networking with Moya + RxSwift](https://medium.com/@mattiacontin/better-networking-with-moya-rxswift-a90d821f1ce8)

- Actually moya is an alamofire wrapper
- 실제 동작하는 곳과 서비스를 정의하는 곳을 분리하기 위해서 사용됨

앤드포인트를 분기하기 위해서 이넘 케이스를 정의하였다. 카카오 검색 API를 사용해보려고 한다.

![Moya%20RxSwift%20networking%20e8baa9e101fe45109c5b4e1eed969a5c/Untitled.png](Moya%20RxSwift%20networking%20e8baa9e101fe45109c5b4e1eed969a5c/Untitled.png)

다음으로 KakaoAPI를 익스텐션하여 TargetType 이라는 프로토콜을 채택해주면 (Moya에 내장되어 있다)

![Moya%20RxSwift%20networking%20e8baa9e101fe45109c5b4e1eed969a5c/Untitled%201.png](Moya%20RxSwift%20networking%20e8baa9e101fe45109c5b4e1eed969a5c/Untitled%201.png)

이런애들을 정의하여야 한다. 앤드포인트에 필요한 프로퍼티들이다.

이번에는 api 콜을 담당하는 네트워크 매니저를 만들어보자.

![Moya%20RxSwift%20networking%20e8baa9e101fe45109c5b4e1eed969a5c/Untitled%202.png](Moya%20RxSwift%20networking%20e8baa9e101fe45109c5b4e1eed969a5c/Untitled%202.png)

아래처럼 사용할 수 있다~

![Moya%20RxSwift%20networking%20e8baa9e101fe45109c5b4e1eed969a5c/Untitled%203.png](Moya%20RxSwift%20networking%20e8baa9e101fe45109c5b4e1eed969a5c/Untitled%203.png)

이제 logging과 error handling에 대해서 좀 알아볼꺼다.

사실 나는 이부분에 관심이 있다.

에러 핸들링 하는 부분이 항상 익숙하지 않다.

먼저 예제에서 사용하는 api 에러 케이스를 알아보자

[https://developers.kakao.com/docs/latest/ko/reference/rest-api-reference](https://developers.kakao.com/docs/latest/ko/reference/rest-api-reference)

![Moya%20RxSwift%20networking%20e8baa9e101fe45109c5b4e1eed969a5c/Untitled%204.png](Moya%20RxSwift%20networking%20e8baa9e101fe45109c5b4e1eed969a5c/Untitled%204.png)

위 API 명세를 참고해서 에러 이넘케이스를 정의한다

![Moya%20RxSwift%20networking%20e8baa9e101fe45109c5b4e1eed969a5c/Untitled%205.png](Moya%20RxSwift%20networking%20e8baa9e101fe45109c5b4e1eed969a5c/Untitled%205.png)

api 를 요청하는 부분에서 에러 처리를 해준다

![Moya%20RxSwift%20networking%20e8baa9e101fe45109c5b4e1eed969a5c/Untitled%206.png](Moya%20RxSwift%20networking%20e8baa9e101fe45109c5b4e1eed969a5c/Untitled%206.png)

이제 다시 호출부로 돌아가서 보면 onError에서 해당 에러를 받을 수 있다

![Moya%20RxSwift%20networking%20e8baa9e101fe45109c5b4e1eed969a5c/Untitled%207.png](Moya%20RxSwift%20networking%20e8baa9e101fe45109c5b4e1eed969a5c/Untitled%207.png)