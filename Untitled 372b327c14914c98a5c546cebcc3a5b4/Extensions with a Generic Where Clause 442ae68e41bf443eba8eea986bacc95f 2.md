# Extensions with a Generic Where Clause

[Generics - The Swift Programming Language (Swift 5.2)](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID553)

---

![Extensions%20with%20a%20Generic%20Where%20Clause%20442ae68e41bf443eba8eea986bacc95f/Untitled.png](Extensions%20with%20a%20Generic%20Where%20Clause%20442ae68e41bf443eba8eea986bacc95f/Untitled.png)

- 만약 여기서 where 절 빠지면 무슨일이 벌어지냐?
    - isTop(_:) 정의 자체가 안되고 컴파일 에러발생 왜냐하면 제네릭 타입인 Element에 대해 Equatable이 보장되지 않기 때문에 == 연산이 불가능하기 때문이다

![Extensions%20with%20a%20Generic%20Where%20Clause%20442ae68e41bf443eba8eea986bacc95f/Untitled%201.png](Extensions%20with%20a%20Generic%20Where%20Clause%20442ae68e41bf443eba8eea986bacc95f/Untitled%201.png)

- 그러면 where 절은 그대로 두고 equtable 타입이 아닌 타입을 element로 사용하면?
    - isTop(_:) 실행시 에러발생함

![Extensions%20with%20a%20Generic%20Where%20Clause%20442ae68e41bf443eba8eea986bacc95f/Untitled%202.png](Extensions%20with%20a%20Generic%20Where%20Clause%20442ae68e41bf443eba8eea986bacc95f/Untitled%202.png)

![Extensions%20with%20a%20Generic%20Where%20Clause%20442ae68e41bf443eba8eea986bacc95f/Untitled%203.png](Extensions%20with%20a%20Generic%20Where%20Clause%20442ae68e41bf443eba8eea986bacc95f/Untitled%203.png)

정리하면 where 절의 사용은 extension에 대해 요구조건을 지정하는 것이다

---

### where clause in protocol extension

프로토콜의 extension 에서 where절을 사용할 수 있다

![Extensions%20with%20a%20Generic%20Where%20Clause%20442ae68e41bf443eba8eea986bacc95f/Untitled%204.png](Extensions%20with%20a%20Generic%20Where%20Clause%20442ae68e41bf443eba8eea986bacc95f/Untitled%204.png)

- Container - 컨테이너 프로토콜을 채택하는 타입은
    - Item을 추가하는 함수를 구현해야함
    - count 프로퍼티를 구현해야함
    - index로 item에 접근 가능하도록 해야함
- extension Container
    - count 가 1이상이고, 파라미터로 전달받은 item이 첫번째 Container type의 첫번째 item과 같은지를 확인하는 startWith 함수를 디폴트 함수로 구현
- 여기서 where 절과 연관지어서 이것이 무엇을 의미하는지 생각해보자
    - Item이 Equtable 타입일 때만 해당 스코프 (extension) 내의 함수를 작동 시키겠단 말이다.
    - 즉, 익스텐션 자체에 조건을 부여한 것이라고 생각하자~
    - 바꿔말하면, 컨테이너 타입인 데이터는 Item 이라는 애를 갖고 있는데, 얘가 제네릭이라서 무슨 타입이 올지 모른다는 거지.. 그렇기 때문에 Item이 Equtable인 경우에만 해당 함수(startWith)를 실행할 수 있게 한다.

![Extensions%20with%20a%20Generic%20Where%20Clause%20442ae68e41bf443eba8eea986bacc95f/Untitled%205.png](Extensions%20with%20a%20Generic%20Where%20Clause%20442ae68e41bf443eba8eea986bacc95f/Untitled%205.png)

한편 where절에서 == 연산자가 가지는 의미를 알아보자

![Extensions%20with%20a%20Generic%20Where%20Clause%20442ae68e41bf443eba8eea986bacc95f/Untitled%206.png](Extensions%20with%20a%20Generic%20Where%20Clause%20442ae68e41bf443eba8eea986bacc95f/Untitled%206.png)

- 여기서 Item 은 꼭 Double 이어야 한단 말이다.
- 그러니깐 컨테이너 타입중에서 Item을 Double로 받은 경우에만 average() 함수를 사용할 수 있는 것임

- where 절에 여러가지 조건을 사용할 수도 있다. 콤마로 구분해서 사용하면된다.