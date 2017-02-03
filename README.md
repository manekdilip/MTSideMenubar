# MTSideMenubar
Easily creating side menu bar in your project with dynamic size and open/close left side as well as right side. 
MTSideMenubar view written in Swift 3.0 and easy to use in project.

![BackgroundImage](https://github.com/manekdilip/MTSideMenubar/blob/master/Images/MTSideMenubar.gif)

#Installation

### Manually

Clone or Download this Repo. Then simply drag the clas ```MTSideMenubar``` to your Xcode project.


###Simply way to integrate ```MTSideMenubar```

###Implement ```MoreMenuBarDelegate```

```
    class ViewController: UIViewController, MoreMenuBarDelegate {
        override func viewDidLoad() {
            super.viewDidLoad()

        }     
    }

    //MARK: - MoreMenuBar Delegate
    func tappedOnEvent(sender: UIControl, sideMenubar: MTSideMenubar) {
      
        if sideMenubar == sideMenubarLeft {
            print("Left Side Menu Button Tag : ",sender.tag)
        }
        else if sideMenubar == sideMenubarRight {
            print("Right Side Menu Button Tag : ",sender.tag)
        }
    }
    func moreMenuItemHide(sideMenubar: MTSideMenubar) {
        print("moreMenuItemHide")
    }
    func moreMenuItemShow(sideMenubar: MTSideMenubar) {
        print("moreMenuItemShow")
    }
```

###Create ```MTSideMenubar```

```
    class ViewController: UIViewController, MoreMenuBarDelegate {
        var sideMenubarLeft:MTSideMenubar!
        var arrBtnImageListLeft = [MTSideMenuImageList]()
        override func viewDidLoad() {
                super.viewDidLoad()

                //Left Side Menu bar Create
                arrBtnImageListLeft.append(MTSideMenuImageList(imgButton: #imageLiteral(resourceName: "imgTwitter")))
                arrBtnImageListLeft.append(MTSideMenuImageList(imgButton: #imageLiteral(resourceName: "imgInstagram")))
                arrBtnImageListLeft.append(MTSideMenuImageList(imgButton: #imageLiteral(resourceName: "imgGooglePlus")))
                arrBtnImageListLeft.append(MTSideMenuImageList(imgButton: #imageLiteral(resourceName: "imgFacebook")))
                arrBtnImageListLeft.append(MTSideMenuImageList(imgButton: #imageLiteral(resourceName: "imgDribble")))

                var heightOfMenuBarLeft = (DeviceScale.SCALE_X * 20.0) //Top-Bottom Spacing
                heightOfMenuBarLeft += ((DeviceScale.SCALE_X * 16.66) * CGFloat((arrBtnImageListLeft.count - 1))) //Button between spacing
                heightOfMenuBarLeft += (CGFloat(arrBtnImageListLeft.count) * 50.0) //Button height spacing

                let originYOfMenuBarLeft = (self.view.frame.size.height / 2.0) - (heightOfMenuBarLeft / 2)

                sideMenubarLeft = MTSideMenubar.init(frame: CGRect(x: (ScreenSize.WIDTH - (DeviceScale.SCALE_X * 84.0)),y: originYOfMenuBarLeft,width: (DeviceScale.SCALE_X * 84.0),height: heightOfMenuBarLeft)).createUI(view: self.view, arrBtnImageList: arrBtnImageListLeft) as! MTSideMenubar
                sideMenubarLeft.delegate = self
        }
    }

```


###Show menu list left side

```
    sideMenubarLeft.show(isShowingLeftToRight: true)

```

###Show menu list right side

```
    sideMenubarLeft.show(isShowingLeftToRight: false)

```

###Hide menu bar

```
    sideMenubarLeft.hide()

```

