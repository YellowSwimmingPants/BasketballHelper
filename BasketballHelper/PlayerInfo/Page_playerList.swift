class Page_playerList: Codable {
    var name = ""
    var nickname = ""
    var phone = ""
    var birthday = ""
    var poaition = ""
    var number = ""
    var email = ""
    
    init(_ name:String,_ nickname:String,_ phone:String,_ birthday:String,_ poaition:String,_ number:String,_ email:String) {
        self.name = name
        self.nickname = nickname
        self.phone = phone
        self.birthday = birthday
        self.poaition = poaition
        self.number = number
        self.email = email
    }
    
}
