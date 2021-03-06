//
//  LineGraph.swift
//  Crypto
//
//  Created by Эрхаан Говоров on 29.04.2022.
//

import SwiftUI

// Custom View

struct LineGraph: View {
    // Number of plots
    var data: [Double]
    
    @State var currentPlot = ""
    
    //Offset
    @State var offset: CGSize = .zero
    
    @State var showPlot = false
    
    @State var translation: CGFloat = 0
    
    @GestureState var isDrag: Bool = false
    
    // animating graph
    @State var graphProgress: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { proxy in
            
            let height = proxy.size.height
            let width = (proxy.size.width) / CGFloat(data.count - 1)
            
            let maxPoint = (data.max() ?? 0)
            let minPoint = data.min() ?? 0
            
            let points = data.enumerated().compactMap {
                item -> CGPoint in
                    
            // getting progress and multiplying with height
            let progress = (item.element - minPoint) / (maxPoint - minPoint)
                
                
            // Высота графика
            let pathHeight = progress * (height)
                    
                
            // width
            let pathWidth = width * CGFloat(item.offset)
                    
            // Since we need peak to top not bottom
            return CGPoint(x: pathWidth, y: -pathHeight + height)
            }
            
            ZStack {
                
               AnimatedGraphPath(progress: graphProgress, points: points)
                .fill(
                // Gradient
                    LinearGradient(colors: [.purple, .red], startPoint: .leading, endPoint: .trailing)
                )
                
                // Path Background Color
                // Градиент под графиком
               LinearGradient(colors: [Color.red.opacity(0.1),
                                        Color.purple.opacity(0.1),
                                       Color.indigo.opacity(0.2)], startPoint: .top, endPoint: .bottom)
               
                // Clipping the shape
                .clipShape(
                    Path { path in
                        
                        path.move(to: CGPoint(x: 0, y: 0))
                        
                        path.addLines(points)
                        
                        path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                        
                        path.addLine(to: CGPoint(x: 0, y: height))
                    }
                )
                .opacity(graphProgress)
            }
            .overlay(
            
            // Drag Indiccator
                VStack(spacing: 0) {
                    
                    Text(currentPlot)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color.red, in: Capsule())
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                    
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 1, height: 40)
                        .padding(.top)
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 22, height: 22)
                        .overlay(
                        
                        Circle()
                            .fill(.white)
                            .frame(width: 10, height: 10)
                            
                        )
                    
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 1, height: 55)
                }
                // Fixed frame
                //For Gesture Calculation
                    .frame(width: 80, height: 170)
                    .offset(y: 70)
                    .offset(x: -40)
                    .offset(offset)
                    .opacity(showPlot ? 1 : 0),
                
                alignment: .bottomLeading
            )
            
            .contentShape(Rectangle())
            .gesture(DragGesture().onChanged({ value in
                
                withAnimation { showPlot = true }
                
                // положение бегунка на графике
                let translation = value.location.x
                
                // Getting index...
                let index = max(min(Int((translation / width).rounded() - 1), data.count - 1), 0)
                
                currentPlot = "$ \(data[index])"
                self.translation = translation
                
                // removing half width..
                offset = CGSize(width: points[index].x, height: points[index].y - height)
                
            }).onEnded({ value in
                
                withAnimation { showPlot = false }
                
            }))
        }
        .background(
        
            VStack(alignment: .leading) {
                
                let max = data.max() ?? 0
                let min = data.min() ?? 0
                
                Text(max.convertToCurrency())
                    .font(.caption.bold())
                    .offset(y: -5)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5, content: {
                    Text(min.convertToCurrency())
                        .font(.caption.bold())
                    
                    Text("Last 7 Days")
                        .font(.caption)
                        .foregroundColor(.gray)
                        
                })
                .offset(y: 25)

            }
                .frame(maxWidth: .infinity, alignment: .leading)
        )
        .padding(.horizontal, 10)
        .onChange(of: isDrag) { newValue in
            if !isDrag { showPlot = false }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 1.2)) {
                    graphProgress = 1
                }
            }
        }
        .onChange(of: data) { newValue in
            // MARK Анимация графика каждый раз когда данные обновляются
            graphProgress = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 1.2)) {
                    graphProgress = 1
                }
            }
        }
    }
                        
}

// MARK: Animated Path
struct AnimatedGraphPath: Shape {
    var progress: CGFloat
    var points: [CGPoint]
    var animatableData: CGFloat {
        get { return progress }
        set { progress = newValue }
    }
    func path(in rect: CGRect) -> Path {
        Path { path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            
            path.addLines(points)
        }
        .trimmedPath(from: 0, to: progress)
        .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
    }
}
