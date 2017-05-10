//
//  EmotionsViewController.swift
//  Faceit
//
//  Created by Youmeiyi Pan on 4/25/17.
//  Copyright © 2017 Youmeiyi Pan. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        if let faceViewController = destinationViewController as? FaceViewController,
            let identifier = segue.identifier ,
                let expression = emotionalFaces[identifier]{
            faceViewController.expression = expression
            
            faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
                
            
        }
    }
 
    private let emotionalFaces: Dictionary<String,FacialExpression> = [
        "sad" : FacialExpression(eyes: .closed, mouth: .frown),
        "happy" : FacialExpression(eyes: .open, mouth: .smile),
        "worried" : FacialExpression(eyes: .open, mouth: .smirk)
    ]
}
