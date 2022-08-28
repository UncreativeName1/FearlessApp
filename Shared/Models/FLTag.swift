
import SwiftUI

struct FLTag : Identifiable, Equatable {
    
    enum TagType {
        case tag
        case addNew
        case title
    }
    
    enum ActionType {
        case add
        case remove
    }
    
    var id = UUID()
    var text: String?
    var isAdded: Bool?
    var textColor: Color = .white
    var backgroundColor: Color = .thirdColor
    var font: Font = .system(size: 20, weight: .bold)
    var isEnabled: Bool = true
    var type: TagType = .tag
    var actionType: ActionType = .add

    static func ==(lhs: FLTag, rhs: FLTag) -> Bool {
        return lhs.id == rhs.id
    }
}
