import Foundation

@MainActor
@Observable
final class LoginVM {
  private(set) var state: LoginState = .initial
  
  private let networkService: NetworkServiceProtocol
  private var requestToken: String?
  
  init(networkService: NetworkServiceProtocol = NetworkService.shared) {
    self.networkService = networkService
  }
  
  func startLoginProcess() async {
    guard state.isInitial else { return }
    state = .loadingToken
    
    // Проверяем связь с TMDB перед основным запросом
    let isConnected = await NetworkDiagnostics.checkTMDBConnectivity()
    if !isConnected {
      print("⚠️ TMDB API недоступен, но продолжаем попытку...")
    }
    
    do {
      let token = try await networkService.createRequestToken()
      self.requestToken = token
      state = .tokenReady(token)
    } catch {
      // Логируем подробную информацию об ошибке
      if let networkError = error as? NetworkError {
        switch networkError {
          case .timeout:
            print("⏱️ Timeout error occurred")
            NetworkDiagnostics.diagnoseTimeoutIssues()
          case .connectionLost:
            print("📶 Connection lost during request")
          case .noConnection:
            print("🚫 No internet connection")
          default:
            print("❌ Network error: \(networkError.localizedDescription)")
        }
      }
      
      state = .failed(error)
    }
  }
  
  func createSession() async {
    guard let token = requestToken else {
      state = .failed(NetworkError.badRequest(error: nil))
      return
    }
    
    state = .authentication
    
    do {
      let _ = try await networkService.createSession(with: token)
      //TODO: - Keychain service
      state = .loggedIn
    } catch {
      state = .failed(error)
    }
  }
  
  func retry() {
    self.requestToken = nil
    self.state = .initial
    Task { await startLoginProcess() }
  }
}

private extension LoginState {
  var isInitial: Bool {
    if case .initial = self { return true }
    return false
  }
}
