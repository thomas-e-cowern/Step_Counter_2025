import SwiftUI
import Charts

struct StepCounterView: View {
    @State private var stepCounter = StepCounter()
    @State private var selectedDay: StepData? = nil
    @State private var chartFrame: CGRect = .zero

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // --- Live Steps Ring ---
                Text("Today's Steps")
                    .font(.title)
                    .fontWeight(.semibold)

                ZStack {
                    Circle()
                        .stroke(Color.blue.opacity(0.3), lineWidth: 20)
                        .frame(width: 200, height: 200)

                    Circle()
                        .trim(from: 0, to: min(CGFloat(stepCounter.steps) / 10000, 1.0))
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 200, height: 200)
                        .animation(.easeOut, value: stepCounter.steps)

                    VStack {
                        Text("\(stepCounter.steps)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("of 10,000")
                            .foregroundColor(.secondary)
                    }
                }

                // --- Weekly Chart with Interactivity ---
                VStack(alignment: .leading, spacing: 10) {
                    Text("Weekly Steps")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Chart {
                        ForEach(stepCounter.weeklySteps) { item in
                            BarMark(
                                x: .value("Date", item.date, unit: .day),
                                y: .value("Steps", item.steps)
                            )
                            .foregroundStyle(Color.green.gradient)
                            .cornerRadius(5)
                            .annotation(position: .overlay, alignment: .center) {
                                if selectedDay?.id == item.id {
                                    VStack(spacing: 4) {
                                        Text("\(item.steps) steps")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .padding(6)
                                            .background(Color.black.opacity(0.75))
                                            .foregroundColor(.white)
                                            .cornerRadius(6)
                                        Triangle()
                                            .fill(Color.black.opacity(0.75))
                                            .frame(width: 10, height: 6)
                                    }
                                    .offset(y: -40)
                                }
                            }
                            .onTapGesture {
                                withAnimation {
                                    if selectedDay?.id == item.id {
                                        selectedDay = nil
                                    } else {
                                        selectedDay = item
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 200)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .onAppear {
            stepCounter.start()
        }
        .onDisappear {
            stepCounter.stop()
        }
    }
}

// --- Little triangle pointer for the popup ---
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
