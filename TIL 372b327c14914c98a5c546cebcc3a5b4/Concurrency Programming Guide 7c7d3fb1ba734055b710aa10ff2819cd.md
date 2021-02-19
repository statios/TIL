# Concurrency Programming Guide

## Introduction

- 앱의 최적 쓰레드를 직접 구현하는 것은 매우 어려우며 구현하더라도 복잡성이 높고 위험이 따른다
- 따라서 iOS에서는 직접 쓰레드를 지정하는 것이 아니라 특정 task만 정의하고 시스템이 쓰레딩을 수행한다

## Dispatch Queues

- C기반 매커니즘
- 작업을 순차적으로 또는 동시에 수행하지만 항상 First-in, first-out로 수행
- Serial dispatch queues — 한번에 하나의 작업만 실행하며 해당 task가 완료될 때까지 기다린 후 다음 task를 시작
- concurrent dispatch queues — 이미 시작된 작업이 완료될 때 까지 기다리지 않
- 자동으로 전체적인 쓰레드 pool을 관리
- 쓰레드 스택이 앱 메모리에 남아있지 않아서 효율적
- task를 비동기적으로 전달해도 대기열을 교착상태로 만들 수 없다

## Dispatch Sources

- 특정 타입의 시스템 이벤트를 비동기적으로 처리하는 C 기반 메커니즘
- 시스템 이벤트에 대한 정보를 캡슐화하여 해당 이벤트가 발생할 때마다 특정 블록객체 또는 함수를 dispatch queue로 전송
- timer, signal handler, descriptor-related events, process-related events, 마이크로커널 포트 이벤트, custom events that you trigger — 이벤트 모니터링

## Operation Queue

## References

[Introduction to iOS Concurrency](https://medium.com/shakuro/introduction-to-ios-concurrency-a5db1cf18fa6)

[iOS ) Concurrency Programming Guide - Concurrency and Application Design](https://zeddios.tistory.com/509)

[iOS ) Concurrency Programming Guide - Operation Queues](https://zeddios.tistory.com/510)

[iOS ) Concurrency Programming Guide - Dispatch Queues](https://zeddios.tistory.com/513)

[iOS ) GCD - Dispatch Queue사용법 (1)](https://zeddios.tistory.com/516)

[iOS ) GCD - Dispatch Queue사용법 (2) / DispatchWorkItem, DispatchGroup](https://zeddios.tistory.com/520)

[iOS ) Prioritize Work with Quality of Service Classes](https://zeddios.tistory.com/521)