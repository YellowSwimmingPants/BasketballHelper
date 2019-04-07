class Game: Codable {
    var id: Int
    var gameName: String!
    var gameDate: String!
    
    init(_ id:Int, _ gameName: String, _ gameDate: String) {
        self.id = id
        self.gameName = gameName
        self.gameDate = gameDate
    }
}
