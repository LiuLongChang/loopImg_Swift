//
//  ViewController.swift
//  LoopImage_Swift
//
//  Created by langyue on 16/8/18.
//  Copyright © 2016年 langyue. All rights reserved.
//

import UIKit

import SnapKit



class ViewController: UIViewController,RotateViewDelegate,UITableViewDelegate,UITableViewDataSource{


    let Screen_Width = UIScreen.mainScreen().bounds.size.width
    let Scale_Width = UIScreen.mainScreen().bounds.size.width/376


    var tabView : UITableView!
    var headerView : UIView!
    var rotateView : RotateView!
    var serveView : UIView!


    //-------tableView
    private func setupTableView(){
        tabView.delegate = self
        tabView.dataSource = self
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.brownColor()


        //不加下面这句 tableView会向下偏移64
        self.automaticallyAdjustsScrollViewInsets = false;
        self.edgesForExtendedLayout = UIRectEdge.None;




        tabView = UITableView(frame: CGRectZero,style: .Grouped)
        tabView.backgroundColor = UIColor.redColor()
        //tabView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabView)
        tabView.translatesAutoresizingMaskIntoConstraints = false
        setupTableView()
        tabView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "BoutiqueCell")
        setHeaderView()


        let tabViewCons0 = NSLayoutConstraint(item: tabView,attribute: .Left,relatedBy: .Equal,toItem: view,attribute: .Left,multiplier: 1,constant: 5)
        let tabViewCons1 = NSLayoutConstraint(item: tabView,attribute: .Right,relatedBy: .Equal,toItem: view,attribute: .Right,multiplier: 1,constant: -5)
        let tabViewCons2 = NSLayoutConstraint(item: tabView,attribute: .Top,relatedBy: .Equal,toItem: view,attribute: .Top,multiplier: 1,constant: 5)
        let tabViewCons3 = NSLayoutConstraint(item: tabView,attribute: .Bottom,relatedBy: .Equal,toItem: view,attribute: .Bottom,multiplier: 1,constant: -5)
        let consArr = [tabViewCons0,tabViewCons1,tabViewCons2,tabViewCons3]
        view.addConstraints(consArr)

        setupTableView()


    }



    func setHeaderView(){

        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = true
        headerView.bounds = CGRectMake(0, 0, Screen_Width, 390*Scale_Width)
        headerView.backgroundColor = UIColor.purpleColor()
        rotateView = RotateView()
        headerView.addSubview(rotateView)
        rotateView.frame = CGRectMake(0, 0, Screen_Width, 260*Scale_Width)





        rotateView.imageArray = [UIImage.init(named: "1.jpg"),UIImage.init(named: "2.jpg"),UIImage.init(named: "3.jpg"),UIImage.init(named: "4.jpg"),UIImage.init(named: "5.jpg")]
        rotateView.delegate = self




        serveView = UIView();headerView.addSubview(serveView);
        serveView.backgroundColor = UIColor.blueColor()
        serveView.snp.makeConstraints { (make) in
            make.top.equalTo(rotateView.snp.bottom).offset(5)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        let titleArray = ["委托找房","投放房源","秒租礼包","秒赚佣金"]
        let imgArray = ["gift","sale","weituofind","gift"]
        let everyWidth = Screen_Width/4
        let everyHeight = everyWidth
        var preBtn : UIButton! = nil
        for i in 0..<titleArray.count {

            let btn = UIButton(type: .Custom);serveView.addSubview(btn)
            let titleLabel = UILabel();serveView.addSubview(titleLabel)
            titleLabel.text = titleArray[i];titleLabel.textAlignment = .Center
            titleLabel.textColor = UIColor.whiteColor();
            btn.tag = i

            btn.setTitle(titleArray[i], forState: .Normal)
            btn.setImage(UIImage(named: imgArray[i]), forState: .Normal)
            btn.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: .TouchUpInside)
            btn.snp.makeConstraints(closure: { (make) in

                make.width.equalTo(everyWidth)
                make.height.equalTo(everyHeight)
                if i == 0 {
                    //第一个
                    make.left.equalTo(0)
                    make.top.equalTo(0)
                    preBtn = btn

                }else if i == (titleArray.count-1){
                    //最后一个
                    make.right.equalTo(0)
                    make.top.equalTo(0)

                }else{
                    make.left.equalTo(preBtn.snp.right)
                    make.top.equalTo(preBtn.snp.top)
                    preBtn = btn

                }

            })


            titleLabel.snp.makeConstraints(closure: { (make) in

                make.left.right.equalTo(btn)
                make.top.equalTo(btn.snp.bottom)
                make.height.equalTo(20)

            })



        }

        setServeViewToView(headerView)
        tabView.tableHeaderView = headerView



    }

    func btnAction(btn:UIButton){


        print("点击了\(btn.tag)")


    }


    func setServeViewToView(toView:UIView){
        toView.addSubview(serveView)
    }


    func clickCurrentImage(currentIndex: Int){
        print(currentIndex)
    }

    //--------tableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BoutiqueCell", forIndexPath: indexPath)
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 260*Scale_Width
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

