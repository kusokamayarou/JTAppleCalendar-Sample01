//
//  CalendarCollectionViewCell.swift
//  JTAppleCalendar-Sample01
//
//  Created by Yukihiro Uekama on 2019/06/21.
//  Copyright © 2019 Yukihiro Uekama. All rights reserved.
//

import UIKit
import JTAppleCalendar

// patchthecode/JTAppleCalendar: The Unofficial Apple iOS Swift Calendar View. Swift calendar Library. iOS calendar Control. 100% Customizable
// https://github.com/patchthecode/JTAppleCalendar
// Home · patchthecode/JTAppleCalendar Wiki
// https://github.com/patchthecode/JTAppleCalendar/wiki
// [開発日記]JTAppleCalendarを使ってみた - Qiita
// https://qiita.com/tanirei/items/4baa07d4905fd458500a

class CalendarCollectionViewCell: JTAppleCell {

    @IBOutlet internal weak var baseView: UIView!
    @IBOutlet internal weak var mainView: UIView!
    @IBOutlet internal weak var todayView: UIView!
    @IBOutlet internal weak var eventView: UIView!
    @IBOutlet internal weak var holidayLabel: UILabel!
    @IBOutlet internal weak var dayLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
