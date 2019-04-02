class GameDataCount: Codable {
    var PeriodID: Int
    var FT: Double?
    var FTL: Double?
    var FG: Double?
    var FGL: Double?
    var TPM: Double?
    var TPL: Double?
    var Foul: Int?
    var OfnReb: Int?
    var DefReb: Int?
    var TurnOver: Int?
    var Steal: Int?
    var Block: Int?
    var Assist: Int?
    
    init(_ PeriodID: Int, _ FT:Double,_ FTL:Double,_ FG:Double,_ FGL:Double,_ TPM:Double,_ TPL:Double,_ Foul:Int,_ OfnReb:Int,_ DefReb:Int,_ TurnOver:Int,_ Steal:Int,_ Block:Int,_ Assist:Int){
        self.PeriodID = PeriodID
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
