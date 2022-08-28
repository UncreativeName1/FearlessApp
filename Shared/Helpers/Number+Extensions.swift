
import Foundation

extension Double {
    
    var validValue: Self {
        return self.isInfinite ? 0 : (self.isNaN ? 0 : self)
    }
    
    var toTime: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        let formattedString = formatter.string(from: self)
        return formattedString
    }
    
}
