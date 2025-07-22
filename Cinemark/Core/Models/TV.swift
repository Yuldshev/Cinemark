import Foundation

// MARK: - TV
struct TV: Codable, Identifiable {
  let adult: Bool
  let backdropPath: String
  let genreIDS: [Int]
  let id: Int
  let originCountry: [String]?
  let originalLanguage, originalName, overview: String
  let popularity: Double
  let posterPath, name: String
  let firstAirDate: String?
  let voteAverage: Double
  let voteCount: Int

  enum CodingKeys: String, CodingKey {
    case adult
    case backdropPath = "backdrop_path"
    case genreIDS = "genre_ids"
    case id
    case originCountry = "origin_country"
    case originalLanguage = "original_language"
    case originalName = "original_name"
    case overview, popularity
    case posterPath = "poster_path"
    case firstAirDate = "first_air_date"
    case name
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }

  var posterURL: URL? {
    URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
  }

  var formattedVoteAverage: String {
    String(format: "%.1f", voteAverage)
  }
}

// MARK: - DetailTV
struct DetailTV: Codable, Identifiable {
  let adult: Bool
  let backdropPath: String
  let createdBy: [CreatedBy]?
  let episodeRunTime: [Int]?
  let firstAirDate: String
  let genres: [Genre]
  let homepage: String
  let id: Int
  let inProduction: Bool
  let languages: [String]
  let lastAirDate: String
  let lastEpisodeToAir: LastEpisodeToAir?
  let name: String
  let nextEpisodeToAir: NextEpisodeToAir?
  let networks: [Network]
  let numberOfEpisodes, numberOfSeasons: Int
  let originCountry: [String]
  let originalLanguage, originalName, overview: String
  let popularity: Double
  let posterPath: String
  let productionCompanies: [Network]
  let productionCountries: [ProductionCountry]
  let seasons: [Season]?
  let spokenLanguages: [SpokenLanguage]
  let status, tagline, type: String
  let voteAverage: Double
  let voteCount: Int

  enum CodingKeys: String, CodingKey {
    case adult
    case backdropPath = "backdrop_path"
    case createdBy = "created_by"
    case episodeRunTime = "episode_run_time"
    case firstAirDate = "first_air_date"
    case genres, homepage, id
    case inProduction = "in_production"
    case languages
    case lastAirDate = "last_air_date"
    case lastEpisodeToAir = "last_episode_to_air"
    case name
    case nextEpisodeToAir = "next_episode_to_air"
    case networks
    case numberOfEpisodes = "number_of_episodes"
    case numberOfSeasons = "number_of_seasons"
    case originCountry = "origin_country"
    case originalLanguage = "original_language"
    case originalName = "original_name"
    case overview, popularity
    case posterPath = "poster_path"
    case productionCompanies = "production_companies"
    case productionCountries = "production_countries"
    case seasons
    case spokenLanguages = "spoken_languages"
    case status, tagline, type
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }

  var backdropURL: URL? {
    URL(string: "https://image.tmdb.org/t/p/w780/\(backdropPath)")
  }
}

// MARK: - CreatedBy
struct CreatedBy: Codable {
  let id: Int
  let creditID, name, originalName: String
  let gender: Int
  let profilePath: String?

  enum CodingKeys: String, CodingKey {
    case id
    case creditID = "credit_id"
    case name
    case originalName = "original_name"
    case gender
    case profilePath = "profile_path"
  }
}

// MARK: - LastEpisodeToAir
struct LastEpisodeToAir: Codable {
  let id: Int
  let name, overview: String
  let voteAverage: Double
  let voteCount: Int
  let airDate: String
  let episodeNumber: Int
  let episodeType, productionCode: String
  let runtime, seasonNumber, showID: Int?
  let stillPath: String?

  enum CodingKeys: String, CodingKey {
    case id, name, overview
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
    case airDate = "air_date"
    case episodeNumber = "episode_number"
    case episodeType = "episode_type"
    case productionCode = "production_code"
    case runtime
    case seasonNumber = "season_number"
    case showID = "show_id"
    case stillPath = "still_path"
  }
}

// MARK: - Network
struct Network: Codable {
  let id: Int
  let logoPath: String?
  let name, originCountry: String

  enum CodingKeys: String, CodingKey {
    case id
    case logoPath = "logo_path"
    case name
    case originCountry = "origin_country"
  }
}

// MARK: - Season
struct Season: Codable {
  let airDate: String?
  let episodeCount, id: Int
  let name, overview, posterPath: String?
  let seasonNumber: Int
  let voteAverage: Double

  enum CodingKeys: String, CodingKey {
    case airDate = "air_date"
    case episodeCount = "episode_count"
    case id, name, overview
    case posterPath = "poster_path"
    case seasonNumber = "season_number"
    case voteAverage = "vote_average"
  }
}

// MARK: - NextEpisodeToAir
struct NextEpisodeToAir: Codable {
  let id: Int
  let name: String
  let airDate: String

  enum CodingKeys: String, CodingKey {
    case id, name
    case airDate = "air_date"
  }
}
