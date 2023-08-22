//
//  ChartMarker.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 22.08.2023.
//

import UIKit
import DGCharts

class ChartMarker: MarkerView {
    private var text = String()
        
        private let bubbleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.darkGray,
            .backgroundColor: UIColor.clear
        ]
        
        override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
            text = entry.data as? String ?? ""
        }
        
        override func draw(context: CGContext, point: CGPoint) {
            super.draw(context: context, point: point)
            
            let sizeForDrawing = text.size(withAttributes: bubbleAttributes)
            bounds.size = CGSize(width: sizeForDrawing.width + 20, height: sizeForDrawing.height + 10)
            offset = CGPoint(x: 0, y: 0)
            
            let offset = offsetForDrawing(atPoint: point)
            let originPoint = CGPoint(x: point.x + offset.x, y: point.y + offset.y)
            let rectForBubble = CGRect(origin: originPoint, size: bounds.size)
            drawBubble(rect: rectForBubble)
            
            // Calculate the centered rect for the text
            let textRect = CGRect(
                x: rectForBubble.origin.x + (rectForBubble.size.width - sizeForDrawing.width) / 2,
                y: rectForBubble.origin.y + (rectForBubble.size.height - sizeForDrawing.height) / 2,
                width: sizeForDrawing.width,
                height: sizeForDrawing.height
            )
            drawText(text: text, rect: textRect, withAttributes: bubbleAttributes)
        }
        
        private func drawBubble(rect: CGRect) {
            let bubblePath = UIBezierPath(roundedRect: rect, cornerRadius: 10)
            (bubbleAttributes[.backgroundColor] as AnyObject).setFill()
            bubblePath.fill()
            
            UIColor.darkGray.setStroke()
            bubblePath.lineWidth = 1
            bubblePath.stroke()
        }
        
        private func drawText(text: String, rect: CGRect, withAttributes attributes: [NSAttributedString.Key: Any]? = nil) {
            text.draw(in: rect, withAttributes: attributes)
        }
    }
