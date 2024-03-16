//
//  ContentView.swift
//  SlenderRow
//
//  Created by Романенко Иван on 15.03.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isHorizontalLayout = true
    
    var layout: AnyLayout {
        isHorizontalLayout ? AnyLayout(HorizontalLayout()) : AnyLayout(DiagonalLayout())
    }
    
    var body: some View {
        layout {
            ForEach(0..<7) { _ in
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.blue)
                    .onTapGesture {
                        withAnimation {
                            isHorizontalLayout.toggle()
                        }
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}

struct DiagonalLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let width = proposal.replacingUnspecifiedDimensions().width
        let height = proposal.replacingUnspecifiedDimensions().height
        let viewsCount = CGFloat(subviews.count)
        let viewHeight = height / viewsCount
        let viewSize = CGSize(width: viewHeight, height: viewHeight)
        var currentY = bounds.maxY
        var currentX = bounds.minX
        
        subviews.forEach { subview in
            let position = CGPoint(x: currentX, y: currentY)
            subview.place(at: position, anchor: .bottomLeading, proposal: ProposedViewSize(viewSize))
            currentY -= viewHeight
            currentX += (width - viewHeight) / (viewsCount - 1)
        }
    }
}

struct HorizontalLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let width = proposal.replacingUnspecifiedDimensions().width
        let viewsCount = CGFloat(subviews.count)
        let spacingTotal = 8.0 * (viewsCount - 1)
        let viewWidth = (width - spacingTotal) / viewsCount
        let viewSize = CGSize(width: viewWidth, height: viewWidth)
        var currentX = bounds.minX + viewWidth / 2
        
        subviews.forEach { subview in
            let position = CGPoint(x: currentX, y: bounds.midY)
            subview.place(at: position, anchor: .center,proposal: ProposedViewSize(viewSize))
            currentX += viewWidth + spacingTotal / (viewsCount - 1)
        }
    }
}
