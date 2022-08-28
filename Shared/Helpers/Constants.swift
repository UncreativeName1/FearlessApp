
import SwiftUI

enum Page: Int, CaseIterable {
    case learn
    case practice
    //    case perfect
    
    var name: String {
        switch self {
        case .learn   : return "Learn"
        case .practice: return "Practice"
        }
    }
    
    var imageName: String {
        switch self {
        case .learn   : return FLImages.tabLearn.name
        case .practice: return FLImages.tabPractice.name
        }
    }
}

struct FLTexts {
    static let learnTitle = "Learn"
    static let learnDescription = "Enjoy free public speaking resources at your fingertips! The following slideshows are provided by our parent organization, United Speakers Global, a nonprofit dedicated to helping youth find their voice through public speaking."
    
    static let practiceTitle = "Practice"
    static let practiceDescription = "Practice is ESSENTIAL! This tool is a Machine learning analyzer that is able to report on a user-selected set of filler words. After you record a speech you will be given a report.\nHappy practicing!"
    
    static let customize = "Customize"
    static let back = "Back"
    static let transcript = "Transcript"
    static let numberOfFillerWords = "Number of Filler Words"
    
    static let customizeWordsTitle = "Customize Filler Words"
    static let customizeWordsDescription = "To fill awkward silences, we use a variety of filler words. They often distract from your speech, eating away at your message. Many do not even realize they say filler words! With this tool, you can customize what words you would like to detect."
    
    static let fillerWords = "Filler words"
    static let recommended = "Recommended"

    static let addNewWord = "Add new word"
    static let add = "Add"
    static let dismiss = "Dismiss"

    static let enterWordPlaceholder = "Enter any word"
    
}

enum FLImages {
    
    case microphone
    case learnTitle
    case practiceTitle
    case speaker
    case play
    case pause
    case plusCircle
    case minusCircle
    case tabLearn
    case tabPractice

    var name: String {
        switch self {
        case .microphone   : return "Microphone"
        case .learnTitle   : return "ic_learn_title"
        case .practiceTitle: return "ic_practice_title"
        case .speaker      : return "ic_speaker"
        case .play         : return "ic_play"
        case .pause        : return "ic_pause"
        case .plusCircle   : return "plus.circle"
        case .minusCircle  : return "minus.circle"
        case .tabLearn     : return "ic_tab_learn"
        case .tabPractice  : return "ic_tab_practice"
        }
    }
    
    var isSystemImage: Bool {
        switch self {
        case .plusCircle, .minusCircle : return true
        default: return false
        }
    }
    
    var image: Image {
        if self.isSystemImage {
            return Image(systemName: self.name)
        }
        return Image(self.name)
    }
}


struct FLSizes {
    static let topLogo : CGFloat = 50
    static let tabBar  : CGFloat = 50
    static let recorder: CGFloat = 50
}
