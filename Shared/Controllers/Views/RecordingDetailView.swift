
import SwiftUI

struct RecordingDetailView: View {
    
    var todo: Todo
    var index: Int
    
    @State var recordText: String = ""
    @State var matchedWordsCount: Int = 0
    @State var words: [String] = ["Um", "Like", "So"]
    @State var matchedWords: [FLWord] = []
    
    @State private var isShowCustomizeWordsView: Bool = false
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    /// Audio Player
    @ObservedObject private var mediaPlayer: FLMediaPlayer = FLMediaPlayer()
    
    //MARK:- UI Changes
    
    var body: some View {
        ZStack {
            Color.secondaryColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                /// Add Recorder audio row view
                addRecordRow()
                
                /// Add audio detail view
                addAudioDetailView()
            }
            .padding(.horizontal, 15)
        }
        .onAppear(perform: {
            self.loadWords()
        })
        .onDisappear(perform: {
            self.stopAudio()
        })
        .onChange(of: words, perform: { value in
            debugPrint("words: \(value)")
            self.loadWords()
        })
    }
    
    fileprivate func addRecordRow() -> some View {
        RecordRow(todo: self.todo, index: self.index)
    }
    
    fileprivate func addAudioDetailView() -> some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            Group {
                if isShowCustomizeWordsView {
                    /// Show Customize words view
                    CustomizeWordsView(isShowCustomizeWordsView: $isShowCustomizeWordsView, words: $words)
                } else {
                    VStack(spacing: 10) {
                        /// Add customize and back buttons
                        addButtons()
                        
                        ScrollView {
                            /// Add recorded audio's transcript message
                            addTranscriptMessageView()
                            
                            /// Add calculation of filler words
                            addCalculateFillerWordsView()
                        }
                        
                        /// Add player view
                        addPlayer()
                    }
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
        }
        .addBorder()
    }
    
    fileprivate func addButtons() -> some View {
        return HStack(alignment: .bottom) {
            /// Transcript Title
            Text("\(FLTexts.transcript):")
                .font(.system(size: 22, weight: .medium))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            
            Spacer()
            
            /// Add Customize button
            Button(FLTexts.customize) {
                /// Show Customize Words view
                isShowCustomizeWordsView = true
            }
            .foregroundColor(.white)
            .font(.system(size: 20, weight: .bold))
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(Color.thirdColor)
            .cornerRadius(10)
            .fixedSize()
            
            Spacer()
            
            /// Add Back button
            Button(FLTexts.back) {
                self.mode.wrappedValue.dismiss()
            }
            .foregroundColor(.white)
            .font(.system(size: 20, weight: .bold))
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(Color.primaryColor)
            .cornerRadius(10)
            .fixedSize()
        }
        .frame(maxWidth: .infinity)
    }
    
    fileprivate func addTranscriptMessageView() -> some View {
        /// Add transcript message
        todo.text.defaultValue()
            .highlight(matchedWords: $words, color: .thirdColor, font: .system(size: 18, weight: .medium))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    fileprivate func addCalculateFillerWordsView() -> some View {
        /// Calculate filler words
        VStack {
            /// Calculate number of filler words
            Text("\(FLTexts.numberOfFillerWords): \(Text("\(matchedWordsCount)").foregroundColor(.thirdColor))")
                .font(.system(size: 20, weight: .bold))
            
            Spacer(minLength: 15)
            
            /// Add words list view
            addWordsGrid()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.secondaryColor)
        .cornerRadius(10.0)
    }
    
    fileprivate func addWordsGrid() -> some View {
        /// Set fix 3 columns
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]
        return ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(matchedWords) { word in
                    HStack {
                        /// Word name
                        Text("\(word.text.capitalized):")
                            .font(.system(size: 18, weight: .bold))
                        
                        /// Matched word counts
                        Text("\(word.count)").foregroundColor(.thirdColor)
                            .font(.system(size: 18, weight: .bold))
                    }
                }
            }
        }
    }
    
}

//MARK:- Functions

extension RecordingDetailView {
    //MARK:- Player
    
    fileprivate func addPlayer() -> some View {
        HStack(spacing: 0) {
            /// Play/Pause button
            Button(action: {
                debugPrint("\(#function)")
                
                /// Audio will be play, if "mediaPlayer.isPlaying" status is true else stopped.
                if self.mediaPlayer.isPlaying {
                    self.stopAudio()
                } else {
                    self.playAudio()
                }
                
            }, label: {
                Image(mediaPlayer.isPlaying ? FLImages.pause.name : FLImages.play.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 40)
                    .padding(5)
            })
            
            /// Player progress slider
            Slider(value: $mediaPlayer.currentDuration, in: 0...todo.duration, onEditingChanged: { (started) in
                debugPrint("\(#function) slider started: \(started), mediaPlayer.currentDuration: \($mediaPlayer.currentDuration.wrappedValue)")
                self.mediaPlayer.isSeeking = started
                if !started {
                    self.mediaPlayer.seekTime = $mediaPlayer.currentDuration.wrappedValue
                }
            })
            .colorMultiply(.secondaryColor)
        }
        .padding(.top, 10)
    }
    
    fileprivate func playAudio() {
        guard let fileUrl = todo.fileUrl else { return }
        debugPrint("\(#function) fileUrl: \(fileUrl.path)")
        
        self.mediaPlayer.fileUrl = fileUrl
        self.mediaPlayer.play()
    }
    
    fileprivate func stopAudio() {
        debugPrint("\(#function)")
        self.mediaPlayer.stop()
    }
}

extension RecordingDetailView {
    
    fileprivate func loadWords() {
        debugPrint("\(#function)")

        /// Load words and their counts list
        let allWords = todo.text.defaultValue().wordsCount(words: Set(words)).sorted(by: {$0 < $1})
        matchedWords = allWords
        matchedWordsCount = matchedWords.reduce(0, {$0 + (($1.count > 0) ? 1 : 0)})
    }
}

struct RecordingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingDetailView(todo: Todo(), index: 0)
    }
}

extension Todo {
    
    fileprivate var fileUrl: URL? {
        guard let fileName = self.fileName, let filePath = self.filePath, let fileUrl = FLFileManager.shared.documentDir?.appendingPathComponent(filePath).appendingPathComponent(fileName) else { return nil }
        return fileUrl
    }
    
}
