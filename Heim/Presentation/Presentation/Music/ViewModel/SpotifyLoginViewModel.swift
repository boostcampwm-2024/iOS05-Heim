//
//  SpotifyLoginViewModel.swift
//  Presentation
//
//  Created by 정지용 on 11/21/24.
//

import AuthenticationServices
import Domain
import Foundation

public final class SpotifyLoginViewModel: NSObject, ObservableObject, ViewModel {
  // MARK: - Properties
  enum Action {
    case authorize
    case token(code: String)
  }
  
  struct State: Equatable {
    var isLogined: Bool
    var challengeCode: String?
    var verifier: String?
    var authorizationURL: URL?
  }
  
  let useCase: SpotifyOAuthUseCase
  @Published var state: State
  
  // MARK: - Initializer
  public init(useCase: SpotifyOAuthUseCase) {
    self.useCase = useCase
    state = State(isLogined: false)
  }
  
  // MARK: - Methods
  func action(_ action: Action) {
    switch action {
    case .authorize:
      authorize()
    case .token(let code):
      login(code: code)
    }
  }
}

// MARK: - Private Extension
private extension SpotifyLoginViewModel {
  func setupState() {
    let randomString = useCase.generateCodeChallenge()
    state = State(
      isLogined: false,
      challengeCode: randomString.challenge,
      verifier: randomString.verifier
    )
  }
  
  func authorize() {
    do {
      setupState()
      guard let challengeHash = state.challengeCode else { throw NSError() }
      guard let url = try useCase.authorizaionURL(hash: challengeHash) else { throw NSError() }
      print(url)
      let authSession = ASWebAuthenticationSession(url: url, callbackURLScheme: "Heim") { callbackURL, error in
        if let error = error { return }
        guard let callbackURL = callbackURL else { return }
        
        // URL에서 인증 코드 추출
        guard let code = URLComponents(string: callbackURL.absoluteString)?
          .queryItems?
          .first(where: { $0.name == "code" })?
          .value else {
          return
        }
        
        self.login(code: code)
      }
      
      authSession.presentationContextProvider = self
      authSession.start()
    } catch {
      print(error)
      print("err")
      return
    }
  }
  
  // TODO: 토큰 인증
  func login(code authorizationCode: String) {
    do {
      guard let challengeString = state.verifier else { throw NSError() }
      Task {
        try await useCase.login(code: authorizationCode, plainText: challengeString)
      }
    } catch {
      return
    }
  }
}

extension SpotifyLoginViewModel: ASWebAuthenticationPresentationContextProviding {
  public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    guard let windowScene = UIApplication.shared
      .connectedScenes
      .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
          let window = windowScene.windows.first else {
      return UIWindow()
    }
    return window
  }
}
