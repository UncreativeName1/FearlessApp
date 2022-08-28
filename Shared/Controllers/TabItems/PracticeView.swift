
import SwiftUI

struct PracticeView: View {
    @Environment(\.managedObjectContext) public var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Todo.created, ascending: false)], animation: .default) public var todos: FetchedResults<Todo>
    @ObservedObject public var mic = MicMonitor(numberOfSamples: numberOfSamples)
    @State public var recording = false
    public var speechManager = SpeechManager()
    
    var body: some View {
        
        NavigationView {
            ZStack(alignment: .top) {
                VStack {
                    /// Add Top Title view
                    addContentTitle()
                    
                    /// Add Recorded audio list view
                    addRecordedAudioList()

                    Spacer()
                    
                    /// Add Record audio button
                    addRecordButton()
                }
                .padding(.top, 80)
                .background(Color.secondaryColor)
                .clipped()
            }
            .navigationTitle(Page.practice.name)
            .navigationBarHidden(true)
            .onAppear {
                /// Request speech recognize permission
                speechManager.checkPermissions()
            }
            .onDisappear(perform: {
                /// Forcefully stop recording when tab changed.
                self.stopRecording()
            })
        }
    }
}

extension PracticeView {
    
    fileprivate func addContentTitle() -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            /// Category title name
            Text(FLTexts.practiceTitle)
                .foregroundColor(.white)
                .font(.system(size: 25, weight: .bold))
            
            /// Category Description and Image
            HStack(alignment: .top, spacing: 5) {
                Text(FLTexts.practiceDescription)
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .regular))
                
                addContentTitleImage()
            }
        }
        .padding()
        .background(Color.primaryColor)
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    fileprivate func addContentTitleImage() -> some View {
        return ZStack {
            /// Add behind shadow of Category image
            Rectangle()
                .fill(Color.secondaryColor)
                .offset(x: 10, y: -10)

            /// Add Category image
            FLImages.practiceTitle.image
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(width: 90, height: 90)
                .padding(5)
                .background(Color.white)
        }
        .fixedSize()
        .padding(.trailing, 5)
    }
    
    fileprivate func addRecordedAudioList() -> some View {
        /// Add Recorded audio list view
        
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        
        return List {
            ForEach(Array(zip(todos.indices, todos)), id: \.0) { (index, item) in
                RecordRow(todo: item, index: todos.count - index)
                    .padding(.vertical, 5)
            }
            .onDelete(perform: deleteItems) /// Swipe to delete item
            .listRowInsets(EdgeInsets())
            .background(Color.secondaryColor)
        }
        .listStyle(PlainListStyle())
        .padding(.horizontal)
    }
    
    fileprivate func addRecordButton() -> some View {
        /// Add Record audio button
        HStack(alignment: .center) {
            ZStack(alignment: .center) {
                /// Horizontal dashed line
                HorizontalLine()
                    .stroke(style: StrokeStyle(lineWidth: 3, dash: [3]))
                    .foregroundColor(Color.thirdColor)
                    .hidden(recording)

                /// Visualizer view
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.clear)
                    .padding()
                    .overlay(
                        visualizerView()
                    )
                    .opacity(recording ? 1 : 0)
                
                /// Record button
                recordButton()
                    .frame(height:40)
                    .background(Color.white)
            }
            .padding(.vertical,5)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .clipped()
        }
        .frame(height:FLSizes.recorder)
    }
    
}

extension PracticeView {
    
    public func normalizedSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2
        return CGFloat(level * (30 / 25))
    }
    
    public func visualizerView() -> some View {
        VStack {
            HStack(spacing: 4) {
                ForEach(mic.soundSamples, id: \.self) { level in
                    VisualBarView(value: self.normalizedSoundLevel(level: level))
                }
            }
        }
    }
    
    public func recordButton() -> some View {
        Button(action: addItem) {
            Image(recording ? "ic_stop" : "ic_microphone")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)
            
        }.foregroundColor(.thirdColor)
    }
    
    public func addItem() {
        if speechManager.isRecording {
            self.stopRecording()
        } else {
            self.recording = true
            
            let fileId = UUID()
            let fileName = "\(fileId).\(mic.fileExtension.name)"
            mic.startMonitoring(fileName: fileName)
            speechManager.start { (speechText) in
                guard let text = speechText, !text.isEmpty else {
                    self.recording = false
                    return
                }
                debugPrint("\(#function) fileName: \(fileName), text: \(text), duration: \(mic.totalDuration(fileName: fileName))")
                
                DispatchQueue.main.async {
                    withAnimation {
                        let newItem = Todo(context: viewContext)
                        newItem.id = fileId
                        newItem.text = text
                        newItem.created = Date()
                        newItem.duration = mic.totalDuration(fileName: fileName)
                        newItem.filePath = FLFileManager.FolderNames.audio.name
                        newItem.fileName = fileName
                        newItem.fileExt = self.mic.fileExtension.name
                        
                        do {
                            try viewContext.save()
                        } catch {
                            debugPrint(error)
                        }
                    }
                }
            }
        }
        speechManager.isRecording.toggle()
    }
    
    public func deleteItems(offsets: IndexSet) {
        /// Delete recording from DB
        withAnimation {
            offsets.map {
                todos[$0]
            }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                debugPrint(error)
            }
        }
    }
    
    fileprivate func stopRecording() {
        self.recording = false
        mic.stopMonitoring()
        speechManager.stopRecording()
    }
    
}
struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeView()
            .previewLayout(.sizeThatFits)
    }
}
