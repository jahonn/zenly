import Foundation

struct CheckIn: Identifiable, Codable {
    let id: String
    let userId: String
    let date: Date
    var stressLevel: Int // 1-10
    var tags: [String]
    var note: String?
    let createdAt: Date
    
    init(id: String = UUID().uuidString, userId: String, date: Date = Date(), stressLevel: Int, tags: [String], note: String? = nil) {
        self.id = id
        self.userId = userId
        self.date = date
        self.stressLevel = stressLevel
        self.tags = tags
        self.note = note
        self.createdAt = Date()
    }
}

struct Message: Identifiable, Codable {
    let id: String
    let role: MessageRole
    let content: String
    let createdAt: Date
    
    init(id: String = UUID().uuidString, role: MessageRole, content: String) {
        self.id = id
        self.role = role
        self.content = content
        self.createdAt = Date()
    }
}

enum MessageRole: String, Codable {
    case user
    case assistant
}

struct Conversation: Identifiable, Codable {
    let id: String
    let userId: String
    var messages: [Message]
    let createdAt: Date
    var updatedAt: Date
    
    init(id: String = UUID().uuidString, userId: String, messages: [Message] = []) {
        self.id = id
        self.userId = userId
        self.messages = messages
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

struct Meditation: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let duration: Int // seconds
    let category: MeditationCategory
    let imageName: String
    
    init(id: String = UUID().uuidString, title: String, subtitle: String, duration: Int, category: MeditationCategory) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.duration = duration
        self.category = category
        self.imageName = "meditation_\(id)"
    }
}

enum MeditationCategory: String, CaseIterable {
    case sleep = "Sleep"
    case relax = "Relax"
    case focus = "Focus"
    case wakeUp = "Wake Up"
    
    var icon: String {
        switch self {
        case .sleep: return "moon.stars.fill"
        case .relax: return "leaf.fill"
        case .focus: return "target"
        case .wakeUp: return "sun.horizon.fill"
        }
    }
}

extension Meditation {
    static let samples: [Meditation] = [
        Meditation(title: "Morning Calm", subtitle: "Start your day mindfully", duration: 300, category: .wakeUp),
        Meditation(title: "Deep Breathing", subtitle: "Quick stress relief", duration: 180, category: .relax),
        Meditation(title: "Focus Flow", subtitle: "Concentrate on your work", duration: 600, category: .focus),
        Meditation(title: "Sleep Journey", subtitle: "Drift into peaceful sleep", duration: 900, category: .sleep),
        Meditation(title: "Body Scan", subtitle: "Release tension everywhere", duration: 420, category: .relax)
    ]
}
