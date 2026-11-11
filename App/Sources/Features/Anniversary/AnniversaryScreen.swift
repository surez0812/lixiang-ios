import SwiftUI
import LixiangCalendarCore

/// F6 倒计日（内部类型 Anniversary）
struct CountdownScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    @StateObject private var store = AnniversaryStore(seed: DebugOptions.parse().seedCountdown)
    @State private var showForm = false
    @State private var editing: Anniversary?
    @State private var pendingDelete: Anniversary?

    private var rows: [(Anniversary, AnniversaryOccurrence)] {
        store.items.compactMap { item in
            guard let occ = AnniversaryResolver.occurrence(for: item, now: state.today, engine: state.engine) else { return nil }
            return (item, occ)
        }.sorted { $0.1.date < $1.1.date }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                header
                if let next = rows.first {
                    nextCard(next.0, next.1)
                }
                if store.notificationDenied {
                    HStack(spacing: 6) {
                        Image(systemName: "bell.slash").d1Font(10)
                        Text("通知已关闭，可在系统设置开启；倒计日已保存").d1Font(10)
                        Spacer()
                        Text("去开启").d1Font(10, weight: .semibold)
                    }
                    .foregroundStyle(theme.jiText)
                    .padding(10).background(theme.jiBg, in: RoundedRectangle(cornerRadius: 12))
                }
                if rows.isEmpty { emptyState } else { list }
                Text("还有 X 天 / 每年重复 / 已过 X 天；2/29 平年按 2/28 提醒（可改 3/1）。数据只在本机，无账号。")
                    .d1Font(9).foregroundStyle(theme.ink3)
            }
            .padding(.horizontal, 16).padding(.top, 8).padding(.bottom, 24)
        }
        .background(ScreenBackground())
        .navigationTitle("倒计日")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 12) {
                    if let url = store.exportURL() {
                        ShareLink(item: url) { Image(systemName: "square.and.arrow.up") }
                    }
                    Button { editing = nil; showForm = true } label: { Image(systemName: "plus") }
                }
            }
        }
        .sheet(isPresented: $showForm) {
            CountdownForm(item: editing) { item in
                if editing == nil { store.add(item) } else { store.update(item) }
                Task {
                    let granted = await NotificationScheduler.requestAuthorization()
                    store.markNotificationDenied(!granted)
                    await NotificationScheduler.reschedule(items: store.items, engine: state.engine, now: state.today)
                }
            }
        }
        .confirmationDialog("删除这个倒计日？", isPresented: Binding(get: { pendingDelete != nil }, set: { if !$0 { pendingDelete = nil } })) {
            Button("删除", role: .destructive) { if let p = pendingDelete { store.delete(p) } }
            Button("取消", role: .cancel) {}
        } message: { Text("删除后不可恢复；可先导出 JSON 备份。") }
        .task { await NotificationScheduler.reschedule(items: store.items, engine: state.engine, now: state.today) }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("倒计日").d1SerifFont(30).foregroundStyle(theme.ink)
            Text("记一个日子 · 按北京时间").d1Font(10).foregroundStyle(theme.ink3)
        }
    }

    private func nextCard(_ item: Anniversary, _ occ: AnniversaryOccurrence) -> some View {
        D1Card {
            VStack(alignment: .leading, spacing: 6) {
                SectionLabel(text: "下一个")
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title).d1SerifFont(22).foregroundStyle(theme.ink)
                        Text("\(occ.date.year)年\(occ.date.month)月\(occ.date.day)日 · \(calendarLabel(item))")
                            .d1Font(10).foregroundStyle(theme.ink3)
                    }
                    Spacer()
                    Text(occ.isToday ? "就是今天" : (occ.daysFromNow > 0 ? "还有 \(occ.daysFromNow) 天" : "已过 \(abs(occ.daysFromNow)) 天"))
                        .d1Font(16, weight: .semibold).foregroundStyle(occ.daysFromNow < 0 ? theme.ink2 : theme.accentStrong)
                }
                if occ.isToday { D1Chip(text: "就是今天", tone: .accent) }
            }
        }
    }

    private var list: some View {
        VStack(spacing: 8) {
            ForEach(rows, id: \.0.id) { item, occ in
                D1Card(padding: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(item.title).d1Font(14, weight: .semibold).foregroundStyle(theme.ink)
                            Text(calendarLabel(item)).d1Font(9).foregroundStyle(theme.ink3)
                            Spacer()
                            Button { editing = item; showForm = true } label: { Image(systemName: "pencil").d1Font(11) }
                                .foregroundStyle(theme.ink3)
                            Button { pendingDelete = item } label: { Image(systemName: "trash").d1Font(11) }
                                .foregroundStyle(theme.ink3)
                        }
                        Text("\(occ.date.iso) · \(occ.isToday ? "就是今天" : (occ.daysFromNow > 0 ? "还有 \(occ.daysFromNow) 天" : "已过 \(abs(occ.daysFromNow)) 天"))")
                            .d1Font(10).foregroundStyle(theme.ink2)
                        HStack(spacing: 6) {
                            if item.repeatRule == .yearly { D1Chip(text: "每年", tone: .neutral) } else { D1Chip(text: "一次性", tone: .neutral) }
                            if item.reminderEnabled { D1Chip(text: "提醒 \(String(format: "%02d:%02d", item.reminderHour, item.reminderMinute))", tone: .neutral) }
                            else { D1Chip(text: "提醒未开启", tone: .ji) }
                            if item.calendar == .lunar && item.isLeapMonth { D1Chip(text: "闰月", tone: .neutral) }
                        }
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        D1Card {
            VStack(alignment: .leading, spacing: 8) {
                Text("还没有倒计日").d1SerifFont(20).foregroundStyle(theme.ink)
                Text("记一个日子，之后会在这一天提醒你。支持公历/农历、每年重复、2/29 规则。").d1Font(11).foregroundStyle(theme.ink2)
                Button("记一个日子") { editing = nil; showForm = true }
                    .d1Font(12, weight: .semibold)
                    .frame(minHeight: 44).padding(.horizontal, 14)
                    .background(theme.accent, in: Capsule()).foregroundStyle(theme.onAccent)
            }
        }
    }

    private func calendarLabel(_ item: Anniversary) -> String {
        if item.calendar == .gregorian { return "公历" }
        return item.isLeapMonth ? "农历 · 闰\(item.month)月" : "农历 · \(item.month)月"
    }
}

/// 新增/编辑表单（P2 切片：标题/历法/日期/闰月/重复/提醒/备注；小月无三十行内提示）
struct CountdownForm: View {
    @Environment(\.d1) private var theme
    var item: Anniversary?
    var onSave: (Anniversary) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var calendar: AnniversaryCalendar = .gregorian
    @State private var month = 1
    @State private var day = 1
    @State private var isLeapMonth = false
    @State private var repeatRule: AnniversaryRepeat = .yearly
    @State private var feb29Policy: Feb29Policy = .feb28
    @State private var reminderEnabled = false
    @State private var reminderHour = 9
    @State private var note = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("名称") { TextField("例如：生日、结婚纪念日", text: $title) }
                Section("历法") {
                    Picker("历法", selection: $calendar) {
                        Text("公历").tag(AnniversaryCalendar.gregorian)
                        Text("农历").tag(AnniversaryCalendar.lunar)
                    }.pickerStyle(.segmented)
                    if calendar == .lunar {
                        Toggle("闰月", isOn: $isLeapMonth)
                        Text("闰月仅在农历闰年出现；非闰年不提醒。").font(.caption2).foregroundStyle(.secondary)
                    }
                    if calendar == .gregorian, month == 2, day == 29 {
                        Picker("平年提醒", selection: $feb29Policy) {
                            Text("2/28").tag(Feb29Policy.feb28)
                            Text("3/1").tag(Feb29Policy.mar01)
                            Text("跳过").tag(Feb29Policy.skip)
                        }
                        Text("仅影响提醒日；闰年仍为 2/29。").font(.caption2).foregroundStyle(.secondary)
                    }
                    Picker("月", selection: $month) { ForEach(1...12, id: \.self) { Text("\($0)月").tag($0) } }
                    Picker("日", selection: $day) { ForEach(1...31, id: \.self) { Text("\($0)日").tag($0) } }
                }
                Section("重复") {
                    Picker("重复", selection: $repeatRule) {
                        Text("每年重复").tag(AnniversaryRepeat.yearly)
                        Text("一次性").tag(AnniversaryRepeat.once)
                    }
                }
                Section("提醒") {
                    Toggle("本地通知", isOn: $reminderEnabled)
                    if reminderEnabled {
                        Stepper("时间 \(String(format: "%02d:00", reminderHour))", value: $reminderHour, in: 0...23)
                        Text("首次保存时才请求通知权限；拒绝后仍会保存。").font(.caption2).foregroundStyle(.secondary)
                    }
                }
                Section("备注") { TextField("可选", text: $note) }
            }
            .navigationTitle(item == nil ? "新增倒计日" : "编辑倒计日")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("取消") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { save() }.disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear(perform: load)
        }
    }

    private func load() {
        guard let item else { return }
        title = item.title; calendar = item.calendar; month = item.month; day = item.day
        isLeapMonth = item.isLeapMonth; repeatRule = item.repeatRule; feb29Policy = item.feb29Policy
        reminderEnabled = item.reminderEnabled; reminderHour = item.reminderHour; note = item.note
    }

    private func save() {
        onSave(Anniversary(id: item?.id ?? UUID(), title: title, calendar: calendar,
                           month: month, day: day, isLeapMonth: calendar == .lunar && isLeapMonth,
                           repeatRule: repeatRule, feb29Policy: feb29Policy,
                           reminderEnabled: reminderEnabled, reminderHour: reminderHour,
                           reminderMinute: 0, note: note))
        dismiss()
    }
}
