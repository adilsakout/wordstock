//
//  HomeWidget.swift
//  HomeWidget
//
//  Created by adil sakout on 7/12/2025.
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WordEntry {
        WordEntry(
            date: Date(),
            word: "Ephemeral",
            definition: "Lasting for a very short time",
            phonetic: "/ɪˈfɛm(ə)rəl/",
            example: "The beauty of the sunset was ephemeral, lasting only minutes.",
            isFavorite: false
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (WordEntry) -> ()) {
        let entry = getWordEntry()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WordEntry>) -> ()) {
        let entry = getWordEntry()
        
        // Update every hour
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
    
    private func getWordEntry() -> WordEntry {
        let sharedDefaults = UserDefaults(suiteName: "group.app.clickwiseapps.wordstock.shared")
        
        let word = sharedDefaults?.string(forKey: "word") ?? "Welcome"
        let definition = sharedDefaults?.string(forKey: "definition") ?? "Learn a new word every day"
        let phonetic = sharedDefaults?.string(forKey: "phonetic") ?? ""
        let example = sharedDefaults?.string(forKey: "example") ?? ""
        
        let isFavoriteString = sharedDefaults?.string(forKey: "isFavorite") ?? "false"
        let isFavorite = isFavoriteString == "true"
        
        return WordEntry(
            date: Date(),
            word: word,
            definition: definition,
            phonetic: phonetic,
            example: example,
            isFavorite: isFavorite
        )
    }
}

// MARK: - Word Entry
struct WordEntry: TimelineEntry {
    let date: Date
    let word: String
    let definition: String
    let phonetic: String
    let example: String
    let isFavorite: Bool
}

// MARK: - Reusable Gradient Background
struct WidgetBackground: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            // Glass effect for future iOS versions
            Rectangle().fill(.regularMaterial)
        } else {
            // Green background for current versions
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.30, green: 0.82, blue: 0.48), // Fresh Green
                    Color(red: 0.15, green: 0.65, blue: 0.35)  // Deep Green
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

// MARK: - Widget View
struct HomeWidgetEntryView: View {
    var entry: WordEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                SmallWordWidget(entry: entry)
            case .systemMedium:
                MediumWordWidget(entry: entry)
            case .systemLarge:
                LargeWordWidget(entry: entry)
            default:
                MediumWordWidget(entry: entry)
            }
        }
        .widgetURL(URL(string: "wordstock://home"))
    }
}

// MARK: - Small Widget (Dictionary Style - Left Aligned)
struct SmallWordWidget: View {
    let entry: WordEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Compact Header
            HStack {
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 10))
                Spacer()
                if entry.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.5)) // Bright Pink
                        .font(.system(size: 10))
                }
            }
            .foregroundColor(.white.opacity(0.8))
            .padding(.bottom, 8)
            
            // Word Area
            Text(entry.word)
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            
            if !entry.phonetic.isEmpty {
                Text(entry.phonetic)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
                    .padding(.bottom, 6)
            } else {
                Spacer().frame(height: 6)
            }
            
            // Definition
            Text(entry.definition)
                .font(.system(size: 12, weight: .regular, design: .rounded))
                .foregroundColor(.white.opacity(0.95))
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(14)
    }
}

// MARK: - Medium Widget (Hero Style - Center Aligned)
struct MediumWordWidget: View {
    let entry: WordEntry
    
    var body: some View {
        VStack(spacing: 6) {
            // Header
            HStack {
                Label("Word of the Day", systemImage: "book.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                if entry.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.5))
                        .font(.system(size: 12))
                }
            }
            
            Spacer()
            
            // Word & Phonetic
            VStack(spacing: 4) {
                Text(entry.word)
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                if !entry.phonetic.isEmpty {
                    Text(entry.phonetic)
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .foregroundColor(.white.opacity(0.85))
                }
            }
            
            Spacer()
            
            // Definition
            Text(entry.definition)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 4)
            
            Spacer()
        }
        .padding(16)
    }
}

// MARK: - Large Widget (Detailed Style - Center Aligned)
struct LargeWordWidget: View {
    let entry: WordEntry
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Label("Word of the Day", systemImage: "book.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                if entry.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.5))
                        .font(.system(size: 14))
                }
            }
            .padding(.bottom, 20)
            
            // Main Content
            VStack(spacing: 8) {
                Text(entry.word)
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                if !entry.phonetic.isEmpty {
                    Text(entry.phonetic)
                        .font(.system(size: 16, weight: .medium, design: .monospaced))
                        .foregroundColor(.white.opacity(0.85))
                }
            }
            
            Spacer()
            
            // Definition
            Text(entry.definition)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 10)
            
            Spacer()
            
            // Example Section
            if !entry.example.isEmpty {
                VStack(spacing: 6) {
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 1)
                        .frame(width: 60)
                    
                    Text("\"\(entry.example)\"")
                        .font(.system(size: 15, weight: .regular, design: .serif))
                        .italic()
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.bottom, 10)
            }
            
            // Footer
            Text("Tap to open Wordstock")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(20)
    }
}

// MARK: - Widget Configuration
struct HomeWidget: Widget {
    let kind: String = "HomeWidget"

    var body: some WidgetConfiguration {
        makeConfiguration()
    }
    
    private func makeConfiguration() -> some WidgetConfiguration {
        if #available(iOS 17.0, *) {
            return StaticConfiguration(kind: kind, provider: Provider()) { entry in
                HomeWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget) {
                        WidgetBackground()
                    }
            }
            .configurationDisplayName("Word of the Day")
            .description("Learn a new word every day with Wordstock")
            .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
            .contentMarginsDisabled()
        } else {
            return StaticConfiguration(kind: kind, provider: Provider()) { entry in
                HomeWidgetEntryView(entry: entry)
                    .background(WidgetBackground())
            }
            .configurationDisplayName("Word of the Day")
            .description("Learn a new word every day with Wordstock")
            .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        }
    }
}

// MARK: - Preview
#Preview(as: .systemSmall) {
    HomeWidget()
} timeline: {
    WordEntry(
        date: .now,
        word: "Serendipity",
        definition: "The occurrence of events by chance in a happy or beneficial way",
        phonetic: "/ˌserənˈdɪpɪti/",
        example: "It was pure serendipity that we met at the coffee shop.",
        isFavorite: true
    )
}
