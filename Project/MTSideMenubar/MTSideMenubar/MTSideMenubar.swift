import UIKit

protocol MoreMenuBarDelegate {
    
    func tappedOnEvent(sender: UIControl,sideMenubar: MTSideMenubar)
    func moreMenuItemHide(sideMenubar: MTSideMenubar)
    func moreMenuItemShow(sideMenubar: MTSideMenubar)
}

//MARK: - Model Class
class MTSideMenuImageList {
    //Variable Declaration
    var imgButton:UIImage = UIImage()
    
    //Allock memory
    init(imgButton:UIImage) {
        self.imgButton = imgButton
    }
}

class MTSideMenubar: UIView {
//MARK: - Variable Declaration
    var rectPlayer:CGRect!
    let fltButtonSize = (DeviceScale.SCALE_X * 50.0)
    var isShowingMenuBar = false
    var isShowingMenuBarAnimating = false
    var isShowingLeftToRight = false
    
    //Background
    var viewTransperant:UIView!
    var viewMoreItemBG:UIControl!
    
    //Buttons
    var controlButtons = [UIControl]()
    
    //Images
    var imgButtons = [UIImageView]()
    
    //Delegate
    var delegate:MoreMenuBarDelegate?
    
    //Swipe Gesture
    var gestureLeft:UISwipeGestureRecognizer!
    var gestureRight:UISwipeGestureRecognizer!
    
    //Data Store
    var arrBtnImageList = [MTSideMenuImageList]()
    
//MARK: - Override Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        rectPlayer = frame
        self.backgroundColor = .clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: - Create Design
    func createUI(view: UIView,arrBtnImageList: [MTSideMenuImageList]) -> UIView {
        
        self.arrBtnImageList.removeAll()
        self.arrBtnImageList = arrBtnImageList
        
        //View More Item Background
        viewMoreItemBG = UIControl(frame: CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height))
        viewMoreItemBG.backgroundColor = .clear
        self.addSubview(viewMoreItemBG)
        
        //Transperant
        viewTransperant = UIView(frame: CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height))
        viewTransperant.backgroundColor = UIColor(red:21.0/255.0, green:24.0/255.0, blue:23.0/255.0, alpha:0.4)
        viewTransperant.isUserInteractionEnabled = false
        viewMoreItemBG.addSubview(viewTransperant)
        
        if self.arrBtnImageList.count != 0 {
            //Buttons Create
            var i = 0
            for _ in self.arrBtnImageList {
                
                //Control Create
                if i == 0 {
                    controlButtons.append(
                        UIControl(frame:
                            CGRect(
                                x: (viewMoreItemBG.frame.size.width / 2) - (fltButtonSize / 2.0),
                                y: (DeviceScale.SCALE_Y * 10.0),
                                width: fltButtonSize,
                                height: fltButtonSize)))
                } else {
                    controlButtons.append(
                        UIControl(frame:
                            CGRect(
                                x: (viewMoreItemBG.frame.size.width / 2) - (fltButtonSize / 2.0),
                                y: (controlButtons[i-1].frame.origin.y + controlButtons[i-1].frame.size.height + (DeviceScale.SCALE_Y * 16.66)),
                                width: fltButtonSize,
                                height: fltButtonSize)))
                }
                
                controlButtons[i].addTarget(self, action: #selector(tappedOnButtons), for: .touchUpInside)
                controlButtons[i].tag = i
                controlButtons[i].backgroundColor = .clear
                viewMoreItemBG.addSubview(controlButtons[i])
                
                //Image Create
                imgButtons.append(
                    UIImageView(frame:
                        CGRect(
                            x: 0 ,
                            y: 0,
                            width: controlButtons[i].frame.size.width,
                            height: controlButtons[i].frame.size.height)))
                imgButtons[i].image = self.arrBtnImageList[i].imgButton
                imgButtons[i].clipsToBounds = true
                imgButtons[i].contentMode = .scaleAspectFit
                imgButtons[i].isUserInteractionEnabled = false
                imgButtons[i].backgroundColor = .clear
                controlButtons[i].addSubview(imgButtons[i])
                
                i += 1
            }
            
            i -= 1
            viewMoreItemBG.frame = CGRect(
                x: 0 ,
                y: ((self.frame.size.height - (controlButtons[i].frame.origin.y + controlButtons[i].frame.size.height + controlButtons[0].frame.origin.y))) / 2.0 ,
                width: self.frame.size.width ,
                height: (controlButtons[i].frame.origin.y + controlButtons[i].frame.size.height + controlButtons[0].frame.origin.y))
            viewTransperant.frame = CGRect(x: 0,y: 0,width: viewMoreItemBG.frame.size.width,height: viewMoreItemBG.frame.size.height)
        }
        
        //Gesture Left
        gestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeToDown))
        gestureLeft.direction = UISwipeGestureRecognizerDirection.left
        viewMoreItemBG.addGestureRecognizer(gestureLeft)
        
        //Gesture Right
        gestureRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeToDown))
        gestureRight.direction = UISwipeGestureRecognizerDirection.right
        viewMoreItemBG.addGestureRecognizer(gestureRight)
        
        view.addSubview(self)
        self.frame = CGRect(x:ScreenSize.WIDTH ,y: self.frame.origin.y,width: self.frame.size.width,height: self.frame.size.height)
        return self
    }
//MARK: - Tapped Event
    func tappedOnButtons(sender: UIControl) {
        delegate?.tappedOnEvent(sender: sender, sideMenubar: self)
        
        let scaleAnimate:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimate.fromValue = 1
        scaleAnimate.toValue = 0.7
        scaleAnimate.duration = 0.1
        scaleAnimate.isRemovedOnCompletion = false
        scaleAnimate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        sender.layer.add(scaleAnimate, forKey: "scaleSmallAnimation")
        
    }
//MARK: - Show View
    func showAnimation(sender: UIControl,delay: CGFloat) {
        
        self.delegate?.moreMenuItemShow(sideMenubar: self)
        let frameDestination:CGRect = CGRect(x: (viewMoreItemBG.frame.size.width / 2) - (fltButtonSize / 2.0),y: sender.frame.origin.y,width: sender.frame.size.width,height: sender.frame.size.height)
        
        if self.isShowingLeftToRight == true {
            
            sender.frame = CGRect(x: -rectPlayer.size.width,y: sender.frame.origin.y,width: sender.frame.size.width,height: sender.frame.size.height)
        }
        else {
            sender.frame = CGRect(x: rectPlayer.size.width,y: sender.frame.origin.y,width: sender.frame.size.width,height: sender.frame.size.height)
        }
        
        //Move Effect
        UIView.animate(withDuration: 0.15, delay: TimeInterval(delay), options: [.curveEaseOut], animations: {
            sender.frame = frameDestination
        }, completion: nil)
        
        //Rotation Effect
        UIView.animate(withDuration: 0.05, delay: TimeInterval(delay), options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }, completion: { finished in
            UIView.animate(withDuration: 0.1, delay: TimeInterval(0.0), options: [.curveEaseOut], animations: {
                sender.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
                
            }, completion: { finished in
            })
        })
    }
    func show(isShowingLeftToRight: Bool) {
        
        if isShowingMenuBar == false && isShowingMenuBarAnimating == false {
            self.isShowingLeftToRight = isShowingLeftToRight
            if self.isShowingLeftToRight == true {
                rectPlayer = CGRect(x: 0,y: rectPlayer.origin.y,width: rectPlayer.size.width,height: rectPlayer.size.height)
                
                //Transparent Corner Radious
                let pathTransperantLeft = UIBezierPath(roundedRect:viewTransperant.bounds,
                                                       byRoundingCorners:[.topLeft, .bottomLeft],
                                                       cornerRadii: CGSize(width: 0, height:  0))
                let maskLayerTransperantLeft = CAShapeLayer()
                maskLayerTransperantLeft.path = pathTransperantLeft.cgPath
                viewTransperant.layer.mask = maskLayerTransperantLeft
                
                let pathTransperantRight = UIBezierPath(roundedRect:viewTransperant.bounds,
                                                        byRoundingCorners:[.topRight, .bottomRight],
                                                        cornerRadii: CGSize(width: 12, height:  12))
                let maskLayerTransperantRight = CAShapeLayer()
                maskLayerTransperantRight.path = pathTransperantRight.cgPath
                viewTransperant.layer.mask = maskLayerTransperantRight
            }
            else {
                rectPlayer = CGRect(x: (ScreenSize.WIDTH - rectPlayer.size.width),y: rectPlayer.origin.y,width: rectPlayer.size.width,height: rectPlayer.size.height)
            
                //Transparent Corner Radious
                let pathTransperantRight = UIBezierPath(roundedRect:viewTransperant.bounds,
                                                        byRoundingCorners:[.topRight, .bottomRight],
                                                        cornerRadii: CGSize(width: 0, height:  0))
                let maskLayerTransperantRight = CAShapeLayer()
                maskLayerTransperantRight.path = pathTransperantRight.cgPath
                viewTransperant.layer.mask = maskLayerTransperantRight
                
                let pathTransperantLeft = UIBezierPath(roundedRect:viewTransperant.bounds,
                                                   byRoundingCorners:[.topLeft, .bottomLeft],
                                                   cornerRadii: CGSize(width: 12, height:  12))
                let maskLayerTransperantLeft = CAShapeLayer()
                maskLayerTransperantLeft.path = pathTransperantLeft.cgPath
                viewTransperant.layer.mask = maskLayerTransperantLeft
            }
            self.isShowingMenuBarAnimating = true
            self.frame = rectPlayer
            
            var delayTime = 0.0
            var i = 0
            for _ in self.arrBtnImageList {
                self.showAnimation(sender: controlButtons[i], delay: CGFloat(delayTime))
                i += 1
                delayTime += 0.06
            }
            
            viewTransperant.alpha = 0
            UIView.animate(withDuration: (0.15 + 0.36), delay: TimeInterval(0.0), options: [.curveEaseOut], animations: {
                self.viewTransperant.alpha = 1
            }, completion: { finished in
                self.isShowingMenuBar = true
                self.isShowingMenuBarAnimating = false
                self.tag = 1
            })
        }
    }
//MARK: - Hide View
    func hideAnimation(sender: UIControl,delay: CGFloat) {
        
        //Move Effect
        UIView.animate(withDuration: 0.15, delay: TimeInterval(delay), options: [.curveEaseOut], animations: {
            if self.isShowingLeftToRight == true {
                sender.frame = CGRect(x: -self.rectPlayer.size.width,y: sender.frame.origin.y,width: sender.frame.size.width,height: sender.frame.size.height)
            }
            else {
                sender.frame = CGRect(x: self.rectPlayer.size.width,y: sender.frame.origin.y,width: sender.frame.size.width,height: sender.frame.size.height)
            }
        }, completion: nil)
        
        //Rotation Effect
        UIView.animate(withDuration: 0.1, delay: TimeInterval(delay), options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }, completion: { finished in
            UIView.animate(withDuration: 0.05, delay: TimeInterval(0.0), options: [.curveEaseOut], animations: {
                sender.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
                
            }, completion: { finished in
            })
        })
    }
    func hide() {
        
        if isShowingMenuBar == true && isShowingMenuBarAnimating == false {
            self.delegate?.moreMenuItemHide(sideMenubar: self)
            self.isShowingMenuBarAnimating = true
            
            var delayTime = (0.06 * CGFloat(self.arrBtnImageList.count - 1))
            var i = (self.arrBtnImageList.count - 1)
            for _ in self.arrBtnImageList {
                self.hideAnimation(sender: controlButtons[i], delay: delayTime)
                i -= 1
                delayTime -= 0.06
            }
            UIView.animate(withDuration: (0.15 + 0.36), delay: TimeInterval(0), options: [.curveEaseOut], animations: {
                self.viewTransperant.alpha = 0.1
            }, completion: { finished in
                if self.isShowingLeftToRight == true {
                    self.frame = CGRect(x: 0 - self.frame.size.width,y: self.frame.origin.y,width: self.frame.size.width,height: self.frame.size.height)
                }
                else {
                    self.frame = CGRect(x:ScreenSize.WIDTH ,y: self.frame.origin.y,width: self.frame.size.width,height: self.frame.size.height)
                }
                self.isShowingMenuBar = false
                self.isShowingMenuBarAnimating = false
                self.tag = 0
            })
        }
    }
//MARK: - Gesture Swipe
    func swipeToDown(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swipe Right")
                if self.isShowingLeftToRight == false {
                    self.hide()
                }
                break
            case UISwipeGestureRecognizerDirection.left:
                print("Swipe Left")
                if self.isShowingLeftToRight == true {
                    self.hide()
                }
                break
            case UISwipeGestureRecognizerDirection.down:
                print("Swipe Down")
                break
            case UISwipeGestureRecognizerDirection.up:
                print("Swipe Up")
                break
            default:
                print("Default")
                break
            }
        }
    }
}
//MARK: - Scaling
struct DeviceScale {
    static let SCALE_X = ScreenSize.WIDTH / 375
    static let SCALE_Y = ScreenSize.HEIGHT / 667
}

//MARK: - Screen Size
struct ScreenSize {
    static let WIDTH  = UIScreen.main.bounds.size.width
    static let HEIGHT = UIScreen.main.bounds.size.height
}
