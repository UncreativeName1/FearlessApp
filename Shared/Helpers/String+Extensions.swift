
import SwiftUI

extension String {
    
    var trim: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func highlight(matchedWords: Binding<[String]>, color: Color? = nil, font: Font? = nil) -> Text {
        let words = self.components(separatedBy: " ")
        let combineTexts = words.reduce(Text("")) { (result, word) -> Text in
            if matchedWords.wrappedValue.contains(where: {$0.lowercased() == word.lowercased()}) {
                return result + Text(word).foregroundColor(color).font(font) + Text(" ")
            }
            return result + Text(word).font(.system(size: 18, weight: .regular)) + Text(" ")
        }
        return combineTexts
    }
    
    func wordsCount(word: String) -> Int {
        return self.components(separatedBy: " ").filter({$0.lowercased() == word.lowercased()}).count
    }
    
    func wordsCount(words: Set<String>) -> [FLWord] {
        let wordsGroup = words.compactMap { (word) -> FLWord? in
            let count = self.wordsCount(word: word)
            let newWord = FLWord(text: word, count: count)
            return newWord
        }
        return wordsGroup
    }
    
}
