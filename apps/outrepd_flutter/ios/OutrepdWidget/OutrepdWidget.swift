// The home-screen widgets on iPhone: today's goal and the streak (small),
// and the rank beside them (medium).
//
// Nothing here is worked out: the app writes every word and number, in the
// reader's language, into the app group both targets share
// (lib/home_widgets.dart), and asks for a reload after each set. The one
// thing decided here is a new day: yesterday's count is not today's.

import SwiftUI
import WidgetKit

private let appGroup = "group.com.outrepd.outrepd"

private let page = Color(red: 0x12 / 255, green: 0x11 / 255, blue: 0x10 / 255)
private let ink = Color(red: 0xF5 / 255, green: 0xEF / 255, blue: 0xE4 / 255)
private let muted = Color(red: 0x8F / 255, green: 0x88 / 255, blue: 0x80 / 255)
private let brand = Color(red: 0xE8 / 255, green: 0xDC / 255, blue: 0xC8 / 255)
private let track = Color(red: 0x26 / 255, green: 0x23 / 255, blue: 0x20 / 255)
private let gold = Color(red: 0xD9 / 255, green: 0xA9 / 255, blue: 0x4A / 255)

struct GoalEntry: TimelineEntry {
    let date: Date
    let goalCount: String
    let goalShare: Double
    let goalOf: String
    let streak: String
    let rank: String
    let lp: String
    let lpShare: Double
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> GoalEntry {
        GoalEntry(
            date: Date(), goalCount: "32", goalShare: 0.64, goalOf: "of 50 today",
            streak: "5 day streak", rank: "Gold III", lp: "64 / 100 LP", lpShare: 0.64
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (GoalEntry) -> Void) {
        completion(context.isPreview ? placeholder(in: context) : read())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<GoalEntry>) -> Void) {
        // The app reloads it after every set. Past midnight the day's count
        // starts again, so it is read again then without waiting for the app.
        let tomorrow = Calendar.current.startOfDay(for: Date().addingTimeInterval(86_400))
        completion(Timeline(entries: [read()], policy: .after(tomorrow)))
    }

    private func read() -> GoalEntry {
        let saved = UserDefaults(suiteName: appGroup)
        func text(_ key: String, _ fallback: String = "") -> String {
            saved?.string(forKey: key) ?? fallback
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let today = text("goal_day") == formatter.string(from: Date())
        return GoalEntry(
            date: Date(),
            goalCount: today ? text("goal_count", "0") : "0",
            goalShare: today ? (Double(text("goal_percent", "0")) ?? 0) / 100 : 0,
            goalOf: today ? text("goal_of") : text("goal_of_fresh"),
            streak: text("streak"),
            rank: text("rank"),
            lp: text("lp"),
            lpShare: (Double(text("lp_percent", "0")) ?? 0) / 100
        )
    }
}

private struct Ring: View {
    let share: Double
    let count: String

    var body: some View {
        ZStack {
            Circle().stroke(track, lineWidth: 9)
            Circle()
                .trim(from: 0, to: max(0, min(1, share)))
                .stroke(brand, style: StrokeStyle(lineWidth: 9, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text(count)
                .font(.system(size: 22, weight: .bold))
                .monospacedDigit()
                .foregroundColor(ink)
        }
        .frame(width: 84, height: 84)
    }
}

private struct SmallView: View {
    let entry: GoalEntry

    var body: some View {
        VStack(spacing: 6) {
            Ring(share: entry.goalShare, count: entry.goalCount)
            Text(entry.goalOf).font(.system(size: 13)).foregroundColor(muted).lineLimit(1)
            if !entry.streak.isEmpty {
                Text(entry.streak).font(.system(size: 14, weight: .semibold)).foregroundColor(gold).lineLimit(1)
            }
        }
    }
}

private struct MediumView: View {
    let entry: GoalEntry

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("OUTREPD").font(.system(size: 12, weight: .semibold)).tracking(1.2).foregroundColor(muted)
                Text(entry.rank).font(.system(size: 22, weight: .bold)).foregroundColor(ink).lineLimit(1)
                if !entry.lp.isEmpty {
                    Text(entry.lp).font(.system(size: 13)).foregroundColor(muted).lineLimit(1)
                    GeometryReader { box in
                        ZStack(alignment: .leading) {
                            Capsule().fill(track)
                            Capsule().fill(brand).frame(width: box.size.width * max(0, min(1, entry.lpShare)))
                        }
                    }
                    .frame(height: 6)
                }
                if !entry.streak.isEmpty {
                    Text(entry.streak).font(.system(size: 13, weight: .semibold)).foregroundColor(gold).lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: 4) {
                Ring(share: entry.goalShare, count: entry.goalCount)
                Text(entry.goalOf).font(.system(size: 12)).foregroundColor(muted).lineLimit(1)
            }
        }
    }
}

struct OutrepdWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: GoalEntry

    var body: some View {
        switch family {
        case .systemMedium: MediumView(entry: entry)
        default: SmallView(entry: entry)
        }
    }
}

private extension View {
    /// The app's page colour behind the widget, the way each iOS version asks.
    @ViewBuilder
    func pageBackground() -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            containerBackground(page, for: .widget)
        } else {
            padding().background(page)
        }
    }
}

@main
struct OutrepdWidget: Widget {
    // The same name the app reloads it by (HomeWidgets._iOSName).
    let kind = "OutrepdWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            OutrepdWidgetView(entry: entry).pageBackground()
        }
        .configurationDisplayName("OUTREPD")
        .description("Today's goal, your streak and your rank.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
