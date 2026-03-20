import SwiftUI
import Charts

struct TrendsView: View {
    @State private var selectedPeriod: Period = .week
    @State private var checkIns: [CheckIn] = CheckIn.samples
    
    var averageStress: Double {
        guard !checkIns.isEmpty else { return 0 }
        return Double(checkIns.map { $0.stressLevel }.reduce(0, +)) / Double(checkIns.count)
    }
    
    var checkInRate: Double {
        let target = selectedPeriod == .week ? 7 : 30
        return min(Double(checkIns.count) / Double(target), 1.0)
    }
    
    enum Period: String, CaseIterable {
        case week = "Week"
        case month = "Month"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Period Selector
                    Picker("Period", selection: $selectedPeriod) {
                        ForEach(Period.allCases, id: \.self) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Stats Cards
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Avg Stress",
                            value: String(format: "%.1f", averageStress),
                            subtitle: "out of 10",
                            color: averageStressColor
                        )
                        
                        StatCard(
                            title: "Check-ins",
                            value: "\(checkIns.count)",
                            subtitle: selectedPeriod == .week ? "this week" : "this month",
                            color: Color.Theme.primary
                        )
                    }
                    .padding(.horizontal)
                    
                    // Chart
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Stress Trend")
                            .font(.headline)
                            .foregroundColor(Color.Theme.textPrimary)
                        
                        Chart(checkIns.suffix(selectedPeriod == .week ? 7 : 30)) { checkIn in
                            LineMark(
                                x: .value("Date", checkIn.date, unit: .day),
                                y: .value("Stress", checkIn.stressLevel)
                            )
                            .foregroundStyle(Color.Theme.primary)
                            .interpolationMethod(.catmullRom)
                            
                            PointMark(
                                x: .value("Date", checkIn.date, unit: .day),
                                y: .value("Stress", checkIn.stressLevel)
                            )
                            .foregroundStyle(Color.Theme.primary)
                        }
                        .frame(height: 200)
                        .chartYScale(domain: 1...10)
                        .chartXAxis {
                            AxisMarks(values: .automatic) { _ in
                                AxisValueLabel()
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    
                    // Insights
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Insights")
                            .font(.headline)
                            .foregroundColor(Color.Theme.textPrimary)
                        
                        InsightCard(
                            icon: "trending.up",
                            title: "Stress Increasing",
                            description: "Your stress levels have been going up this \(selectedPeriod.rawValue.lowercased()). Consider taking more breaks."
                        )
                        
                        InsightCard(
                            icon: "clock.fill",
                            title: "Best Day",
                            description: "You felt calmest on Wednesday. What was different about that day?"
                        )
                    }
                    .padding(.horizontal)
                    
                    // Tags Breakdown
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Top Stressors")
                            .font(.headline)
                            .foregroundColor(Color.Theme.textPrimary)
                        
                        HStack(spacing: 12) {
                            TagStatView(tag: "Work", count: 5, color: Color.Theme.warning)
                            TagStatView(tag: "Finance", count: 3, color: Color.Theme.error)
                            TagStatView(tag: "Health", count: 2, color: Color.Theme.success)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .background(Color.Theme.background.ignoresSafeArea())
            .navigationTitle("Trends")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var averageStressColor: Color {
        if averageStress <= 3 {
            return Color.Theme.success
        } else if averageStress <= 6 {
            return Color.Theme.warning
        } else {
            return Color.Theme.error
        }
    }
}

struct InsightCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color.Theme.primary)
                .padding(10)
                .background(Color.Theme.primary.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.Theme.textPrimary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(Color.Theme.textSecondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct TagStatView: View {
    let tag: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(tag)
                .font(.caption)
                .foregroundColor(Color.Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// Sample data for preview
extension CheckIn {
    static let samples: [CheckIn] = [
        CheckIn(userId: "1", date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, stressLevel: 4, tags: ["Work"]),
        CheckIn(userId: "1", date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, stressLevel: 5, tags: ["Work", "Finance"]),
        CheckIn(userId: "1", date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, stressLevel: 3, tags: ["Health"]),
        CheckIn(userId: "1", date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, stressLevel: 6, tags: ["Work"]),
        CheckIn(userId: "1", date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, stressLevel: 4, tags: ["Family"]),
        CheckIn(userId: "1", date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, stressLevel: 7, tags: ["Work", "Finance"])
    ]
}

#Preview {
    TrendsView()
}
