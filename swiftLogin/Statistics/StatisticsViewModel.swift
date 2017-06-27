import Foundation
import PNChart
import SVProgressHUD

class StatisticsViewModel: NSObject {
    private lazy var client = SODAClient(domain: "data.cityofnewyork.us", token: "W02HeBxzjX45QMaAL5N8Y6bkl")
    private var dataset: SODAQuery?
    private var progressAccumulate = 0
    private let progressLimit = 60
    private var completionHandler: ((Void) -> Void)?
    private var isFetching = false
    private var timer: NSTimer?
    private let progressValues = [0, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
        20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
        30, 30, 30, 30, 30, 30, 30, 30, 30, 30,
        40, 40, 40, 40, 40, 40, 40, 40, 40, 40,
        50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
        60, 60, 60, 60, 60, 60, 60, 60, 60, 60]
    
    var complaints311Data = BarChartData()
    var complaintsBoroughData = PieChartData()
    var compliments311Data = BarChartData()
    
    override init() {
        super.init()
        dataset = client.queryDataset("erm2-nwe9") //fhrw-4uyv
    }
    
    func fetchData(completionHandler: (Void) -> Void) {
        self.completionHandler = completionHandler
        isFetching = true
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.populateComplaints311()
            self.populateComplaintsBorough()
            self.populateCompliments311()
        }
        
        // Run the timer and if the data is not yet fetched, dismiss
        timer = NSTimer.scheduledTimerWithTimeInterval(30.0, target: self, selector: "checkFetchingStatus", userInfo: nil, repeats: false)
    }
    
    func checkFetchingStatus() {
        if isFetching {
            SVProgressHUD.dismiss()
            completionHandler?()
        }
    }
    
    private func populateComplaints311() {
        for index in 0...6 {
            dataset?
                .filter("agency = 'TLC' AND created_date <= '\(daysAgo(index))' AND created_date >= '\(daysAgo(index + 1))' AND (complaint_type = 'Taxi Complaint' OR complaint_type = 'For Hire Vehicle Complaint' OR complaint_type = 'Taxi Report')")
                .select("count(agency) AS c")
                .get({ res in
                    switch res {
                    case .Dataset (let data):
                        self.complaints311Data.week[index] = NSNumber(integer:(data[0]["c"] as! NSString).integerValue)
                        break
                    default: break
                    }
                    
                    self.progressing()
                })
        }
        
        for index in 0...3 {
            dataset?
                .filter("agency = 'TLC' AND created_date <= '\(weeksAgo(index))' AND created_date >= '\(weeksAgo(index + 1))' AND (complaint_type = 'Taxi Complaint' OR complaint_type = 'For Hire Vehicle Complaint' OR complaint_type = 'Taxi Report')")
                .select("count(agency) AS c")
                .get({ res in
                    switch res {
                    case .Dataset (let data):
                        self.complaints311Data.month[index] = NSNumber(integer:(data[0]["c"] as! NSString).integerValue)
                        break
                    default: break
                    }
                    
                    self.progressing()
                })
        }
        
        for index in 0...11 {
            dataset?
                .filter("agency = 'TLC' AND created_date <= '\(monthsAgo(index))' AND created_date >= '\(monthsAgo(index + 1))' AND (complaint_type = 'Taxi Complaint' OR complaint_type = 'For Hire Vehicle Complaint' OR complaint_type = 'Taxi Report')")
                .select("count(agency) AS c")
                .get({ res in
                    switch res {
                    case .Dataset (let data):
                        self.complaints311Data.year[index] = NSNumber(integer:(data[0]["c"] as! NSString).integerValue)
                        break
                    default: break
                    }
                    
                    self.progressing()
                })
        }
        
        for index in -1...3 {
            dataset?
                .filter("agency = 'TLC' AND created_date <= '\(yearsAgo(index))' AND created_date >= '\(yearsAgo(index + 1))' AND (complaint_type = 'Taxi Complaint' OR complaint_type = 'For Hire Vehicle Complaint' OR complaint_type = 'Taxi Report')")
                .select("count(agency) AS c")
                .get({ res in
                    switch res {
                    case .Dataset (let data):
                        self.complaints311Data.fiveYears[index+1] = NSNumber(integer:(data[0]["c"] as! NSString).integerValue)
                        break
                    default: break
                    }
                    
                    self.progressing()
                })
        }
    }
    
    private func populateComplaintsBorough() {
        dataset?
            .filter("agency = 'TLC' AND created_date <= '\(daysAgo(0))' AND created_date >= '\(daysAgo(7))'")
            .select("borough, count(agency)")
            .group("borough")
            .get({ res in
                switch res {
                case .Dataset (let data):
                    for index in 0..<data.count {
                        let d = data[index]
                        let city = d["borough"] as! String
                        self.complaintsBoroughData.week[index] = PNPieChartDataItem(value: CGFloat(((d["count_agency"] ?? "1") as! NSString).doubleValue), color: self.colorForPie(city: city), description: self.descriptionForPie(index: index))
                    }
                    break
                default: break
                }
                
                self.progressing()
            })
        
        
        dataset?
            .filter("agency = 'TLC' AND created_date <= '\(weeksAgo(0))' AND created_date >= '\(weeksAgo(4))'")
            .select("borough, count(agency)")
            .group("borough")
            .get({ res in
                switch res {
                case .Dataset (let data):
                    for index in 0..<data.count {
                        let d = data[index]
                        let city = d["borough"] as! String
                        self.complaintsBoroughData.month[index] = PNPieChartDataItem(value: CGFloat(((d["count_agency"] ?? "1") as! NSString).doubleValue), color: self.colorForPie(city: city), description: self.descriptionForPie(index: index))
                    }
                    break
                default: break
                }
                
                self.progressing()
            })
        
        
        dataset?
            .filter("agency = 'TLC' AND created_date <= '\(monthsAgo(0))' AND created_date >= '\(monthsAgo(12))'")
            .select("borough, count(agency)")
            .group("borough")
            .get({ res in
                switch res {
                case .Dataset (let data):
                    for index in 0..<data.count {
                        let d = data[index]
                        let city = d["borough"] as! String
                        self.complaintsBoroughData.year[index] = PNPieChartDataItem(value: CGFloat(((d["count_agency"] ?? "1") as! NSString).doubleValue), color: self.colorForPie(city: city), description: self.descriptionForPie(index: index))
                    }
                    break
                default: break
                }
                
                self.progressing()
            })
        
        dataset?
            .filter("agency = 'TLC' AND created_date <= '\(yearsAgo(-1))' AND created_date >= '\(yearsAgo(4))'")
            .select("borough, count(agency)")
            .group("borough")
            .get({ res in
                switch res {
                case .Dataset (let data):
                    for index in 0..<data.count {
                        let d = data[index]
                        let city = d["borough"] as! String
                        self.complaintsBoroughData.fiveYears[index] = PNPieChartDataItem(value: CGFloat(((d["count_agency"] ?? "1") as! NSString).doubleValue), color: self.colorForPie(city: city), description: self.descriptionForPie(index: index))
                    }
                    break
                default: break
                }
                
                self.progressing()
            })
    }
    
    private func populateCompliments311() {
        for index in 0...6 {
            dataset?
                .filter("agency = 'TLC' AND created_date <= '\(daysAgo(index + 1))' AND created_date >= '\(daysAgo(index + 2))' AND complaint_type = 'Taxi Compliment'")
                .select("count(agency) AS c")
                .get({ res in
                    switch res {
                    case .Dataset (let data):
                        self.compliments311Data.week[index] = NSNumber(integer:(data[0]["c"] as! NSString).integerValue)
                        break
                    default: break
                    }
                    
                    self.progressing()
                })
        }
        
        for index in 0...3 {
            dataset?
                .filter("agency = 'TLC' AND created_date <= '\(weeksAgo(index))' AND created_date >= '\(weeksAgo(index + 1))' AND complaint_type = 'Taxi Compliment'")
                .select("count(agency) AS c")
                .get({ res in
                    switch res {
                    case .Dataset (let data):
                        self.compliments311Data.month[index] = NSNumber(integer:(data[0]["c"] as! NSString).integerValue)
                        break
                    default: break
                    }
                    
                    self.progressing()
                })
        }
        
        for index in 0...11 {
            dataset?
                .filter("agency = 'TLC' AND created_date <= '\(monthsAgo(index))' AND created_date >= '\(monthsAgo(index + 1))' AND complaint_type = 'Taxi Compliment'")
                .select("count(agency) AS c")
                .get({ res in
                    switch res {
                    case .Dataset (let data):
                        self.compliments311Data.year[index] = NSNumber(integer:(data[0]["c"] as! NSString).integerValue)
                        break
                    default: break
                    }
                    
                    self.progressing()
                })
        }
        
        for index in -1...3 {
            dataset?
                .filter("agency = 'TLC' AND created_date <= '\(yearsAgo(index))' AND created_date >= '\(yearsAgo(index + 1))' AND complaint_type = 'Taxi Compliment'")
                .select("count(agency) AS c")
                .get({ res in
                    switch res {
                    case .Dataset (let data):
                        self.compliments311Data.fiveYears[index+1] = NSNumber(integer:(data[0]["c"] as! NSString).integerValue)
                        break
                    default: break
                    }
                    
                    self.progressing()
                })
        }
    }
    
    private func colorForPie(city city: String) -> UIColor {
        switch city {
        case "STATEN ISLAND": return .taxiRed()
        case "Unspecified": return .taxiPurple()
        case "MANHATTAN": return .taxiBlue()
        case "BROOKLYN": return .taxiOrange()
        case "QUEENS": return .taxiGreen()
        default: return .taxiYellow()
        }
    }
    
    private func descriptionForPie(index index: Int) -> String {
        switch index {
        case 0: return "STATEN ISLAND"
        case 1: return "Unspecified"
        case 2: return "MANHATTAN"
        case 3: return "BROOKLYN"
        case 4: return "QUEENS"
        default: return "BRONX"
        }
    }
    
    private func progressing() {
        progressAccumulate++
        
        let progress = Float(progressValues[progressAccumulate]) / Float(progressLimit)
        SVProgressHUD.showProgress(progress, status: "Loading Data", maskType: .Black)
        
        if progressAccumulate >= progressLimit {
            isFetching = false
            timer?.invalidate()
            
            SVProgressHUD.dismiss()
            completionHandler?()
        }
    }
}

// MARK: Date helper
extension StatisticsViewModel {
    private func dateFormatter() -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
    
    private func today() -> String {
        return dateFormatter().stringFromDate(NSDate())
    }
    
    private func daysAgo(days: Int) -> String {
        let calendar = NSCalendar.currentCalendar()
        let dateStr = dateFormatter().stringFromDate(calendar.dateByAddingUnit(.Day, value: -1 * days, toDate: NSDate(), options: []) ?? NSDate())
        return dateStr
    }
    
    private func weeksAgo(weeks: Int) -> String {
        let calendar = NSCalendar.currentCalendar()
        return dateFormatter().stringFromDate(calendar.dateByAddingUnit(.WeekOfMonth, value: -1 * weeks, toDate: NSDate(), options: []) ?? NSDate())
    }
    
    private func monthsAgo(months: Int) -> String {
        let calendar = NSCalendar.currentCalendar()
        return dateFormatter().stringFromDate(calendar.dateByAddingUnit(.Month, value: -1 * months, toDate: NSDate(), options: []) ?? NSDate())
    }
    
    private func yearsAgo(years: Int) -> String {
        if years < 0 {
            return dateFormatter().stringFromDate(NSDate())
        }
        else {
            let calendar = NSCalendar.currentCalendar()
            let comps = calendar.components(.Year, fromDate: NSDate())
            let pureDate = calendar.dateFromComponents(comps)
            return dateFormatter().stringFromDate(calendar.dateByAddingUnit(.Year, value: -1 * years, toDate: pureDate!, options: []) ?? NSDate())
        }
    }
}

extension UIColor {
    convenience init(R: CGFloat, G: CGFloat, B: CGFloat) {
        self.init(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: 1.0)
    }
    
    private class func colorWithHex(hex: UInt) -> UIColor {
        return UIColor(R: CGFloat((hex & 0xFF0000) >> 16), G: CGFloat((hex & 0x00FF00) >> 8), B: CGFloat(hex & 0x0000FF))
    }
    
    class func taxiBlue() -> UIColor {
        return UIColor.colorWithHex(0x85bfe7)
    }
    
    class func taxiGreen() -> UIColor {
        return UIColor.colorWithHex(0x73bf45)
    }
    
    class func taxiYellow() -> UIColor {
        return UIColor.colorWithHex(0xffd300)
    }
    
    class func taxiOrange() -> UIColor {
        return UIColor.colorWithHex(0xfbaa1a)
    }
    
    class func taxiRed() -> UIColor {
        return UIColor.colorWithHex(0xdf7a7a)
    }
    
    class func taxiPurple() -> UIColor {
        return UIColor.colorWithHex(0xa671c8)
    }
}