# Time Based Opertors

- 반응형 프로그래밍의 핵심은 비동기적인 데이터 흐름을 시간 경과에 따라 모델링 하는것
- 시퀀스의 time dimension을 관리하는 operator가 제공됨

---

### buffering operators

- 이미 지나간 element를 다시 전달 받거나 버퍼를 두고 받을 수 있다
- 언제 어떻게 과거와 새로운 elements를 받을지 컨트롤 할 수 있다

---

### replaying past elements - replay(_:), replayAll()

- 미래의 구독자가 이미 발생한 이벤트를 받을 수 있는 observable로 만들어줌
- replayed observable을 구독하면 이전에 발생한 element를 한번에 받고 이후에 발생하는 이벤트 또한 정상적으로 받는다
- ConnectableObservable - connec() 메소드를 호출하기 전까지 구독자 수와 관계 없이 아무 값도 방출하지 않는다
- replay, replayAll, multicast, publish는 OnnectableObservable을 리턴하는 연산자들임

---

### Unlimited replay - replayAll()

- 버퍼할 element의 전체 개수를 정확히 알 수 있을 때 사용하자
- 이전에 발생한 next(element)를 전부다 받는다 = 버퍼 사이즈가 무제한이다

---

### Controlled buffering - buffer(timeSpan:cout:scheduler:)

- timeSpan - 동안 발생한
- count - 만큼의 element를 timeSpan 마다
- scheduler - 쓰레드에서 구독한닷
- element는 여러개 이므로 배열로 받는다
- timeSpan이 경과하지 않아도 count 만큼 element가 방출되었으면 바로 받는다
- 즉 timeSpan이나 count가 다 찼을 땐 이벤트를 받는것이다

---

### buffered observables의 window(timeSpan:count:scheduler:)

- buffer랑 비슷한데 array가 아니라 observable을 방출함