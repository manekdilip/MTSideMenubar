import UIKit

class ViewController: UIViewController, MoreMenuBarDelegate {

    //Outlet
    @IBOutlet var controlSideMenuRightBtn: UIControl!
    @IBOutlet var controlSideMenuLeftBtn: UIControl!
    @IBOutlet var controlBG: UIControl!
    
    //Side More Item
    var sideMenubarLeft:MTSideMenubar!
    var sideMenubarRight:MTSideMenubar!
    
    //Data Store
    var arrBtnImageListLeft = [MTSideMenuImageList]()
    var arrBtnImageListRight = [MTSideMenuImageList]()
    
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
        
        //Right Side Menu bar Create
        arrBtnImageListRight.append(MTSideMenuImageList(imgButton: #imageLiteral(resourceName: "imgLinkedIn")))
        arrBtnImageListRight.append(MTSideMenuImageList(imgButton: #imageLiteral(resourceName: "imgVimeo")))
        arrBtnImageListRight.append(MTSideMenuImageList(imgButton: #imageLiteral(resourceName: "imgBehance")))
        
        var heightOfMenuBarRight = (DeviceScale.SCALE_X * 20.0) //Top-Bottom Spacing
        heightOfMenuBarRight += ((DeviceScale.SCALE_X * 16.66) * CGFloat((arrBtnImageListRight.count - 1))) //Button between spacing
        heightOfMenuBarRight += (CGFloat(arrBtnImageListRight.count) * 50.0) //Button height spacing
        
        let originYOfMenuBarRight = (self.view.frame.size.height / 2.0) - (heightOfMenuBarRight / 2)
        
        sideMenubarRight = MTSideMenubar.init(frame: CGRect(x: (ScreenSize.WIDTH - (DeviceScale.SCALE_X * 84.0)),y: originYOfMenuBarRight,width: (DeviceScale.SCALE_X * 84.0),height: heightOfMenuBarRight)).createUI(view: self.view, arrBtnImageList: arrBtnImageListRight) as! MTSideMenubar
        sideMenubarRight.delegate = self
        //sideMenubarRight.backgroundColor = .red
        
        //Side Menu Button
        controlSideMenuRightBtn.layer.cornerRadius = controlSideMenuRightBtn.frame.size.height / 2.0
        controlSideMenuLeftBtn.layer.cornerRadius = controlSideMenuLeftBtn.frame.size.height / 2.0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//MARK: - MoreMenuBar Delegate
    func tappedOnEvent(sender: UIControl, sideMenubar: MTSideMenubar) {
      
        if sideMenubar == sideMenubarLeft {
            print("Left Side Menu Button Tag : ",sender.tag)
            sideMenubarLeft.hide()
        }
        else if sideMenubar == sideMenubarRight {
            print("Right Side Menu Button Tag : ",sender.tag)
            sideMenubarRight.hide()
        }
    }
    func moreMenuItemHide(sideMenubar: MTSideMenubar) {
    
        self.hideBackgroundControl()
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            
            if sideMenubar == self.sideMenubarLeft {
                self.controlSideMenuLeftBtn.alpha = 1.0
            }
            else if sideMenubar == self.sideMenubarRight {
                self.controlSideMenuRightBtn.alpha = 1.0
            }
        }) { (finished) in
            
        }
    }
    func moreMenuItemShow(sideMenubar: MTSideMenubar) {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            
            if sideMenubar == self.sideMenubarLeft {
                self.controlSideMenuLeftBtn.alpha = 0.0
            }
            else if sideMenubar == self.sideMenubarRight {
                self.controlSideMenuRightBtn.alpha = 0.0
            }
        }) { (finished) in
            
        }
    }
//MARK: - Tapped Event
    @IBAction func tappedOnBackground(_ sender: Any) {
        if controlBG.alpha >= 0.15 {
            //Side menubar hide
            if sideMenubarRight.tag == 1 {
                sideMenubarRight.hide()
                self.hideBackgroundControl()
            }
            
            //Side menubar show
            if sideMenubarLeft.tag == 1 {
                sideMenubarLeft.hide()
                self.hideBackgroundControl()
            }
        }
    }
    @IBAction func tappedOnRightSideMenuBtn(_ sender: Any) {
        //Side menubar show
        if sideMenubarRight.tag == 0 {
            sideMenubarRight.show(isShowingLeftToRight: false)
            self.showBackgroundControl()
        }
        //Side menubar hide
        else {
            sideMenubarRight.hide()
            self.hideBackgroundControl()
        }
    }
    @IBAction func tappedOnLeftSideMenuBtn(_ sender: Any) {
        //Side menubar show
        if sideMenubarLeft.tag == 0 {
            sideMenubarLeft.show(isShowingLeftToRight: true)
            self.showBackgroundControl()
        }
        //Side menubar hide
        else {
            sideMenubarLeft.hide()
            self.hideBackgroundControl()
        }
    }
//MARK: - Hide Show Background View
    func hideBackgroundControl() {
        self.controlBG.isHidden = true
    }
    func showBackgroundControl() {
        self.controlBG.alpha = 0.1
        self.controlBG.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.controlBG.alpha = 0.2
        }, completion: { (finished) in
            
        })
    }
}

