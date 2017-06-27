import UIKit
import PNChart

class StatisticsViewController: UIViewController {
    private let barChartLeftMargin: CGFloat = 35.0
    private let barChartRightMargin: CGFloat = 10.0

    private var viewModel = StatisticsViewModel()
    private var complaints311Chart: PNBarChart?
    private var complaintsBoroughChart: PNPieChart?
    private var compliments311Chart: PNBarChart?
    
    var transitionOperator = TransitionOperator()
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var complaints311Segment: UISegmentedControl!
    @IBOutlet weak var complaintsBoroughSegment: UISegmentedControl!
    @IBOutlet weak var compliments311Segment: UISegmentedControl!
    @IBOutlet weak var complaints311Holder: UIView!
    @IBOutlet weak var complaintsBoroughHolder: UIView!
    @IBOutlet weak var compliments311Holder: UIView!
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var toViewController : UITableViewController
        
        toViewController = mainStoryboard.instantiateViewControllerWithIdentifier("sidebar") as! UITableViewController
        
        self.modalPresentationStyle = UIModalPresentationStyle.Custom
        toViewController.transitioningDelegate = self.transitionOperator
        self.presentViewController(toViewController, animated: true, completion: nil)
    }
    
    @IBAction func complaints311Action(sender: UISegmentedControl) {
        let parentWidth = (complaints311Chart?.frame.size.width)! - barChartLeftMargin - barChartRightMargin
        
        switch sender.selectedSegmentIndex {
        case 0:
            complaints311Chart?.updateChartData(viewModel.complaints311Data.week)
            complaints311Chart?.xLabels = viewModel.complaints311Data.xLabels(type: .Week)
            complaints311Chart?.barWidth = viewModel.complaints311Data.barWidth(type: .Week, parentWidth: parentWidth)
            complaints311Chart?.strokeColors = viewModel.complaints311Data.colors(type: .Week)
            break
        case 1:
            complaints311Chart?.updateChartData(viewModel.complaints311Data.month)
            complaints311Chart?.xLabels = viewModel.complaints311Data.xLabels(type: .Month)
            complaints311Chart?.barWidth = viewModel.complaints311Data.barWidth(type: .Month, parentWidth: parentWidth)
            complaints311Chart?.strokeColors = viewModel.complaints311Data.colors(type: .Month)
            break
        case 2:
            complaints311Chart?.updateChartData(viewModel.complaints311Data.year)
            complaints311Chart?.xLabels = viewModel.complaints311Data.xLabels(type: .Year)
            complaints311Chart?.barWidth = viewModel.complaints311Data.barWidth(type: .Year, parentWidth: parentWidth)
            complaints311Chart?.strokeColors = viewModel.complaints311Data.colors(type: .Year)
            break
        case 3:
            complaints311Chart?.updateChartData(viewModel.complaints311Data.fiveYears)
            complaints311Chart?.xLabels = viewModel.complaints311Data.xLabels(type: .FiveYears)
            complaints311Chart?.barWidth = viewModel.complaints311Data.barWidth(type: .FiveYears, parentWidth: parentWidth)
            complaints311Chart?.strokeColors = viewModel.complaints311Data.colors(type: .FiveYears)
            break
        default: break
        }
        
        complaints311Chart?.strokeChart()
    }
    
    @IBAction func complaintsBoroughAction(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            complaintsBoroughChart?.updateChartData(viewModel.complaintsBoroughData.week)
            break
        case 1:
            complaintsBoroughChart?.updateChartData(viewModel.complaintsBoroughData.month)
            break
        case 2:
            complaintsBoroughChart?.updateChartData(viewModel.complaintsBoroughData.year)
            break
        case 3:
            complaintsBoroughChart?.updateChartData(viewModel.complaintsBoroughData.fiveYears)
            break
        default: break
        }
        
        complaintsBoroughChart?.strokeChart()
    }
    
    @IBAction func compliments311Action(sender: UISegmentedControl) {
        let parentWidth = (compliments311Chart?.frame.size.width)! - barChartLeftMargin - barChartRightMargin
        
        switch sender.selectedSegmentIndex {
        case 0:
            compliments311Chart?.updateChartData(viewModel.compliments311Data.week)
            compliments311Chart?.xLabels = viewModel.compliments311Data.xLabels(type: .Week)
            compliments311Chart?.barWidth = viewModel.compliments311Data.barWidth(type: .Week, parentWidth: parentWidth)
            compliments311Chart?.strokeColors = viewModel.compliments311Data.colors(type: .Week)
            break
        case 1:
            compliments311Chart?.updateChartData(viewModel.compliments311Data.month)
            compliments311Chart?.xLabels = viewModel.compliments311Data.xLabels(type: .Month)
            compliments311Chart?.barWidth = viewModel.compliments311Data.barWidth(type: .Month, parentWidth: parentWidth)
            compliments311Chart?.strokeColors = viewModel.compliments311Data.colors(type: .Month)
            break
        case 2:
            compliments311Chart?.updateChartData(viewModel.compliments311Data.year)
            compliments311Chart?.xLabels = viewModel.compliments311Data.xLabels(type: .Year)
            compliments311Chart?.barWidth = viewModel.compliments311Data.barWidth(type: .Year, parentWidth: parentWidth)
            compliments311Chart?.strokeColors = viewModel.compliments311Data.colors(type: .Year)
            break
        case 3:
            compliments311Chart?.updateChartData(viewModel.compliments311Data.fiveYears)
            compliments311Chart?.xLabels = viewModel.compliments311Data.xLabels(type: .FiveYears)
            compliments311Chart?.barWidth = viewModel.compliments311Data.barWidth(type: .FiveYears, parentWidth: parentWidth)
            compliments311Chart?.strokeColors = viewModel.compliments311Data.colors(type: .FiveYears)
            break
        default: break
        }
        
        compliments311Chart?.strokeChart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 250.0/255.0, green: 199.0/255.0, blue: 26.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.hidden = true
        let barBackgroundImage = UIImage(named: "Top Navigation Bar")!.resizableImageWithCapInsets(UIEdgeInsets(), resizingMode: .Stretch)
        navBar.setBackgroundImage(barBackgroundImage, forBarMetrics: .Default)
        
        // Fetching Data
        if Reachability.connectedToNetwork() {
            viewModel.fetchData(){ self.updateUI() }
        }
        else {
            let alert = UIAlertController(title: "311 Data Fail", message: "Please check your internet connection", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
        
        customizeUI()
    }
    
    private func updateUI() {
        dispatch_async(dispatch_get_main_queue()) {
            self.complaints311Action(self.complaints311Segment)
            self.complaintsBoroughAction(self.complaintsBoroughSegment)
            self.compliments311Action(self.compliments311Segment)
        }
    }
    
    private func customizeUI() {
        // UI Setup
        scrollView.contentSize = CGSizeMake(320, 900)
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        
        // First Bar Chart
        complaints311Chart = PNBarChart(frame: CGRectMake(8, 73, screenWidth * 0.9, 149)) // Chart width is 90% of the screen width
        complaints311Holder.addSubview(complaints311Chart!)
        complaints311Chart?.backgroundColor = .clearColor()
        complaints311Chart?.showLabel = true
        complaints311Chart?.showChartBorder = false
        complaints311Chart?.isGradientShow = false
        complaints311Chart?.isShowNumbers = false
        complaints311Chart?.yLabelSum = 5
        complaints311Chart?.yChartLabelWidth = 30.0
        complaints311Chart?.chartMarginLeft = barChartLeftMargin
        complaints311Chart?.chartMarginRight = barChartRightMargin
        complaints311Chart?.chartMarginTop = 5.0
        complaints311Chart?.chartMarginBottom = 10.0
        complaints311Chart?.barBackgroundColor = .clearColor()
        
        complaints311Chart?.strokeChart()
        complaints311Chart?.delegate = self
        
        // Second Bar Chart
        compliments311Chart = PNBarChart(frame: CGRectMake(8, 73, screenWidth * 0.9, 149))
        compliments311Holder.addSubview(compliments311Chart!)
        compliments311Chart?.backgroundColor = .clearColor()
        compliments311Chart?.showLabel = true
        compliments311Chart?.showChartBorder = false
        compliments311Chart?.isGradientShow = false
        compliments311Chart?.isShowNumbers = false
        compliments311Chart?.yLabelSum = 3
        compliments311Chart?.yChartLabelWidth = 30.0
        compliments311Chart?.chartMarginLeft = barChartLeftMargin
        compliments311Chart?.chartMarginRight = barChartRightMargin
        compliments311Chart?.chartMarginTop = 3.0
        compliments311Chart?.chartMarginBottom = 10.0
        compliments311Chart?.barBackgroundColor = .clearColor()
        
        compliments311Chart?.strokeChart()
        compliments311Chart?.delegate = self
        
        // Pie Chart
        complaintsBoroughChart = PNPieChart(frame: CGRectMake(8, 83, 288, 270))
        complaintsBoroughChart?.center = CGPointMake(screenWidth / 2 - 5, 218) // 83(y) + 270/2 (half of the height) = 218
        complaintsBoroughHolder.addSubview(complaintsBoroughChart!)
        complaintsBoroughChart?.backgroundColor = .clearColor()
        complaintsBoroughChart?.showAbsoluteValues = false
        complaintsBoroughChart?.showOnlyValues = true
        complaintsBoroughChart?.shouldHighlightSectorOnTouch = false
        complaintsBoroughChart?.labelPercentageCutoff = 0.05
        
        complaintsBoroughChart?.strokeChart()
        complaintsBoroughChart?.delegate = self
    }
}

// MARK: Navigation bar delegate
extension StatisticsViewController {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

// MARK: PNChartDelegate
extension StatisticsViewController: PNChartDelegate {
    
}

// MARK: struct for Charts Data
enum BarChartDataType: Int {
    case Week = 7
    case Month = 4
    case Year = 12
    case FiveYears = 5
}

extension BarChartData {
    private func day(days: Int) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        
        let calendar = NSCalendar.currentCalendar()
        return dateFormatter.stringFromDate(calendar.dateByAddingUnit(.Day, value: -1 * days, toDate: NSDate(), options: []) ?? NSDate())
    }
    
    private func month(months: Int) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        let calendar = NSCalendar.currentCalendar()
        let monthStr = dateFormatter.stringFromDate(calendar.dateByAddingUnit(.Month, value: -1 * months, toDate: NSDate(), options: []) ?? NSDate())
        return monthStr.substringToIndex(monthStr.startIndex.advancedBy(1))
    }
    
    private func year(years: Int) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        let calendar = NSCalendar.currentCalendar()
        return dateFormatter.stringFromDate(calendar.dateByAddingUnit(.Year, value: -1 * years, toDate: NSDate(), options: []) ?? NSDate())
    }
}

struct BarChartData {
    var week = [NSNumber](count: 7, repeatedValue: 0)
    var month = [NSNumber](count: 4, repeatedValue: 0)
    var year = [NSNumber](count: 12, repeatedValue: 0)
    var fiveYears = [NSNumber](count: 5, repeatedValue: 0)
    
    func colors(type type: BarChartDataType) -> [UIColor] {
        var colorArray = [UIColor]()
        
        for index in 0..<type.rawValue {
            colorArray.append((index % 2 == 0) ? .taxiGreen() : .taxiBlue())
        }
        
        return colorArray
    }
    
    func xLabels(type type: BarChartDataType) -> [String] {
        var xLabels = [String]()
        
        for index in 0..<type.rawValue {
            switch type {
            case .Week:
                xLabels.append(day(index + 1))
                break
            case .Month:
                xLabels.append("Week \(abs(index - 4))") // Just show 'Week 4-1'
                break
            case .Year:
                xLabels.append(month(index))
                break
            default:
                xLabels.append(year(index))
                break
            }
        }
        
        return xLabels
    }
    
    func barWidth(type type: BarChartDataType, parentWidth: CGFloat) -> CGFloat {
        return (parentWidth / CGFloat(type.rawValue))
    }
}

struct PieChartData {
    var week = [PNPieChartDataItem](count: 6, repeatedValue: PNPieChartDataItem())
    var month = [PNPieChartDataItem](count: 6, repeatedValue: PNPieChartDataItem())
    var year = [PNPieChartDataItem](count: 6, repeatedValue: PNPieChartDataItem())
    var fiveYears = [PNPieChartDataItem](count: 6, repeatedValue: PNPieChartDataItem())
}