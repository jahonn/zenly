import SwiftUI

struct MeditationView: View {
    @State private var selectedCategory: MeditationCategory?
    @State private var isPlaying: Bool = false
    @State private var selectedMeditation: Meditation?
    @State private var progress: Double = 0
    
    var filteredMeditations: [Meditation] {
        if let category = selectedCategory {
            return Meditation.samples.filter { $0.category == category }
        }
        return Meditation.samples
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Featured Card
                    if let featured = Meditation.samples.first {
                        FeaturedMeditationCard(meditation: featured) {
                            selectedMeditation = featured
                            isPlaying = true
                        }
                    }
                    
                    // Categories
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Categories")
                            .font(.headline)
                            .foregroundColor(Color.Theme.textPrimary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                CategoryChip(title: "All", icon: "sparkles", isSelected: selectedCategory == nil) {
                                    selectedCategory = nil
                                }
                                
                                ForEach(MeditationCategory.allCases, id: \.self) { category in
                                    CategoryChip(title: category.rawValue, icon: category.icon, isSelected: selectedCategory == category) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Meditation List
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Sessions")
                            .font(.headline)
                            .foregroundColor(Color.Theme.textPrimary)
                            .padding(.horizontal)
                        
                        ForEach(filteredMeditations) { meditation in
                            MeditationCard(meditation: meditation) {
                                selectedMeditation = meditation
                                isPlaying = true
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .background(Color.Theme.background.ignoresSafeArea())
            .navigationTitle("Meditate")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isPlaying) {
                if let meditation = selectedMeditation {
                    PlayerView(meditation: meditation, isPlaying: $isPlaying, progress: $progress)
                }
            }
        }
    }
}

struct FeaturedMeditationCard: View {
    let meditation: Meditation
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: meditation.category.icon)
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(meditation.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(meditation.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(meditation.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                HStack {
                    Label("\(meditation.duration / 60) min", systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Image(systemName: "play.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.Theme.gradient)
            .cornerRadius(20)
        }
        .padding(.horizontal)
    }
}

struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.subheadline)
            }
            .foregroundColor(isSelected ? .white : Color.Theme.textPrimary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color.Theme.primary : Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

struct MeditationCard: View {
    let meditation: Meditation
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.Theme.primary.opacity(0.1))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: meditation.category.icon)
                        .font(.title3)
                        .foregroundColor(Color.Theme.primary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(meditation.title)
                        .font(.headline)
                        .foregroundColor(Color.Theme.textPrimary)
                    
                    Text(meditation.subtitle)
                        .font(.subheadline)
                        .foregroundColor(Color.Theme.textSecondary)
                }
                
                Spacer()
                
                Text("\(meditation.duration / 60):\(String(format: "%02d", meditation.duration % 60))")
                    .font(.subheadline)
                    .foregroundColor(Color.Theme.textSecondary)
                
                Image(systemName: "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color.Theme.primary)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
}

struct PlayerView: View {
    let meditation: Meditation
    @Binding var isPlaying: Bool
    @Binding var progress: Double
    @State private var timeRemaining: Int
    @State private var timer: Timer?
    
    init(meditation: Meditation, isPlaying: Binding<Bool>, progress: Binding<Double>) {
        self.meditation = meditation
        self._isPlaying = isPlaying
        self._progress = progress
        self._timeRemaining = State(initialValue: meditation.duration)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.Theme.background.ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Artwork
                    ZStack {
                        Circle()
                            .fill(Color.Theme.gradient)
                            .frame(width: 200, height: 200)
                        
                        Image(systemName: meditation.category.icon)
                            .font(.system(size: 64))
                            .foregroundColor(.white)
                    }
                    
                    // Title
                    VStack(spacing: 8) {
                        Text(meditation.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.Theme.textPrimary)
                        
                        Text(meditation.category.rawValue)
                            .font(.subheadline)
                            .foregroundColor(Color.Theme.textSecondary)
                    }
                    
                    // Progress
                    VStack(spacing: 8) {
                        ProgressView(value: progress)
                            .tint(Color.Theme.primary)
                        
                        HStack {
                            Text(formatTime(timeRemaining))
                            Spacer()
                            Text(formatTime(meditation.duration))
                        }
                        .font(.caption)
                        .foregroundColor(Color.Theme.textSecondary)
                    }
                    .padding(.horizontal, 40)
                    
                    // Controls
                    HStack(spacing: 40) {
                        Button(action: {
                            // Rewind 15s
                            timeRemaining = max(0, timeRemaining - 15)
                            progress = Double(meditation.duration - timeRemaining) / Double(meditation.duration)
                        }) {
                            Image(systemName: "gobackward.15")
                                .font(.title)
                                .foregroundColor(Color.Theme.textPrimary)
                        }
                        
                        Button(action: togglePlay) {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 72))
                                .foregroundColor(Color.Theme.primary)
                        }
                        
                        Button(action: {
                            // Forward 15s
                            timeRemaining = min(meditation.duration, timeRemaining + 15)
                            progress = Double(meditation.duration - timeRemaining) / Double(meditation.duration)
                        }) {
                            Image(systemName: "goforward.15")
                                .font(.title)
                                .foregroundColor(Color.Theme.textPrimary)
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        stopTimer()
                        isPlaying = false
                    }
                }
            }
        }
    }
    
    private func togglePlay() {
        if isPlaying {
            pauseTimer()
        } else {
            startTimer()
        }
        isPlaying.toggle()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                progress = Double(meditation.duration - timeRemaining) / Double(meditation.duration)
            } else {
                stopTimer()
                isPlaying = false
            }
        }
    }
    
    private func pauseTimer() {
        timer?.invalidate()
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timeRemaining = meditation.duration
        progress = 0
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", minutes, secs)
    }
}

#Preview {
    MeditationView()
}
