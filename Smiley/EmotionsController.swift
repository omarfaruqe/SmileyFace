

import UIKit

class EmotionsController: UIViewController {
	
	private let emotionalFaces: [String: FacialExpression] = [
		"angry": FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Frown),
		"mischievious": FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Grin),
		"happy": FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile),
		"worried": FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Smirk)
	]
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		var destinationvc = segue.destinationViewController
		if let nc = destinationvc as? UINavigationController {
			destinationvc = nc.visibleViewController!
		}
		if let faceViewController = destinationvc as? FaceViewController,
		let identifier = segue.identifier {
			if let expression = emotionalFaces[identifier] {
				faceViewController.expression = expression
				if let button = sender as? UIButton {
					faceViewController.navigationItem.title = button.currentTitle
				}
			}
		}
	}

}
