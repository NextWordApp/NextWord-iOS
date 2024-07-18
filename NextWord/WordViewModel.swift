import Foundation
import Combine

class WordViewModel: ObservableObject {
    @Published var currentWord: Word?
    @Published var sentence: String = ""
    @Published var translation: String = ""
    @Published var videoURL: URL?
    @Published var isLoading: Bool = false
    
    private var words: [Word] = []
    private var currentIndex: Int = 0
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadWords()
    }
    
    func loadWords() {
        if let url = Bundle.main.url(forResource: "word_list", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                words = try JSONDecoder().decode([Word].self, from: data)
            } catch {
                print("Failed to load words: \(error.localizedDescription)")
            }
        }
    }
    
    func loadNextWord() {
        guard !words.isEmpty else { return }
        currentWord = words[currentIndex]
        fetchSentence(for: words[currentIndex].word)
        currentIndex = (currentIndex + 1) % words.count
    }
    
    func fetchSentence(for word: String) {
        isLoading = true
        let url = URL(string: "https://api.dify.ai/v1/chat-messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer app-rHRbhSljH8NOu4UtysRjH4yQ", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "inputs": [:],
            "query": word,
            "response_mode": "blocking",
            "conversation_id": "",
            "user": "abc-123",
            "files": [
                [
                    "type": "",
                    "transfer_method": "",
                    "url": ""
                ]
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            if let error = error {
                print("Error fetching sentence: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // 打印从 API 接收到的原始数据
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received JSON: \(jsonString)")
            }
            
            do {
                let sentenceResponse = try JSONDecoder().decode(SentenceResponse.self, from: data)
                DispatchQueue.main.async {
                    self.sentence = sentenceResponse.sentence
                    self.translation = sentenceResponse.translation
                    self.videoURL = URL(string: sentenceResponse.vid)
                }
            } catch {
                print("Failed to decode response: \(error.localizedDescription)")
            }
        }.resume()
    }
}
