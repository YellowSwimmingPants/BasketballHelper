class GameDataCount: Codable {
    var PeriodID: Int
    var FT: Double?
    var FTL: Double?
    var FG: Double?
    var FGL: Double?
    var TPM: Double?
    var TPL: Double?
    var Foul: Double?
    var OfnReb: Double?
    var DefReb: Double?
    var TurnOver: Double?
    var Steal: Double?
    var Block: Double?
    var Assist: Double?
    
    init(_ PeriodID: Int, _ FT:Double,_ FTL:Double,_ FG:Double,_ FGL:Double,_ TPM:Double,_ TPL:Double,_ Foul:Double,_ OfnReb:Double,_ DefReb:Double,_ TurnOver:Double,_ Steal:Double,_ Block:Double,_ Assist:Double){
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
