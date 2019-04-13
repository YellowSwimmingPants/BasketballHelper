class GameDataCount: Codable {
    var GameDataID: Int?
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
    
    init(_ GameDataID: Int,_ Period: Int,_ playerID: Int,_ FT:Int,_ FTL:Int,_ FG:Int,_ FGL:Int,_ TPM:Int,_ TPL:Int,_ Foul:Int,_ OfnReb:Int,_ DefReb:Int,_ TurnOver:Int,_ Steal:Int,_ Block:Int,_ Assist:Int){
        self.GameDataID = GameDataID
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
