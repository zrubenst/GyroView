# GyroView

Emulate the Apple TV 3D Parallax effect on iPhone and iPad

![](demonstration.gif)

### Example

```swift
let view = GyroView(frame: CGRect(x: 30, y: 30, width: 100, height: 60))

let inner = UIView(frame: CGRect(x: 25, y: 10, width: 50, height: 40))
view.addSubview(inner, level: 1)
```

A `GyroView` on its own will perform a 3D skew from touch events, adding subviews at a `level` above 0 enables the parallax effect.

### Customization

```swift
let view = GyroView()
view.maximumPressure = 10
view.levelWeight = 0.03
```

`maximumPressure` is the maximum angle (in degrees) that the view will rotate too. Default is 6

`levelWeight` determines how far apart each level is on the (imaginary) z-axis. Default is 0.01

## Installation

It's one file, just copy it into your project. Edit as you please
