# Preserving and Restoring State

ViewController는 상태(state) 보존(preservation) 및 복원(restoration) 프로세스에서 중요한 역할을 합니다.

state preservation은 앱이 일시 중단되기 전에 앱의 configuration을 기록하여 이후 앱 실행시 복원할 수 있도록 합니다.

앱을 이전 configutation으로 되돌리면 사용자의 시간이 절약되고 더 나은 사용자 경험을 제공할 수 있습니다.

상태 보존 및 복원 과정은 대부분은 자동이지만,

preserve하기 위해서 앱의 일정 부분을 iOS에 알려줘야 합니다.

1. ViewController에 복원 식별자(identifier)를 할당해야 합니다 - 필수
2. iOS에 앱 시작 시 ViewController를 만들거나 찾는 방법을 설명해야 합니다. - 필수
3. 각 ViewController에 원래 configuration으로 되돌리는데 필요한 데이터를 저장합니다. - 선택

## Tagging View Controllers for Preservation

UIKit은 보존하라고 지시한 ViewController만 보존합니다.

ViewController는 restorationIdentifier 프로퍼티를 소유하며 기본값은 nil입니다.

이 프로퍼티에 nil이아닌 값을 할당하면 preserve를 자동으로 수행합니다.

스토리보드나 코드에서 restorationIdentifier 값을 할당할 수 있어요.

child에 restorationIdentifier이 할당되면 container도 restorationIdentifier가 할당되어야 합니다.

보존 프로세스 동안, window의 root view controller에서 시작해서 view controller 계층을 이동합니다.

해당 계층의 view controller에 restorationIdentifier가 없으면 하위 view controller와 presented view controller의 복원도 무시됩니다.

### Choosing Effective Restoration Identifiers

UIKit은 복원 식별자 문자열을 사용하여 나중에 뷰 컨트롤러를 다시 만드므로 코드에서 쉽게 식별할 수 있는 문자열을 선택해야 합니다.

If UIKit cannot automatically create one of your view controllers, it asks you to create it, providing you with the restoration identifiers of the view controller and all of its parent view controllers. This chain of identifiers represents the restoration path for the view controller and is how you determine which view controller is being requested. The restoration path starts at the root view controller and includes every view controller up to and including the one that was requested.

restoration id를 view controller의 클래스 이름으로 정하는 경우가 대부분입니다.

하지만 같은 view controller 클래스를 여러곳에서 사용한다면 더 의미 있는 이름으로 지정하는게 좋아요.

예를 들면, 뷰 컨트롤러가 관리하는 데이터를 기반으로 이름 지어주는 것입니다.

모든 뷰 컨트롤러의 restoration path는 unique해야 합니다.

container가 child 두개를 갖는 경우에, container는 각각의 child에 다른 restoration id를 할당해야합니다.

UIKit에서 제공하는 container는 하나의 id만 지정하더라도 각각의 child에 다른 path를 자동으로 부여합니다.

Navigation controller의 경우에는 child에 position에 기반해서 restoration path를 할당하게 됩니다.