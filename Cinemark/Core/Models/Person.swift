import Foundation

struct Person: Codable, Identifiable {
  let adult: Bool
  let gender, id: Int
  let knownForDepartment: String?
  let name, originalName: String
  let popularity: Double
  let profilePath: String
  let knownFor: [KnownFor]

  enum CodingKeys: String, CodingKey {
    case adult, gender, id
    case knownForDepartment = "known_for_department"
    case name
    case originalName = "original_name"
    case popularity
    case profilePath = "profile_path"
    case knownFor = "known_for"
  }

  var profileURL: URL? {
    URL(string: "https://image.tmdb.org/t/p/original/\(profilePath)")
  }
}

// MARK: - KnownFor
struct KnownFor: Codable {
  let adult: Bool
  let backdropPath: String?
  let id: Int
  let title, originalTitle: String?
  let overview, posterPath: String
  let mediaType: String?
  let originalLanguage: String?
  let genreIDS: [Int]
  let popularity: Double
  let releaseDate: String?
  let video: Bool?
  let voteAverage: Double
  let voteCount: Int
  let name, originalName, firstAirDate: String?
  let originCountry: [String]?

  enum CodingKeys: String, CodingKey {
    case adult
    case backdropPath = "backdrop_path"
    case id, title
    case originalTitle = "original_title"
    case overview
    case posterPath = "poster_path"
    case mediaType = "media_type"
    case originalLanguage = "original_language"
    case genreIDS = "genre_ids"
    case popularity
    case releaseDate = "release_date"
    case video
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
    case name
    case originalName = "original_name"
    case firstAirDate = "first_air_date"
    case originCountry = "origin_country"
  }
}

// MARK: - DetailPerson
struct DetailPerson: Codable, Identifiable {
  let adult: Bool
  let alsoKnownAs: [String]
  let biography, birthday: String?
  let deathday: String?
  let gender: Int
  let homepage: String?
  let id: Int
  let imdbID, knownForDepartment, placeOfBirth: String?
  let name: String
  let popularity: Double
  let profilePath: String

  enum CodingKeys: String, CodingKey {
    case adult
    case alsoKnownAs = "also_known_as"
    case biography, birthday, deathday, gender, homepage, id
    case imdbID = "imdb_id"
    case knownForDepartment = "known_for_department"
    case name
    case placeOfBirth = "place_of_birth"
    case popularity
    case profilePath = "profile_path"
  }

  var profileURL: URL? {
    URL(string: "https://image.tmdb.org/t/p/original/\(profilePath)")
  }
}
