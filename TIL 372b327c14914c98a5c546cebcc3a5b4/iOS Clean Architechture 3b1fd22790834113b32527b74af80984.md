# iOS Clean Architechture

[Clean Coder Blog](http://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

[주니어 개발자의 클린 아키텍처 맛보기 - 우아한형제들 기술 블로그](https://woowabros.github.io/tools/2019/10/02/clean-architecture-experience.html)

[iOS Clean Architecture with Swift](https://develogs.tistory.com/7)

# 기본 아이디어

### 의존성 규칙

![iOS%20Clean%20Architechture%203b1fd22790834113b32527b74af80984/image.png](iOS%20Clean%20Architechture%203b1fd22790834113b32527b74af80984/image.png)

- 의존성은 반드시 외부에서 내부로 향한다
- 외부계층에 변경이 있을 때 내부계층의 수정이 없더라도 프로그램이 정상적으로 동작해야한다
- 내부계층은 외부계층에 대해서 알지 못한다
- 내부계층으로 갈수록 고수준 정책을 포함한다

고수준: 상대적으로 더 추상적 ex) createData, updateData
저수준: 상대적으로 더 구체적 ex) createUserData, createUserDate

### Crossing boundaries

제어의 흐름은 원의 내부에서(고수준)에서 외부(저수준)으로 향할 수 있는데 이는 **의존성 규칙**을 위배한다.

→ 고수준 정책은 저수준 정책에 의존해서는 안된다

![iOS%20Clean%20Architechture%203b1fd22790834113b32527b74af80984/image%201.png](iOS%20Clean%20Architechture%203b1fd22790834113b32527b74af80984/image%201.png)

의존성 역전 원칙을 이용하여 이를 해결해야 한다.

![iOS%20Clean%20Architechture%203b1fd22790834113b32527b74af80984/image%202.png](iOS%20Clean%20Architechture%203b1fd22790834113b32527b74af80984/image%202.png)

DIP를 통해서 Service는 DB의 구체적인 세부사항을 알필요가 없게되고 DB의 변경에도 영향을 받지 않게된다.