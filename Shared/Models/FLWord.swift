
import SwiftUI

struct FLWord : Identifiable {
    var id: String { text }
    var text: String
    var count: Int = 0
    
    static func <(lhs: FLWord, rhs: FLWord) -> Bool {
        return lhs.text < rhs.text
    }
    
    static func >(lhs: FLWord, rhs: FLWord) -> Bool {
        return lhs.text > rhs.text
    }
}
