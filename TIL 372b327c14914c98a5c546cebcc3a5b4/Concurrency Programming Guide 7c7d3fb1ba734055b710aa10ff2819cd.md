# Concurrency Programming Guide

CPU가 싱글 코어에서 멀티 코어로 발전하면서 여러 코어를 활용하는 방법이 필요해졌습니다.

이 문제를 해결하기 위해서 Apple은 **비동기 디자인** 방식을 채택하였습니다.

오랜 시간이 걸리는 작업을 할 때 자기 자신은 바로 반환하고,

실제 작업은 백그라운드에서 수행하여 나중에 콜백을 통해 결과를 받아보는 것입니다.

## Dispatch Queue

스레드 관리를 개발자가 직접하는 것이 아니라,

개발자는 실행할 작업만 정의하고 Dispatch Queue에 넣으면 

GCD가 필요한 스레드를 만들고 자동으로 스케줄링 해줍니다.

DispatchQueue에 들어간 작업은 순차적으로, 동시적으로 실행할 수 있지만 

먼저 들어간 작업은 먼저 실행됨을 보장합니다.

DispathQueue에 들어가는 작업은 함수나 클로져 형태로 제공되어야 합니다.

### 종류

1. Serial
    - Queue에 추가된 순서대로 한번에 하나의 작업만 수행됩니다.
    - 실행되는 작업은 별도의 스레드 상에서 실행됩니다.

    ```swift
    let queue = DispatchQueue(label: "SomeQueue")
    ```

2. Concurrent
    - 한개 이상의 작업을 **동시에** 실행합니다.
    - **별도의 스레드 상에서** 실행됩니다.

    ```swift
    let queue = DispatchQueue.global()
    ```

### Sync & Async

스레드에 작업을 할당하는 방법으로 sync와 async가 있습니다.

- async — 
스레드에 작업을 할당하고 바로 원래 흐름으로 돌아옵니다.
- sync — 
스레드에 작업을 할당한 뒤 현재 스레드를 블록하고 
추가한 작업이 끝나야만 원래대로 돌아옵니다.

## Operation Queue

OperationQueue에 들어가는 작업은 Operation 객체의 인스턴스여야만 합니다.

Operation은 수행하고자 하는 작업과 데이터를 캡슐화한 객체입니다.

OperationQueue에 포함된 작업의 진행상황을 모니터링 할 수 있습니다.

여러 작업을 동시에 수행하면서, 의존성을 설정하여 순차적으로 실행하게 만들 수 있습니다.