import SwiftUI

struct HomeView: View {
    @State private var todayCheckIn: CheckIn?
    @State private var showCheckInSheet = false
    @State private var stressLevel: Double = 5
    @State private var selectedTags: Set<String> = []
    @State private var note: String = ""
    
    private let tags = ["Work", "Family", "Health", "Finance", "Social"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(greeting())
                            .font(.subheadline)
                            .foregroundColor(Color.Theme.textSecondary)
                        
                        Text("How are you feeling today?")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.Theme.textPrimary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Check-in Card
                    if let checkIn = todayCheckIn {
                        CheckInCompleteCard(checkIn: checkIn) {
                            todayCheckIn = nil
                        }
                    } else {
                        CheckInCard(stressLevel: $stressLevel, selectedTags: $selectedTags, note: $note) {
                            saveCheckIn()
                        }
                    }
                    
                    // Quick Stats
                    VStack(alignment: .leading, spacing: 12) {
                        Text("This Week")
                            .font(.headline)
                            .foregroundColor(Color.Theme.textPrimary)
                        
                        HStack(spacing: 16) {
                            StatCard(title: "Avg Stress", value: "5.2", icon: "chart.bar.fill", color: Color.Theme.warning)
                            StatCard(title: "Check-ins", value: "5/7", icon: "checkmark.circle.fill", color: Color.Theme.success)
                            StatCard(title: "Streak", value: "3 days", icon: "flame.fill", color: Color.Theme.primary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Encouragement
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Today's Tip")
                            .font(.subheadline)
                            .foregroundColor(Color.Theme.textSecondary)
                        
                        Text("Take a 5-minute break every hour to stretch and breathe. Your mind will thank you! 🧘")
                            .font(.body)
                            .foregroundColor(Color.Theme.textPrimary)
                            .padding()
                            .background(Color.Theme.primary.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top)
            }
            .background(Color.Theme.background.ignoresSafeArea())
            .navigationTitle("Zenly")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func greeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning 🌅"
        case 12..<17: return "Good afternoon ☀️"
        case 17..<21: return "Good evening 🌙"
        default: return "Good night 😴"
        }
    }
    
    private func saveCheckIn() {
        let checkIn = CheckIn(
            userId: "currentUser",
            stressLevel: Int(stressLevel),
            tags: Array(selectedTags),
            note: note.isEmpty ? nil : note
        )
        todayCheckIn = checkIn
        // Reset
        stressLevel = 5
        selectedTags = []
        note = ""
    }
}

struct CheckInCard: View {
    @Binding var stressLevel: Double
    @Binding var selectedTags: Set<String>
    @Binding var note: String
    let onSave: () -> Void
    
    private let tags = ["Work", "Family", "Health", "Finance", "Social"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("How stressed do you feel?")
                .font(.headline)
                .foregroundColor(Color.Theme.textPrimary)
            
            // Stress Slider
            VStack(spacing: 8) {
                Text("\(Int(stressLevel))/10")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(stressColor)
                
                Slider(value: $stressLevel, in: 1...10, step: 1)
                    .tint(stressColor)
                
                HStack {
                    Text("Calm")
                        .font(.caption)
                        .foregroundColor(Color.Theme.textSecondary)
                    Spacer()
                    Text("Stressed")
                        .font(.caption)
                        .foregroundColor(Color.Theme.textSecondary)
                }
            }
            
            // Tags
            VStack(alignment: .leading, spacing: 8) {
                Text("What's causing it?")
                    .font(.subheadline)
                    .foregroundColor(Color.Theme.textSecondary)
                
                FlowLayout(spacing: 8) {
                    ForEach(tags, id: \.self) { tag in
                        TagButton(title: tag, isSelected: selectedTags.contains(tag)) {
                            if selectedTags.contains(tag) {
                                selectedTags.remove(tag)
                            } else {
                                selectedTags.insert(tag)
                            }
                        }
                    }
                }
            }
            
            // Note
            VStack(alignment: .leading, spacing: 8) {
                Text("Add a note (optional)")
                    .font(.subheadline)
                    .foregroundColor(Color.Theme.textSecondary)
                
                TextField("What's on your mind?", text: $note, axis: .vertical)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .lineLimit(3...6)
            }
            
            // Save Button
            Button(action: onSave) {
                Text("Save Check-in")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.Theme.gradient)
                    .cornerRadius(12)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        .padding(.horizontal)
    }
    
    private var stressColor: Color {
        if stressLevel <= 3 {
            return Color.Theme.success
        } else if stressLevel <= 6 {
            return Color.Theme.warning
        } else {
            return Color.Theme.error
        }
    }
}

struct CheckInCompleteCard: View {
    let checkIn: CheckIn
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Color.Theme.success)
                
                Text("Today's check-in complete!")
                    .font(.headline)
                    .foregroundColor(Color.Theme.textPrimary)
                
                HStack(spacing: 8) {
                    Text("Stress: \(checkIn.stressLevel)/10")
                    if !checkIn.tags.isEmpty {
                        Text("•")
                        Text(checkIn.tags.joined(separator: ", "))
                    }
                }
                .font(.subheadline)
                .foregroundColor(Color.Theme.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(24)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        }
        .padding(.horizontal)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.Theme.textPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(Color.Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct TagButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(isSelected ? .white : Color.Theme.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.Theme.primary : Color(.systemGray6))
                .cornerRadius(20)
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth, x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

#Preview {
    HomeView()
}
