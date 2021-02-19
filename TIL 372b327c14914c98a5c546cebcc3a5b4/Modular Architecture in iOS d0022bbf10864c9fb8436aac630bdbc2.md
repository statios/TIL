# Modular Architecture in iOS

[A Modular Architecture in Swift.](https://medium.com/flawless-app-stories/a-modular-architecture-in-swift-aafd9026aa99)

![Modular%20Architecture%20in%20iOS%20d0022bbf10864c9fb8436aac630bdbc2/image.png](Modular%20Architecture%20in%20iOS%20d0022bbf10864c9fb8436aac630bdbc2/image.png)

## Architecture

하나의 workspace에 multiple project를 포함하여 Modular architecture를 디자인한다. 

앱은 모듈을 의존하며 각 모듈 또한 서로를 의존할 수 있다.

코코아팟은 외부 의존성으로 제공한다.

![Modular%20Architecture%20in%20iOS%20d0022bbf10864c9fb8436aac630bdbc2/image%201.png](Modular%20Architecture%20in%20iOS%20d0022bbf10864c9fb8436aac630bdbc2/image%201.png)

각 모듈은 애플리케이션 target에서 사용되는 프레임워크로 컴파일된다. 

모듈은 서로 의존할 수 있으며(순환 의존성없음) cocoapod에 의해 관리되는 서드파티 SDK에도 의존할 수 있다.