import Foundation
import Network

/// Сервис для диагностики сетевых проблем
final class NetworkDiagnostics {
  static let shared = NetworkDiagnostics()
  
  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue(label: "NetworkMonitor")
  
  private init() {
    startMonitoring()
  }
  
  private func startMonitoring() {
    monitor.pathUpdateHandler = { path in
      DispatchQueue.main.async {
        self.logNetworkStatus(path)
      }
    }
    monitor.start(queue: queue)
  }
  
  private func logNetworkStatus(_ path: NWPath) {
    print("🌐 Network Status:")
    print("   Status: \(path.status)")
    print("   Interface Type: \(path.availableInterfaces.first?.type.description ?? "Unknown")")
    print("   Is Expensive: \(path.isExpensive)")
    print("   Is Constrained: \(path.isConstrained)")
  }
  
  /// Проверяет доступность TMDB API
  static func checkTMDBConnectivity() async -> Bool {
    guard let url = URL(string: "https://api.themoviedb.org/3") else { return false }
    
    do {
      let (_, response) = try await URLSession.shared.data(from: url)
      if let httpResponse = response as? HTTPURLResponse {
        print("🔍 TMDB Connectivity Check:")
        print("   Status Code: \(httpResponse.statusCode)")
        return httpResponse.statusCode < 400
      }
      return false
    } catch {
      print("❌ TMDB Connectivity Check Failed: \(error.localizedDescription)")
      return false
    }
  }
  
  /// Диагностирует проблемы с таймаутом
  static func diagnoseTimeoutIssues() {
    print("🔧 Timeout Diagnostics:")
    print("   Current timeout settings:")
    print("   - Request timeout: 30s")
    print("   - Resource timeout: 60s")
    print("   Recommendations:")
    print("   - Check internet connection stability")
    print("   - Try switching between WiFi/Cellular")
    print("   - Verify TMDB API key is valid")
  }
}

private extension NWInterface.InterfaceType {
  var description: String {
    switch self {
      case .wifi: return "WiFi"
      case .cellular: return "Cellular"
      case .wiredEthernet: return "Ethernet"
      case .other: return "Other"
      case .loopback: return "Loopback"
      @unknown default: return "Unknown"
    }
  }
}
