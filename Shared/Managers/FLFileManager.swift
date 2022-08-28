
import Foundation

class FLFileManager {
    
    enum FolderNames {
        case audio
        case root

        var name: String {
            switch self {
            case .root : return ""
            case .audio: return "Audio"
            }
        }
    }
    
    static let shared = FLFileManager()
    let documentDir: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
}

extension FLFileManager {
    
    func getFilePath(fileName: String, folder: FolderNames = .root) -> URL? {
        guard !folder.name.isEmpty else {
            return self.documentDir?.appendingPathComponent(fileName)
        }
        return self.documentDir?.appendingPathComponent(folder.name).appendingPathComponent(fileName)
    }
    
    func removeFile(fileName: String) {
        guard let filePath = self.documentDir?.appendingPathComponent(fileName) else { return }
        self.removeFile(atPath: filePath)
    }
    
    func removeFile(atPath filePath: URL) {
        do {
            try FileManager.default.removeItem(at: filePath)
            debugPrint("\(#function) path: \(filePath.path), remove successfully.")
        } catch {
            debugPrint("\(#function) path: \(filePath.path), error: \(error.localizedDescription)")
        }
    }
    
}
