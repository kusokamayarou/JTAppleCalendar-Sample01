//
//  ConfigureViewController.swift
//  JTAppleCalendar-Sample01
//
//  Created by Yukihiro Uekama on 2019/06/21.
//  Copyright © 2019 Yukihiro Uekama. All rights reserved.
//

import UIKit
import Eureka
import MXLCalendarManagerSwift
import SVProgressHUD

// [Swift]作業効率10倍アップ？フォーム作成ライブラリー「Eureka」チュートリアル
// https://blog.personal-factory.com/2015/12/29/eureka-tutorial/

// Swiftで入力フォームが簡単に作れる「Eureka」の使い方 - Qiita
// https://qiita.com/wadaaaan/items/6538584816ef44690b5c

class ConfigureViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // [iOS] 超簡単に処理中のUIを出せるSVProgressHUDについて ｜ DevelopersIO
        // https://dev.classmethod.jp/smartphone/ios-svprogresshud/
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setBackgroundColor(.clear)
        //
        let calendarSec = Section("Calendar Settings")
        // [ライブラリ] EurekaのSegmentedRowを使用する方法 - Swift Life
        // http://swift.hiros-dot.net/?p=448
        calendarSec.append(SegmentedRow<String> { row in
            //row.title = "Beginning of the week"
            row.title = "Begin"
            row.options = CALENDAR_DAYSOFWEEK_STRING
            var daysOfWeek: Int = UserDefaults.standard.integer(forKey: USERDEFAULTS_KEY_CALENDAR_DAYSOFWEEK)
            if daysOfWeek < 0 || daysOfWeek >= CALENDAR_DAYSOFWEEK_STRING.count {
                daysOfWeek = 0
            }
            row.value = CALENDAR_DAYSOFWEEK_STRING[daysOfWeek]
            }.onChange { row in
                if let _value = row.value, let _index = CALENDAR_DAYSOFWEEK_STRING.firstIndex(of: _value) {
                    UserDefaults.standard.set(_index, forKey: USERDEFAULTS_KEY_CALENDAR_DAYSOFWEEK)
                }
        })
        // [ライブラリ] Eurekaの導入と利用〜その4　行の値を取得する - Swift Life
        // http://swift.hiros-dot.net/?p=303
        calendarSec.append(ButtonRow("PublicHolidaysButtonRow") {
            $0.title = "Update public holidays information."
            }.onCellSelection { _, _ in
                let path: String = "https://calendar.google.com/calendar/ical/ja.japanese%23holiday%40group.v.calendar.google.com/public/basic.ics"
                let request = URLRequest(url: (URLComponents(string: path)?.url!)!, timeoutInterval: 10.0)
                let task = URLSession.shared.downloadTask(with: request) { URL, response, error in
                    // ramonvasc/MXLCalendarManagerSwift: Swift version of the MXLCalendarManager (https://github.com/KiranPanesar/MXLCalendarManager)
                    // https://github.com/ramonvasc/MXLCalendarManagerSwift
                    MXLCalendarManager().scanICSFileatLocalPath(filePath: URL!.path) { calendar, _ in
                        guard let calendar = calendar else {
                            return
                        }
                        var publicHolidays: [Int: CalendarEvent] = [:]
                        for event in calendar.events {
                            if let _eventStartDate = event.eventStartDate {
                                publicHolidays[_eventStartDate.hashValue] = CalendarEvent(
                                    eventDescription: event.eventDescription ?? String(),
                                    eventEndDate: event.eventEndDate,
                                    eventIsAllDay: event.eventIsAllDay ?? Bool(),
                                    eventLocation: event.eventLocation ?? String(),
                                    eventRecurrenceID: event.eventRecurrenceID ?? String(),
                                    eventStartDate: event.eventStartDate,
                                    eventStatus: event.eventStatus ?? String(),
                                    eventSummary: event.eventSummary ?? String(),
                                    eventUniqueID: event.eventUniqueID ?? String(),
                                    rruleString: event.rruleString ?? String()
                                )
                            }
                        }
                        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: publicHolidays), forKey: USERDEFAULTS_KEY_CALENDAR_PUBLICHOLIDAYS)
                        SVProgressHUD.dismiss()
                    }
                }
                task.resume()
                SVProgressHUD.show()
        })
        form +++ calendarSec
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
