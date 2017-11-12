//import UIKit
//
//class Emitter {
//    static func get(with image: UIImage) -> CAEmitterLayer {
//        let emitter = CAEmitterLayer()
//        emitter.emitterShape = kCAEmitterLayerLine
//        emitter.emitterCells = generateEmitterCells(with: image)
//        
//        return emitter
//    }
//    
//    static func generateEmitterCells(with image: UIImage) -> [CAEmitterCell] {
//        var cells = [CAEmitterCell]()
//        
//        let cell = CAEmitterCell()
//        cell.contents = image.cgImage
//        cell.birthRate = 1
//        cell.lifetime = 40
//        //how long is this appearing?
//        cell.velocity = CGFloat(25)
//        cell.emissionLongitude = (180 * (.pi/180))
//        //because it needs to be falling down
//        cell.emissionRange = (45 * (.pi/180))
//        //straigt line or 10 degree one another, different degree(45 degree in each side)
//        
//        cell.scale = 0.3
//        //scale it down to smaller size (default is 1.0)
//        cell.scaleRange = 0.3
//        
//        cell.spin = 0
//        cell.spinRange = 2
//        
//        cells.append(cell)
//        return cells
//        
//    }
//    
//    
//}



