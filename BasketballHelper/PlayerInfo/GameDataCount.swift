class GameDataCount: Codable {
    var GameDataID: Int?
    var GameID: Int?
    var Period: Int?
    var playerID: Int?
    var FT: Int?
    var FTL: Int?
    var FG: Int?
    var FGL: Int?
    var TPM: Int?
    var TPL: Int?
    var Foul: Int?
    var OfnReb: Int?
    var DefReb: Int?
    var TurnOver: Int?
    var Steal: Int?
    var Block: Int?
    var Assist: Int?
    
    init(_ Period: Int, _ PlayerID: Int){
        self.GameDataID = 0
        self.Period = Period
        self.playerID = PlayerID
        self.FT = 0
        self.FTL = 0
        self.FG = 0
        self.FGL = 0
        self.TPM = 0
        self.TPL = 0
        self.Foul = 0
        self.OfnReb = 0
        self.DefReb = 0
        self.TurnOver = 0
        self.Steal = 0
        self.Block = 0
        self.Assist = 0
    }
    
    init(_ GameDataID: Int,_ GameID: Int,_ Period: Int,_ playerID: Int,_ FT:Int,_ FTL:Int,_ FG:Int,_ FGL:Int,_ TPM:Int,_ TPL:Int,_ Foul:Int,_ OfnReb:Int,_ DefReb:Int,_ TurnOver:Int,_ Steal:Int,_ Block:Int,_ Assist:Int){
        self.GameDataID = GameDataID
        self.GameID = GameID
        self.Period = Period
        self.playerID = playerID
        self.FT = FT
        self.FTL = FTL
        self.FG = FG
        self.FGL = FGL
        self.TPM = TPM
        self.TPL = TPL
        self.Foul = Foul
        self.OfnReb = OfnReb
        self.DefReb = DefReb
        self.TurnOver = TurnOver
        self.Steal = Steal
        self.Block = Block
        self.Assist = Assist
    }
    
    init(_ FT:Int,_ FTL:Int,_ FG:Int,_ FGL:Int,_ TPM:Int,_ TPL:Int,_ Foul:Int,_ OfnReb:Int,_ DefReb:Int,_ TurnOver:Int,_ Steal:Int,_ Block:Int,_ Assist:Int){
        self.FT = FT
        self.FTL = FTL
        self.FG = FG
        self.FGL = FGL
        self.TPM = TPM
        self.TPL = TPL
        self.Foul = Foul
        self.OfnReb = OfnReb
        self.DefReb = DefReb
        self.TurnOver = TurnOver
        self.Steal = Steal
        self.Block = Block
        self.Assist = Assist
    }
    
}
