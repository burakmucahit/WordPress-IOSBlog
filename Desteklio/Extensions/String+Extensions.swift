import Foundation

extension String {
    func htmlToString() -> String {
        guard let data = self.data(using: .utf8),
              let attributedString = try? NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil) else {
            return self
        }
        return attributedString.string
    }
    
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let date = dateFormatter.date(from: self) else { return self }
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "tr_TR")
        
        return dateFormatter.string(from: date)
    }
} 