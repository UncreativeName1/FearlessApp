
import SwiftUI

struct CustomizeWordsView: View {
    @Binding var isShowCustomizeWordsView: Bool
    
    @Binding var words: [String]
    @State var tags: [FLTag] = []
    @State var selectedTag: FLTag?

    @State var recommendedWords: [String] = ["you know", "actually", "ok", "right"]
    @State var recommendedTags: [FLTag] = []

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 10) {
                /// Add top content view buttons
                addButtons()
                
                ScrollView {
                    /// Add description view
                    addDescriptionView()
                    
                    /// Add added words list
                    addWordsGrid()
                }
                
                /// Add recommended words list
                TagListView(tags: $recommendedTags, selectedTag: $selectedTag)
            }
        }
        .onAppear(perform: {
            /// Load all added + recommended words list
            self.loadAddedTags()
            self.loadRecommendedTags()
        })
        .onChange(of: selectedTag, perform: { value in
            guard let value = value else { return }
            debugPrint("\(#function) selectedTag: \(value)")
            selectedTag = nil
            
            switch value.type {
            case .tag:
                if value.actionType == .add {
                    /// Add new word
                    self.addNewTag(tag: value)
                } else {
                    /// Remove existing added word
                    self.removeNewTag(tag: value)
                }
            case .addNew:
                /// Open popup for adding new word
                self.openNewTagAlert(tag: value)
            default:
                break
            }
        })
        .onChange(of: words, perform: { value in
            /// Refresh all added words list
            self.loadAddedTags()
        })
    }
    
    fileprivate func addButtons() -> some View {
        return HStack {
            /// Add title of content view
            Text(FLTexts.customizeWordsTitle)
                .foregroundColor(.thirdColor)
                .font(.system(size: 30, weight: .medium))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            
            Spacer()
            
            /// Add back button
            Button(FLTexts.back) {
                /// Hide Customize Words view
                isShowCustomizeWordsView = false
            }
            .foregroundColor(.white)
            .font(.system(size: 20, weight: .bold))
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(Color.primaryColor)
            .cornerRadius(10)
            .fixedSize()
        }
    }
    
    fileprivate func addDescriptionView() -> some View {
        /// Add content description view
        Text(FLTexts.customizeWordsDescription)
            .foregroundColor(.white)
            .font(.system(size: 18, weight: .regular))
            .padding()
            .background(Color.primaryColor)
            .cornerRadius(10)
    }
    
    func addWordsGrid() -> some View {
        /// Add added words list
        TagListView(tags: $tags, selectedTag: $selectedTag)
    }
}

extension CustomizeWordsView {
    
    fileprivate func loadAddedTags() {
        /// Load all added words list
        var allTags = words.compactMap({FLTag(text: $0, type: .tag, actionType: .remove)})
        allTags.append(FLTag(type: .addNew))
        
        let tagFiller = FLTag(text: "\(FLTexts.fillerWords):", type: .title)
        allTags.insert(tagFiller, at: 0)
        
        self.tags = allTags
    }
    
    fileprivate func loadRecommendedTags() {
        /// Load all recommended words list
        var allTags = recommendedWords.compactMap({FLTag(text: $0, type: .tag, actionType: .add)})
        
        let tagFiller = FLTag(text: "\(FLTexts.recommended):", type: .title)
        allTags.insert(tagFiller, at: 0)
        
        self.recommendedTags = allTags
    }
    
    fileprivate func openNewTagAlert(tag: FLTag) {
        /// Open popup for adding new word
        
        let vcAlert = UIAlertController(title: FLTexts.addNewWord, message: nil, preferredStyle: .alert)
        vcAlert.addAction(UIAlertAction(title: FLTexts.add, style: .default, handler: { (action) in
            guard let txtAlert = vcAlert.textFields?.first else { return }
            debugPrint("\(#function) Add button clicked txtAlert: \(txtAlert.text.defaultValue("nil"))")
            
            /// If entered text is valid or not empty, then create a new word object and added into the list.
            guard let text = txtAlert.text?.trim, !text.isEmpty else { return }
            let tag = FLTag(text: text, type: .tag, actionType: .add)
            self.addNewTag(tag: tag)
        }))
        vcAlert.addTextField { (txtAlert) in
            txtAlert.placeholder = FLTexts.enterWordPlaceholder
        }
        vcAlert.addAction(UIAlertAction(title: FLTexts.dismiss, style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            /// Show Alert
            UIApplication.shared.windows.first?.rootViewController?.present(vcAlert, animated: true, completion: nil)
        }
    }
    
    fileprivate func addNewTag(tag: FLTag) {
        /// If word is not exist in added list, then added.
        if let text = tag.text?.lowercased(), !words.contains(text) {
            words.append(text)
        }
    }
    
    fileprivate func removeNewTag(tag: FLTag) {
        /// If word is exist in added list, then removed.
        if let index = words.firstIndex(where: {$0 == tag.text}) {
            words.remove(at: index)
        }
    }
    
}

struct CustomizeWordsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomizeWordsView(isShowCustomizeWordsView: .constant(false), words: .constant([]))
    }
}
