// MIT License
//
// Copyright (c) 2017 Zack Rubenstein
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

class GyroView: UIView {

    /// Maximum angle that the view will rotate too. Default is 6 (degrees)
    var maximumPressure:CGFloat = 6
    
    /// Weight that determines how far apart each level is on the (imaginary) z-axis. Default is 0.01
    var levelWeight:CGFloat = 0.01
    
    private var levels:[Int : [UIView]?] = [:]
    
    //////////////////
    // Touch Event overrides
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        pressure(touch: touch)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first else { return }
        pressure(touch: touch)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.32, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            self.reset()
        }, completion: nil)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        UIView.animate(withDuration: 0.32, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            self.reset()
        }, completion: nil)
    }
    
    
    //////////////////
    /// Add a subview at a level. Higher levels are shifted when the view is being gyroscoped
    
    func addSubview(_ view:UIView, level:Int) {
        assert(level >= 0, "Level must be greater than or equal to 0")
        
        self.addSubview(view)
        
        if self.levels[level] == nil {
            self.levels[level] = Array<UIView>(arrayLiteral: view)
        } else {
            var array = self.levels[level]!
            array?.append(view)
            self.levels[level] = array
        }
    }
    
    
    //////////////////
    // Gyro-enabling functions
    
    /// Add pressure from a touch
    func pressure(touch:UITouch) {
        let location = touch.location(in: self)
        pressure(x: location.x, y: location.y)
    }
    
    /// Add pressure at a position relative to the view
    func pressure(x:CGFloat, y:CGFloat) {
        
        let xRelative = x - self.width/2
        let x = xRelative / (self.width / 2)
        
        let yRelative = -(y - self.height/2)
        let y = yRelative / (self.height / 2)
        
        let distance = sqrt(pow(xRelative, 2) + pow(yRelative, 2))
        let pressure = min(maximumPressure * distance / max(self.width, self.height), maximumPressure)
        
        skew(rotation: pressure, x: x, y: y)
    }
    
    
    //////////////////
    // Gyro-rendering functions
    
    private func skew(rotation:CGFloat, x:CGFloat, y:CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -500
        transform = CATransform3DRotate(transform, rotation * (.pi / 180), y, x, 0)
        transform = CATransform3DScale(transform, 0.99, 0.99, 1)
        
        positionLevels(x: x, y: y)
        
        self.layer.transform = transform
    }
    
    private func positionLevels(x:CGFloat, y:CGFloat) {
        for (level, views) in levels {
            guard let views = views else { continue }
            
            let x = x * self.width/2 * CGFloat(level) * levelWeight
            let y = -y * self.height/2 * CGFloat(level) * levelWeight
                        
            for view in views {
                view.transform = CGAffineTransform(translationX: x, y: y)
            }
        }
    }
    
    /////////////////
    /// Reset the view back to normal
    func reset() {
        self.layer.transform = CATransform3DIdentity
        
        for (_, views) in levels {
            guard let views = views else { continue }
            
            for view in views {
                view.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        }
        
    }
    
}











