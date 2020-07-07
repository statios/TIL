# Facade pattern

- structural pattern
- 복잡한 시스템에 간단한 인터페이스를 제공

![Facade%20pattern%20b338339f26194bf682eace9ee549decc/image.png](Facade%20pattern%20b338339f26194bf682eace9ee549decc/image.png)

- facade는 시스템과 상호작용하기위한 간단한 메서드들을 제공
- 시스템의 여러 클래스에 대해 알고 상호 작용하는 대신 파사드를 사용할 수 있게 해준다.
- dependencies는 facade가 소유하는 객체
- dependencies는 복잡한 task의 작은 부분을 수행함

---

### 언제 사용하는가?

- 다양한 컴포넌트들로 구성된 시스템 일때
- 복잡한 tasks를 수행하는 것을 간단하게 제공하기를 원할때
- 예시
    - 제품을 주문하는 것 - 고객, 제품, 재고, 배송 주문 등 여러 구성요소를 포함함
    - 이러한 구성요소들이 어떻게 상호 작용하는지 이해하는 대신
    - facade를 통하여 일반적인 새로운 주문의 신청, 배송 같은 표면적인 것만 노출시킴

---

### code example

상기 예시를 코드로 작성해보자

![Facade%20pattern%20b338339f26194bf682eace9ee549decc/Untitled.png](Facade%20pattern%20b338339f26194bf682eace9ee549decc/Untitled.png)

- 주문을 넣을 수 있는 고객 정보를 담을 Customer
- 판매하는 제품의 정보인 Product
- dictionary의 key로 사용되할 수 있도록 Hashable을 채택하여 구현함

![Facade%20pattern%20b338339f26194bf682eace9ee549decc/Untitled%201.png](Facade%20pattern%20b338339f26194bf682eace9ee549decc/Untitled%201.png)

- InventoryDatabase - 재고 데이터를 저장하는 객체와 어떤 제품에 대한 재고 정보를 갖는 inventory 프로퍼티
- ShippingDatabase - 배송 데이터를 저장하는 객체와 어떤 고객이 주문한 상품의 리스트를 갖는 pendingShipments 프로퍼티

![Facade%20pattern%20b338339f26194bf682eace9ee549decc/Untitled%202.png](Facade%20pattern%20b338339f26194bf682eace9ee549decc/Untitled%202.png)

- 퍼사드 객체는 데이터베이스를 프로퍼티로 가지며 이니셜라이저로부터 pass 받는다
- 주문하는 메서드를 정의함
    1. product에 대한 재고를 확인함
        - 재고가 존재하지 않으면 메서드 종료
    2. 재고가 존재하면 재고에서 1만큼 차감
    3. 주문 고객의 배송 정보를 복사함
    4. 복사한 배송 정보에 주문한 품목을 추가함
    5. 새로운 배송 정보를 업데이트함

![Facade%20pattern%20b338339f26194bf682eace9ee549decc/Untitled%203.png](Facade%20pattern%20b338339f26194bf682eace9ee549decc/Untitled%203.png)

- 신라면과 안성탕면을 상품으로 등록하고 각각의 수량을 입력하여 데이터베이스에 추가하였다.
- 퍼사드를 생성하여 해당 디비를 pass하였다
- 고객 객체를 생성하였다
- 퍼사드를 통해 주문 메서드를 실행하였다

![Facade%20pattern%20b338339f26194bf682eace9ee549decc/Untitled%204.png](Facade%20pattern%20b338339f26194bf682eace9ee549decc/Untitled%204.png)

---

### 조심해야 할것!

- 모든 클래스에 대해서 관여하는 god facade를 만들지 않도록 주의해라
- 각각 다른 경우에 사용하는 여러 퍼사드를 만드는건 괜찮다
- 예를 들어서 하나의 퍼사드에서 어떤 기능은 몇몇 클래스에서 사용하고, 어떤 기능은 다른 클래스에서 사용한다면 둘 또는 여러 퍼사드로 나누기를 고려해봐라

---

### 키포인트

- facade pattern은 복잡한 시스템에 간단한 인터페이스를 제공한다
- facade와 dependencies로 구성되어 있다
- facade는 시스템과 소통하는 간단한 메서드를 제공함
- facade는 dependencies를 소유하며 소통(복잡한 작업의 작은 부분들을)

---