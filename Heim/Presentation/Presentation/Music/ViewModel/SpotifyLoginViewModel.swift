//
//  SpotifyLoginViewModel.swift
//  Presentation
//
//  Created by 정지용 on 12/1/24.
//

import AuthenticationServices
import Domain
import Foundation

public final class SpotifyLoginViewModel: NSObject, ObservableObject, ViewModel {
  // MARK: - Properties
  public enum Action {
    case setup
    case authorize
  }

  public struct State: Equatable {
    var isLogined: Bool
    var challengeCode: String?
    var verifier: String?
    var authorizationURL: URL?
  }

  let useCase: SpotifyOAuthUseCase
  @Published public var state: State

  // MARK: - Initializer
  public init(useCase: SpotifyOAuthUseCase) {
    self.useCase = useCase
    state = State(isLogined: false)
  }

  // MARK: - Methods
  public func action(_ action: Action) {
    switch action {
    case .setup:
      setupState()
    case .authorize:
      authorize()
    }
  }

  public func setupState() {
    let randomString = useCase.generateCodeChallenge()
    state = State(
      isLogined: false,
      challengeCode: randomString.challenge,
      verifier: randomString.verifier
    )
  }
}
// MARK: - Private Extension
private extension SpotifyLoginViewModel {
  func authorize() {
    do {
      guard let challengeHash = state.challengeCode else { return }
      guard let url = try useCase.authorizaionURL(hash: challengeHash) else { return }
      let authSession = ASWebAuthenticationSession(url: url, callbackURLScheme: "Heim") { callbackURL, error in
        if error != nil { return }
        guard let callbackURL = callbackURL else { return }
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
      return
    }
  }

  func login(code authorizationCode: String) {
    guard let challengeString = state.verifier else { return }
    Task {
      do {
        try await useCase.login(code: authorizationCode, plainText: challengeString)
      } catch {
        // TODO
        throw NSError()
      }
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
