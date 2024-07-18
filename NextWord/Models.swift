import Foundation

struct APIResponse: Codable {
    let event: String
    let task_id: String
    let id: String
    let message_id: String
    let conversation_id: String
    let mode: String
    let answer: String
    let metadata: Metadata
    let created_at: Int
}

struct Metadata: Codable {
    let usage: Usage
}

struct Usage: Codable {
    let prompt_tokens: Int
    let prompt_unit_price: String
    let prompt_price_unit: String
    let prompt_price: String
    let completion_tokens: Int
    let completion_unit_price: String
    let completion_price_unit: String
    let completion_price: String
    let total_tokens: Int
    let total_price: String
    let currency: String
    let latency: Double
}

struct SentenceResponse: Codable {
    let sentence: String
    let translation: String
    let vid: String
}
