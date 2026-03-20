import SwiftUI

struct ProfileView: View {
    @State private var notificationsEnabled: Bool = true
    @State private var darkModeEnabled: Bool = false
    @State private var showSubscriptionSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                // User Section
                Section {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.Theme.gradient)
                                .frame(width: 60, height: 60)
                            
                            Text("U")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome User")
                                .font(.headline)
                                .foregroundColor(Color.Theme.textPrimary)
                            
                            Text("Free Plan")
                                .font(.subheadline)
                                .foregroundColor(Color.Theme.textSecondary)
                        }
                        
                        Spacer()
                        
                        Button(action: { showSubscriptionSheet = true }) {
                            Text("Upgrade")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.Theme.primary)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Subscription Section
                Section("Subscription") {
                    SubscriptionRow(plan: "Free", price: "$0", features: ["3 AI chats/week", "5 Meditations"], isCurrent: true)
                    SubscriptionRow(plan: "Pro", price: "$4.99/mo", features: ["Unlimited AI", "Full Trends", "Offline"], isCurrent: false, action: { showSubscriptionSheet = true })
                    SubscriptionRow(plan: "Yearly", price: "$39.99/yr", features: ["Save 33%", "All Pro features"], isCurrent: false, action: { showSubscriptionSheet = true })
                }
                
                // Settings Section
                Section("Settings") {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Daily Reminders", systemImage: "bell.fill")
                    }
                    
                    Toggle(isOn: $darkModeEnabled) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                    
                    NavigationLink {
                        Text("Language Settings")
                    } label: {
                        Label("Language", systemImage: "globe")
                    }
                    
                    NavigationLink {
                        Text("Privacy Settings")
                    } label: {
                        Label("Privacy", systemImage: "lock.shield")
                    }
                }
                
                // Support Section
                Section("Support") {
                    NavigationLink {
                        Text("Help Center")
                    } label: {
                        Label("Help Center", systemImage: "questionmark.circle")
                    }
                    
                    NavigationLink {
                        Text("Send Feedback")
                    } label: {
                        Label("Send Feedback", systemImage: "envelope")
                    }
                    
                    NavigationLink {
                        Text("Rate Us")
                    } label: {
                        Label("Rate Zenly", systemImage: "star.fill")
                    }
                }
                
                // About Section
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(Color.Theme.textSecondary)
                    }
                    
                    NavigationLink {
                        Text("Terms of Service")
                    } label: {
                        Text("Terms of Service")
                    }
                    
                    NavigationLink {
                        Text("Privacy Policy")
                    } label: {
                        Text("Privacy Policy")
                    }
                }
                
                // Sign Out
                Section {
                    Button(action: signOut) {
                        HStack {
                            Spacer()
                            Text("Sign Out")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showSubscriptionSheet) {
                SubscriptionSheet()
            }
        }
    }
    
    private func signOut() {
        // Sign out logic
    }
}

struct SubscriptionRow: View {
    let plan: String
    let price: String
    let features: [String]
    let isCurrent: Bool
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: { action?() }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(plan)
                            .font(.headline)
                            .foregroundColor(Color.Theme.textPrimary)
                        
                        if isCurrent {
                            Text("Current")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.Theme.success)
                                .cornerRadius(10)
                        }
                    }
                    
                    Text(price)
                        .font(.subheadline)
                        .foregroundColor(Color.Theme.textSecondary)
                    
                    ForEach(features, id: \.self) { feature in
                        Text("• \(feature)")
                            .font(.caption)
                            .foregroundColor(Color.Theme.textSecondary)
                    }
                }
                
                Spacer()
                
                if !isCurrent {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.Theme.textSecondary)
                }
            }
        }
    }
}

struct SubscriptionSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(Color.Theme.gradient)
                        
                        Text("Upgrade to Pro")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Unlock all features and take your wellness journey to the next level")
                            .font(.body)
                            .foregroundColor(Color.Theme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Features
                    VStack(alignment: .leading, spacing: 16) {
                        FeatureRow(icon: "infinity", title: "Unlimited AI Chat", description: "Chat with Zenly anytime, as much as you want")
                        FeatureRow(icon: "chart.xyaxis.line", title: "Detailed Trends", description: "Get deeper insights into your stress patterns")
                        FeatureRow(icon: "iphone.and.arrow.forward", title: "Offline Mode", description: "Access your meditations anywhere")
                        FeatureRow(icon: "bell.badge.fill", title: "Smart Reminders", description: "Personalized notifications based on your patterns")
                    }
                    .padding()
                    
                    // Plans
                    VStack(spacing: 12) {
                        PlanCard(plan: "Monthly", price: "$4.99", period: "/month", isPopular: true) {
                            // Purchase
                        }
                        
                        PlanCard(plan: "Yearly", price: "$39.99", period: "/year", discount: "Save 33%") {
                            // Purchase
                        }
                    }
                    .padding()
                }
            }
            .background(Color.Theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color.Theme.primary)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color.Theme.textPrimary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(Color.Theme.textSecondary)
            }
        }
    }
}

struct PlanCard: View {
    let plan: String
    let price: String
    let period: String
    var discount: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(plan)
                            .font(.headline)
                            .foregroundColor(Color.Theme.textPrimary)
                        
                        if let discount = discount {
                            Text(discount)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.Theme.success)
                                .cornerRadius(10)
                        }
                    }
                    
                    Text("\(price)\(period)")
                        .font(.subheadline)
                        .foregroundColor(Color.Theme.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.Theme.primary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(discount != nil ? Color.Theme.primary : Color.clear, lineWidth: 2)
            )
        }
    }
}

#Preview {
    ProfileView()
}
