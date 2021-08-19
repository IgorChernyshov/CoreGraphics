//
//  ViewController.swift
//  CoreGraphics
//
//  Created by Igor Chernyshov on 18.08.2021.
//

import UIKit

final class ViewController: UIViewController {

	// MARK: - Outlets
	@IBOutlet var imageView: UIImageView!

	// MARK: - Properties
	private var currentDrawType = 6

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		redrawDidTap(self)
	}

	// MARK: - Actions
	@IBAction func redrawDidTap(_ sender: Any) {
		currentDrawType += 1

		if currentDrawType > 7 { currentDrawType = 0 }

		switch currentDrawType {
		case 0: drawRectangle()
		case 1: drawCircle()
		case 2: drawCheckerboard()
		case 3: drawRotatedSquares()
		case 4: drawLines()
		case 5: drawImagesAndText()
		case 6: drawSurprisedEmoji()
		case 7: drawTwinText()
		default: break
		}
	}

	// MARK: - Drawing
	private func drawRectangle() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let image = renderer.image { context in
			let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)

			context.cgContext.setFillColor(UIColor.red.cgColor)
			context.cgContext.setStrokeColor(UIColor.black.cgColor)
			context.cgContext.setLineWidth(10)

			context.cgContext.addRect(rectangle)
			context.cgContext.drawPath(using: .fillStroke)
		}

		imageView.image = image
	}

	private func drawCircle() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let image = renderer.image { context in
			let circle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)

			context.cgContext.setFillColor(UIColor.red.cgColor)
			context.cgContext.setStrokeColor(UIColor.black.cgColor)
			context.cgContext.setLineWidth(10)

			context.cgContext.addEllipse(in: circle)
			context.cgContext.drawPath(using: .fillStroke)
		}

		imageView.image = image
	}

	private func drawCheckerboard() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let image = renderer.image { context in
			context.cgContext.setFillColor(UIColor.black.cgColor)

			for row in 0 ..< 8 {
				for column in 0 ..< 8 {
					if (row + column) % 2 == 0 {
						context.cgContext.fill(CGRect(x: column * 64, y: row * 64, width: 64, height: 64))
					}
				}
			}
		}

		imageView.image = image
	}

	private func drawRotatedSquares() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let image = renderer.image { context in
			context.cgContext.translateBy(x: 256, y: 256)

			let rotations = 16
			let amount = Double.pi / Double(rotations)

			for _ in 0 ..< rotations {
				context.cgContext.rotate(by: CGFloat(amount))
				context.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
			}

			context.cgContext.setStrokeColor(UIColor.black.cgColor)
			context.cgContext.strokePath()
		}

		imageView.image = image
	}

	private func drawLines() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let image = renderer.image { context in
			context.cgContext.translateBy(x: 256, y: 256)

			var first = true
			var length: CGFloat = 256

			for _ in 0 ..< 256 {
				context.cgContext.rotate(by: .pi / 2)

				if first {
					context.cgContext.move(to: CGPoint(x: length, y: 50))
					first = false
				} else {
					context.cgContext.addLine(to: CGPoint(x: length, y: 50))
				}

				length *= 0.99
			}

			context.cgContext.setStrokeColor(UIColor.black.cgColor)
			context.cgContext.strokePath()
		}

		imageView.image = image
	}

	private func drawImagesAndText() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let image = renderer.image { context in
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = .center

			let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 36),
															 .paragraphStyle: paragraphStyle]

			let string = "The best-laid schemes o'\nmice an' men gang aft agley"
			let attributedString = NSAttributedString(string: string, attributes: attributes)

			attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)

			let mouse = UIImage(named: "mouse")
			mouse?.draw(at: CGPoint(x: 300, y: 150))
		}

		imageView.image = image
	}

	private func drawSurprisedEmoji() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let image = renderer.image { context in
			// Draw head
			context.cgContext.setFillColor(UIColor.yellow.cgColor)
			context.cgContext.setStrokeColor(UIColor.black.cgColor)
			context.cgContext.setLineWidth(5)
			let face = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
			context.cgContext.addEllipse(in: face)
			context.cgContext.drawPath(using: .fillStroke)

			// Draw eyes
			context.cgContext.setFillColor(UIColor.brown.cgColor)
			context.cgContext.setStrokeColor(UIColor.brown.cgColor)
			context.cgContext.setLineWidth(1)
			let leftEye = CGRect(x: 150, y: 150, width: 25, height: 25)
			context.cgContext.addEllipse(in: leftEye)
			let rightEye = CGRect(x: 312, y: 150, width: 25, height: 25)
			context.cgContext.addEllipse(in: rightEye)

			// Draw mouth
			let mouth = CGRect(x: 218, y: 360, width: 75, height: 75)
			context.cgContext.addEllipse(in: mouth)
			context.cgContext.drawPath(using: .fillStroke)
		}

		imageView.image = image
	}

	private func drawTwinText() {
		let render = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let image = render.image { context in
			context.cgContext.setStrokeColor(UIColor.darkText.cgColor)

			// T
			context.cgContext.move(to: CGPoint(x: 10, y: 10))
			context.cgContext.addLine(to: CGPoint(x: 90, y: 10))
			context.cgContext.move(to: CGPoint(x: 50, y: 10))
			context.cgContext.addLine(to: CGPoint(x: 50, y: 200))

			// W
			context.cgContext.move(to: CGPoint(x: 110, y: 10))
			context.cgContext.addLine(to: CGPoint(x: 130, y: 200))
			context.cgContext.addLine(to: CGPoint(x: 150, y: 10))
			context.cgContext.addLine(to: CGPoint(x: 170, y: 200))
			context.cgContext.addLine(to: CGPoint(x: 190, y: 10))

			// I
			context.cgContext.move(to: CGPoint(x: 210, y: 10))
			context.cgContext.addLine(to: CGPoint(x: 230, y: 10))
			context.cgContext.move(to: CGPoint(x: 210, y: 200))
			context.cgContext.addLine(to: CGPoint(x: 230, y: 200))
			context.cgContext.move(to: CGPoint(x: 220, y: 10))
			context.cgContext.addLine(to: CGPoint(x: 220, y: 200))

			// N
			context.cgContext.move(to: CGPoint(x: 250, y: 200))
			context.cgContext.addLine(to: CGPoint(x: 250, y: 10))
			context.cgContext.addLine(to: CGPoint(x: 300, y: 200))
			context.cgContext.addLine(to: CGPoint(x: 300, y: 10))

			// Draw
			context.cgContext.strokePath()
		}

		imageView.image = image
	}
}
