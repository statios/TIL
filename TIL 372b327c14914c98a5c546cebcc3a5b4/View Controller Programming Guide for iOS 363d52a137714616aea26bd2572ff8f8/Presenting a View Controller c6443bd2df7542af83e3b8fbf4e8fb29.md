# Presenting a View Controller

ViewController를 present하면 dismiss할 때까지 아래의 뷰 컨트롤러 관계가 생성됩니다.

presentingViewController - presentedViewController

## The Presentation and Transition Process

present할 때 UIKit에 내장된 애니메이션을 사용하거나 직접 커스텀할 수도 있습니다.

### Presentation Styles

presentation style은 뷰 컨트롤러가 화면에 보이는 방식을 지정합니다.

UIKit은 여러가지 표준 스타일을 제공하고 있고요 커스텀 스타일을 만들수도 있어요.

1. Full-Screen Presentaion Styles

    화면 전체를 덮는 스타일입니다.

    present 이후에는 아래에 깔리는 content의 interaction은 받지 않아요.

2. Popover Style
3. Current Context Styles
4. Custom Presentation Styles

### Transition Styles