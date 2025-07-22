import Foundation

struct RequestTokenResponse: Decodable {
  let success: Bool
  let expiresAt: String
  let requestToken: String
  
  enum CodingKeys: String, CodingKey {
    case success
    case expiresAt = "expires_at"
    case requestToken = "request_token"
  }
}

struct SessionResponse: Decodable {
  let success: Bool
  let sessionId: String
  let statusCode: Int?
  let statusMessage: String?
  
  enum CodingKeys: String, CodingKey {
    case success
    case sessionId = "session_id"
    case statusCode = "status_code"
    case statusMessage = "status_message"
  }
}
