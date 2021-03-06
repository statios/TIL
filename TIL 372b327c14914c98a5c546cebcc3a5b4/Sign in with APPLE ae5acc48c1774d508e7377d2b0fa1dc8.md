# Sign in with APPLE

[[Swift] Sign in with Apple - 애플 로그인 사용해보기!!](https://developer-fury.tistory.com/50)

1. Signing & Capabilities → Add 'sign in with apple'
2. Manage a entitlements file
3. import AuthenticationServices
4. 로그인 버튼 액션 정의

```jsx
let appleIDProvider = ASAuthorizationAppleIDProvider()
let request = appleIDProvider.createRequest()
request.requestedScopes = [.fullName, .email]

let authorizationController = ASAuthorizationController(authorizationRequests: [request])
authorizationController.delegate = self
authorizationController.presentationContextProvider = self
authorizationController.performRequests()
```

5. delegate 채택 및 구현

```jsx
extension LoginHomeViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
   
    if let cred = authorization.credential as? ASAuthorizationAppleIDCredential {
      
      let provider = ASAuthorizationAppleIDProvider()
      provider.getCredentialState(forUserID: cred.user) { (state, err) in
        switch state {
        case .authorized:
          print("auth")
        case .revoked:
          print("revoke")
        case .notFound:
          print("notfound")
        default: break
        }
      }
      
    }
    
  }
  
}
```