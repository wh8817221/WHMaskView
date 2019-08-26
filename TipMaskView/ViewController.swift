//
//  ViewController.swift
//  TipMaskView
//
//  Created by 王浩 on 2019/8/23.
//  Copyright © 2019 haoge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton(type: .custom)
        btn.setTitle("点我啊", for: .normal)
        btn.backgroundColor = UIColor.blue
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.frame = CGRect(x: 20, y: 100, width: 80, height: 40)
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(touchPoint(_:)), for: .touchUpInside)
        
        
        let btn1 = UIButton(type: .custom)
        btn1.setTitle("小心点", for: .normal)
        btn1.backgroundColor = UIColor.blue
        btn1.layer.cornerRadius = 20
        btn1.layer.masksToBounds = true
        btn1.frame = CGRect(x: 100, y: self.view.frame.maxY-100, width: 80, height: 40)
        self.view.addSubview(btn1)
        btn1.addTarget(self, action: #selector(touchPoint(_:)), for: .touchUpInside)
        
        let btn2 = UIButton(type: .custom)
        btn2.setTitle("中间的", for: .normal)
        btn2.backgroundColor = UIColor.blue
        btn2.layer.cornerRadius = 20
        btn2.layer.masksToBounds = true
        btn2.frame = CGRect(x: 240, y: self.view.frame.maxY-300, width: 80, height: 40)
        self.view.addSubview(btn2)
        btn2.addTarget(self, action: #selector(touchPoint(_:)), for: .touchUpInside)
        
    }

    @objc fileprivate func touchPoint(_ sender: UIButton) {
        let maskView = TipMaskView(frame: UIScreen.main.bounds, tapFrame: sender.frame)
        maskView.open(text: "悟空和唐僧一起上某卫视非诚勿扰.悟空上台,24盏灯全灭。理由:\n1.没房没车只有一根破棍. \n2.保镖职业危险.\n3.动不动打妖精,对女生不温柔. \n4.坐过牢,曾被压五指山下500年。\n\n唐僧上台，哗!灯全亮。 理由:\n1.公务员； \n2.皇上兄弟，后台最硬 \n3.精通梵文等外语 \n4.长得帅 \n5.最关键一点：有宝马！")
    }

}

