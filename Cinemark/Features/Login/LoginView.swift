import SwiftUI

struct LoginView: View {
  @State private var vm = LoginVM()
  
  var body: some View {
    VStack(spacing: 24) {
      Spacer()
      
      Image(systemName: "film.stack")
        .font(.system(size: 80))
        
      Text("Login TMDB")
        .font(.largeTitle.bold())
      
      content.frame(height: 100)
      
      Spacer()
    }
    .padding()
    .task { await vm.startLoginProcess() }
    .onOpenURL { _ in
      Task { await vm.createSession() }
    }
  }
}

//MARK: - Helper
extension LoginView {
  @ViewBuilder
  private var content: some View {
    switch vm.state {
      case .initial, .loadingToken:
        ProgressView("Получение токена...")
        
      case .tokenReady(let token):
        if let url = URL(string: "https://www.themoviedb.org/authenticate/\(token)") {
          VStack(spacing: 8) {
            Link("Авторизоваться на TMDB", destination: url)
              .buttonStyle(.borderedProminent)
            
            Text("После авторизации вернитесь в приложение")
              .font(.caption)
              .foregroundStyle(.secondary)
          }
        }
        
      case .authentication: ProgressView("Создание сессии...")
      case .loggedIn:
        VStack(spacing: 8) {
          Image(systemName: "checkmark.circle.fill")
            .font(.largeTitle)
            .foregroundStyle(.green)
          
          Text("Success login")
            .font(.headline)
        }
        case .failed(let error):
        VStack(spacing: 8) {
          Image(systemName: "xmark.circle.fill")
            .font(.largeTitle)
            .foregroundStyle(.red)
          
          Text(error.localizedDescription)
            .font(.headline)
            .multilineTextAlignment(.center)
          
          Button("Try again") {
            vm.retry()
          }
          .buttonStyle(.bordered)
          .padding(.top)
        }
    }
  }
}

//MARK: - Preview
#Preview {
  LoginView()
}
