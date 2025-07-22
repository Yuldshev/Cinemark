import Foundation
import Alamofire

enum APIEndpoints: URLRequestConvertible {
  //MARK: - Auth
  case authRequestToken
  case authCreateSession(token: String)
  
  //MARK: - Movie
  case moviePopular(page: Int)
  case movieTopRated(page: Int)
  case movieUpcoming(page: Int)
  case movieNowPlaying(page: Int)
  case movieID(Int)
  
  //MARK: - TV
  case tvPopular(page: Int)
  case tvTopRated(page: Int)
  case tvOnTheAir(page: Int)
  case tvID(Int)
  
  //MARK: - Person
  case personPopular(page: Int)
  case personID(Int)
  
  var baseURL: URL { URL(string: "https://api.themoviedb.org/3")! }
  
  var method: HTTPMethod {
    switch self {
      case .authCreateSession: return .post
      default: return .get
    }
  }
  
  var path: String {
    switch self {
      case .authRequestToken: return "/authentication/token/new"
      case .authCreateSession: return "/authentication/session/new"
        
      case .moviePopular: return "/movie/popular"
      case .movieTopRated: return "/movie/top_rated"
      case .movieUpcoming: return "/movie/upcoming"
      case .movieNowPlaying: return "/movie/now_playing"
      case .movieID(let id): return "/movie/\(id)"
        
      case .tvPopular: return "/tv/popular"
      case .tvTopRated: return "/tv/top_rated"
      case .tvOnTheAir: return "/tv/on_the_air"
      case .tvID(let id): return "/tv/\(id)"
        
      case .personPopular: return "/person/popular"
      case .personID(let id): return "/person/\(id)"
    }
  }
  
  var parameters: Parameters {
    var params: Parameters = ["api_key": Secret.api_key]
    
    switch self {
      case .moviePopular(let page), .movieTopRated(let page), .movieUpcoming(let page), .movieNowPlaying(let page),
          .tvPopular(let page), .tvTopRated(let page), .tvOnTheAir(let page), .personPopular(let page):
        params["page"] = page
        params["language"] = Locale.current.language.languageCode?.identifier ?? "en"
      case .movieID, .tvID, .personID:
        params["language"] = Locale.current.language.languageCode?.identifier ?? "en"
      default: break
    }
    
    return params
  }
  
  func asURLRequest() throws -> URLRequest {
    var request = try URLRequest(url: baseURL.appendingPathComponent(path), method: method)
    
    request = try URLEncoding.queryString.encode(request, with: parameters)
    
    if case .authCreateSession(let token) = self {
      let body: [String: String] = ["request_token": token]
      request.httpBody = try JSONEncoder().encode(body)
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    return request
  }
}

