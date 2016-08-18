//
//  RotateView.swift
//  LoopImage_Swift
//
//  Created by langyue on 16/8/18.
//  Copyright © 2016年 langyue. All rights reserved.
//

import UIKit


//Click Image Delegate
@objc protocol RotateViewDelegate {

    optional func clickCurrentImage(currentIndex: Int)

}



class RotateView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    var currentIndex = Int()
    var delegate : RotateViewDelegate?

    private var timer : NSTimer!
    private var index = Int()//下标 of element of Current Array
    private var showImageView = UIImageView()//current showing image
    private var pageControl = UIPageControl()




    //Image Array Which need to loop
    var imageArray : [AnyObject!]!{
        //Monitor change of array
        willSet(newValue){
            self.imageArray = newValue
        }
        didSet{

            setImageView()
            setPageControl()
            timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(self.transitionIsRight(_:)), userInfo: nil, repeats: true)

        }

    }





    func setImageView() -> Void {

        index = 0
        showImageView.frame = bounds
        showImageView.userInteractionEnabled = true
        self.addSubview(showImageView)
        if imageArray.count > 0 {
            loadImage_Index(0)
        }

        //Left Gesture
        let leftSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(self.liftSwipeAction(_:)))
        leftSwipe.direction = .Left
        //Right Gesture
        let rightSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(self.rightSwipeAction(_:)))
        rightSwipe.direction = .Right
        //Click Gesture
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tapSwipeAction(_:)))

        //add Gesture
        showImageView.addGestureRecognizer(leftSwipe)
        showImageView.addGestureRecognizer(rightSwipe)
        showImageView.addGestureRecognizer(tap)


    }

    func setPageControl() -> Void {

        //add a pageControl
        pageControl.frame = CGRectMake(0, bounds.size.height - 40, bounds.size.width, 40)
        pageControl.backgroundColor = UIColor.lightTextColor()
        pageControl.numberOfPages = imageArray.count
        pageControl.currentPageIndicatorTintColor = UIColor.orangeColor()
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        showImageView.addSubview(pageControl)
        bringSubviewToFront(pageControl)
        pageControl.userInteractionEnabled = false

    }


    //load image
    func loadImage_Index(index: Int){


        

        if imageArray[index].isKindOfClass(UIImage) {
            showImageView.image = imageArray[index] as? UIImage
        }

        if imageArray[index].isKindOfClass(NSString) {
            showImageView.sd_setImageWithURL(NSURL.init(string: imageArray[index] as! String), placeholderImage: UIImage.init(named: "carousel_default.jpg"))
        }


    }


    //Left gesutre
    func liftSwipeAction(sender:UISwipeGestureRecognizer){

        transitionIsRight(false)
        timer.invalidate()
        timer = nil
        if sender.state == .Ended {
            timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(self.transitionIsRight(_:)), userInfo: nil, repeats: true)
        }



    }

    //Right gesture
    func rightSwipeAction(sender:UISwipeGestureRecognizer) -> Void {

        transitionIsRight(true)
        timer.invalidate()
        timer = nil
        if sender.state == .Ended {
            timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(self.transitionIsRight(_:)), userInfo: nil, repeats: true)
        }

    }

    //set swipe animation
    func transitionIsRight(isRight:Bool){

        //Create animate
        let transition = CATransition()
        //transition.type = "cube"
        transition.type = "Curl"
        //transition.type = "suckEffect"
        //transition.type = "pageCurl"
        //transition.type = "rippleEffect"
        //transition.type = "oglFlip"




        if isRight == false {
            //
            index += 1
            transition.subtype = kCATransitionFromRight

        }else{

            if index == 0 {
                index = imageArray.count - 1
            }else{
                index -= 1
            }
            transition.subtype = kCATransitionFromLeft

        }
        transition.duration = 0.7
        let currentIndex = index % imageArray.count
        loadImage_Index(currentIndex)//set animation new image
        showImageView.layer.addAnimation(transition, forKey: "animation")//start animate
        self.currentIndex = currentIndex
        pageControl.currentPage = currentIndex
        
    }



    //Click Image Response
    func tapSwipeAction(sender:UITapGestureRecognizer) -> Void {
        self.delegate?.clickCurrentImage!(currentIndex)
    }


    deinit{
        timer.invalidate()
        timer = nil
    }



}
