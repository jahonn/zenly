import SwiftUI

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var inputText: String = ""
    @State private var isTyping: Bool = false
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Messages List
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            if messages.isEmpty {
                                EmptyChatView()
                            }
                            
                            ForEach(messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                            
                            if isTyping {
                                TypingIndicator()
                                    .id("typing")
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages.count) { _, _ in
                        withAnimation {
                            proxy.scrollTo("typing", anchor: .bottom)
                        }
                    }
                }
                
                // Input Area
                VStack(spacing: 0) {
                    Divider()
                    
                    HStack(spacing: 12) {
                        TextField("Message Zenly...", text: $inputText, axis: .vertical)
                            .textFieldStyle(.plain)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(20)
                            .lineLimit(1...5)
                            .focused($isInputFocused)
                        
                        Button(action: sendMessage) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(inputText.isEmpty ? Color.Theme.textSecondary : Color.Theme.primary)
                        }
                        .disabled(inputText.isEmpty)
                    }
                    .padding()
                }
            }
            .background(Color.Theme.background.ignoresSafeArea())
            .navigationTitle("AI Chat")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        let userMessage = Message(role: .user, content: inputText)
        messages.append(userMessage)
        inputText = ""
        
        // Simulate AI response
        isTyping = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let aiResponse = generateAIResponse(to: userMessage.content)
            messages.append(Message(role: .assistant, content: aiResponse))
            isTyping = false
        }
    }
    
    private func generateAIResponse(to message: String) -> String {
        let responses = [
            "I hear you. That sounds really challenging. Take a deep breath - you're doing better than you think. 💙",
            "It's completely normal to feel that way. Remember, stress is your body's response to challenges, not a reflection of your worth.",
            "Let's work through this together. What would help you feel more in control right now?",
            "I understand this is tough. Have you tried the 4-7-8 breathing technique? It can help calm your nervous system.",
            "You're not alone in this. Many people face similar challenges. What coping strategies have worked for you before?",
            "Taking time to acknowledge your feelings is already a big step. Be gentle with yourself. 🌿"
        ]
        return responses.randomElement() ?? responses[0]
    }
}

struct EmptyChatView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "message.bubble.hearts.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.Theme.gradient)
            
            Text("Talk to Zenly")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.Theme.textPrimary)
            
            Text("Share what's on your mind.\nI'm here to listen and help.")
                .font(.body)
                .foregroundColor(Color.Theme.textSecondary)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 12) {
                PromptSuggestion(text: "I'm feeling overwhelmed with work") {
                    // Quick prompt
                }
                PromptSuggestion(text: "Help me calm down") {
                    // Quick prompt
                }
                PromptSuggestion(text: "I'm anxious about something") {
                    // Quick prompt
                }
            }
            .padding(.top, 16)
        }
        .padding(32)
    }
}

struct PromptSuggestion: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.subheadline)
                .foregroundColor(Color.Theme.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.Theme.primary.opacity(0.1))
                .cornerRadius(20)
        }
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if message.role == .assistant {
                Image(systemName: "brain.head.profile")
                    .font(.body)
                    .foregroundColor(Color.Theme.primary)
            }
            
            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.body)
                    .foregroundColor(message.role == .user ? .white : Color.Theme.textPrimary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(message.role == .user ? Color.Theme.primary : Color.white)
                    .cornerRadius(20)
                
                Text(message.createdAt.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(Color.Theme.textSecondary)
            }
            
            if message.role == .user {
                Image(systemName: "person.fill")
                    .font(.body)
                    .foregroundColor(Color.Theme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.role == .user ? .trailing : .leading)
    }
}

struct TypingIndicator: View {
    @State private var opacity: Double = 0.3
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "brain.head.profile")
                .font(.body)
                .foregroundColor(Color.Theme.primary)
            
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.Theme.textSecondary)
                        .frame(width: 8, height: 8)
                        .opacity(opacity)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                            value: opacity
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(20)
        }
        .onAppear {
            opacity = 1.0
        }
    }
}

#Preview {
    ChatView()
}
