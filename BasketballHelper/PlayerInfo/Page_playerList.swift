class Page_playerList: Codable {
    var id: Int
    var name: String?
    var nickname: String?
    var phone: String?
    var birthday: String?
    var number: String?
    var position: String?
    var email: String?
    
    init(_ id: Int, _ name:String,_ nickname:String,_ phone:String,_ birthday:String,_ number:String,_ position:String,_ email:String) {
        self.id = id
        self.name = name
        self.nickname = nickname
        self.phone = phone
        self.birthday = birthday
        self.number = number
        self.position = position
        self.email = email
    }
    
}
