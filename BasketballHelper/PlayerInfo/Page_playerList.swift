class Page_playerList: Codable {
    var playerID: Int
    var name: String?
    var nickname: String?
    var phone: String?
    var birthday: String?
    var number: String?
    var position: String?
    var email: String?
    var teamID: String?
    
    init(_ playerID: Int, _ name:String,_ nickname:String,_ phone:String,_ birthday:String,_ number:String,_ position:String,_ email:String,_ teamID:String) {
        self.playerID = playerID
        self.name = name
        self.nickname = nickname
        self.phone = phone
        self.birthday = birthday
        self.number = number
        self.position = position
        self.email = email
        self.teamID = teamID
    }
    
}
