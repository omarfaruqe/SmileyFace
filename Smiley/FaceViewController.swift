

import UIKit

class FaceViewController: UIViewController
{
	// MARK: model
	var expression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Frown ) {
		didSet {
			updateUI()	// model has changed, so update UI
		}
	}
	
	// MARK: view
	@IBOutlet private weak var faceView: FaceView! {
		didSet {
			faceView.addGestureRecognizer(UIPinchGestureRecognizer(
				target: faceView,
				action: #selector(faceView.changeScale(_:))
			))
			let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(
				target: self,
				action:#selector(FaceViewController.increaseHappiness)
			)
			happierSwipeGestureRecognizer.direction = .Down
			faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
			let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(
				target: self,
				action:#selector(FaceViewController.decreaseHappiness)
			)
			sadderSwipeGestureRecognizer.direction = .Up
			faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		updateUI()
	}
	
	func increaseHappiness() {
		expression.mouth = expression.mouth.happierMouth()
	}
	
	func decreaseHappiness() {
		expression.mouth = expression.mouth.sadderMouth()
	}
	
	@IBAction private func toggleEyes(recognizer: UITapGestureRecognizer) {
		if recognizer.state == .Ended {
			switch expression.eyes {
			case .Open: expression.eyes = .Closed
			case .Closed: expression.eyes = .Open
			case .Squinting: break
			}
		}
	}
	
	@IBAction private func changeBrows(recognizer: UIRotationGestureRecognizer) {
		let minimumRotationForChangeBrows: CGFloat = 0.1
		guard abs(recognizer.rotation) > minimumRotationForChangeBrows else { return }
		switch recognizer.state {
		case .Changed, .Ended:
			if recognizer.rotation > 0 {
				expression.eyeBrows = expression.eyeBrows.moreRelaxedBrow()
			} else {
				expression.eyeBrows = expression.eyeBrows.moreFurrowedBrow()
			}
			recognizer.rotation = 0.0
		default: break
		}
	}
	
	
	private let mouthCurvatures: [FacialExpression.Mouth : Double] =
		[.Frown: -1.0, .Grin: 0.5, .Smile: 1.0, .Smirk: -0.5, .Neutral: 0.0 ]
	
	private var eyeBrowTilts: [FacialExpression.EyeBrows : Double] =
		[.Relaxed: 0.5, .Furrowed: -0.5, .Normal: 0.0]
	
	private func updateUI() {
		guard faceView != nil else { return }
		switch expression.eyes {
		case .Open: 	faceView.eyesOpen = true
		case .Closed: 	faceView.eyesOpen = false
		case .Squinting:faceView.eyesOpen = false
		}
		faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
		faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
	}



}

