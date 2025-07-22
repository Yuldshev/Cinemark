import Foundation

enum LoginState {
  case initial
  case loadingToken
  case tokenReady(String)
  case authentication
  case loggedIn
  case failed(Error)
}
