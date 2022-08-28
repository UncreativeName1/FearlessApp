
import Foundation

extension Optional where Wrapped == String {
    //MARK:- String
    
    public func defaultValue(_ value: String = "") -> String {
        guard let unwrapped = self else { return value }
        return unwrapped
    }
}

extension Optional where Wrapped == Date {
    //MARK:- Date
    
    public func defaultValue(_ value: Date = Date()) -> Date {
        guard let unwrapped = self else { return value }
        return unwrapped
    }
}
