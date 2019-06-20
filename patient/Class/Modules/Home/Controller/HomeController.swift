//
//  HomeController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result
import Alamofire

class HomeController: BaseController {
    
    struct Test: ModelProtocol {
        var exitedNum: Int = 0
        var siteName: String = ""
        var piName: String = "陈韵岱教授"
        var isStart: String = "Y"
        var projectStatusName: String = "入组阶段"
        var researcher: String = ""
        var involvedNum: Int = 0
        var plannedNum: Int = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let str = """
        中国人民解放军总医院    陈韵岱（PI）    入组阶段    250    218
        首都医科大学附属北京友谊医院    沈爱东    入组阶段    80    69
        大连医科大学附属第一医院    黄榕翀    入组阶段    30    18
        吉林大学中日联谊医院    张文琪    入组阶段    30    17
        大连大学附属中山医院    张曙影    入组阶段    60    52
        南京大学医学院附属鼓楼医院    徐标    入组阶段    40    28
        青岛大学附属医院    廉哲勋    入组阶段    70    54
        青岛市市立医院    邵一兵    入组阶段    50    35
        山西省心血管病医院    王敬萍    入组阶段    70    58
        上海交通大学附属第六人民医院    沈成兴    入组阶段    30    19
        西安市第三医院    程康    入组阶段    30    17
        云南省第一人民医院    张云梅    入组阶段    160    141
        吉林大学第一医院    郑杨    入组阶段    60    41
        首都医科大学附属北京潞河医院    郭金成    入组阶段    30    17
        浙江大学医学院附属邵逸夫医院    傅国胜    入组阶段    10    3
        """
        
        let arr = str.components(separatedBy: "\n")
        
        var ta = [Test]()
        print("[")
        for a in arr {
            let b = a.components(separatedBy: "    ")
            
            var t = Test()
            t.siteName = b[0] as! String
            t.researcher = b[1] as! String
            t.plannedNum = Int(b[3] as! String)!
            t.involvedNum = Int(b[4] as! String)!
            
            print("{\n\t\"plannedNum\": \(t.plannedNum),\n\t\"involvedNum\": \(t.involvedNum),\n\t\"exitedNum\": \(t.exitedNum),\n\t\"siteName\": \"\(t.siteName)\",\n\t\"isStart\": \"\(t.isStart)\",\n\t\"researcher\": \"\(t.researcher)\",\n\t\"piName\": \"\(t.piName)\",\n\t\"projectStatusName\": \"\(t.projectStatusName)\"\n},")
            
            ta.append(t)
        }
        
        print("]")
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        test()
    }

    func test() {
        present(BaseNavigationController(rootViewController: LoginController()), animated: true, completion: nil)
    }
}
