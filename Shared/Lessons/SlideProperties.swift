
import Foundation
import SwiftUI

struct Slides: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var description: String
    var pdfName: String
    private var imageName: String
    
    var image: Image {
        Image(imageName)
    }
 
    /// Create a static record
    static var empty: Self {
        let data = """
            {
                "id": 1,
                "name": "Intro To Public Speaking",
                "description": "Understanding the art",
                "pdfName": "IntroToPublicSpeaking",
                "imageName": "mic"
            }
        """.data(using: .utf8)
        return try! JSONDecoder().decode(Slides.self, from: data!)
    }
}
