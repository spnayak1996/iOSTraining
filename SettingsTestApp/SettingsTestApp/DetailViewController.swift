//
//  DetailViewController.swift
//  SettingsTestApp
//
//  Created by vinsol on 04/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: UIViewController {
    func reload()
}

protocol DetailViewCellDelegate: UIViewController {
    func setValue(_ val: Bool)
}

class DetailViewController: UIViewController {
    
    private enum DetailCellType {
        case indicator(title: String)
        case navigable(title: String, detail: String)
        case slider
        case text(detail: String)
        case selection(detail: String)
    }
    
    private struct Texts {
        static let general: [(String, [DetailCellType])] = [("", [DetailCellType.text(detail: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")])]
        static let wallpaper: [(String, [DetailCellType])] = [("", [DetailCellType.text(detail: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).")])]
        static let display: [(String, [DetailCellType])] = [("BRIGHTNESS", [DetailCellType.slider]),("",[DetailCellType.navigable(title: "Night Shift", detail: "Off")]),("",[DetailCellType.navigable(title: "Auto-Lock", detail: "1 Minute")]),("",[DetailCellType.navigable(title: "Text Size", detail: ""),DetailCellType.indicator(title: "Bold Text")]),("DISPLAY ZOOM",[DetailCellType.navigable(title: "View", detail: "Standard")])]
        static let bluetooth: [(String, [DetailCellType])] = [("",[DetailCellType.indicator(title: "Bluetooth")])]
        static let mobileData: [(String, [DetailCellType])] = [("",[DetailCellType.indicator(title: "Mobile Data"),DetailCellType.navigable(title: "Mobile Data Options", detail: "Roaming On"),DetailCellType.text(detail: "Turn off mobile data to restrict all data to Wifi, including email, web browsing, and push notifications.")])]
        static let notification: [(String, [DetailCellType])] = [("",[DetailCellType.indicator(title: "Notification")])]
        static let doNotDisturb: [(String, [DetailCellType])] = [("",[DetailCellType.indicator(title: "Do Not Disturb"),DetailCellType.text(detail: "When Do Not Disturb is enabled, calls and alerts that arrive while locked will be silenced, and a moon icon will appear in the status bar.")])]
        
        
        static func generateCarrierArray() -> [(String, [DetailCellType])] {
            var array = [DetailCellType]()
            
            for carrier in Enums.Carrier.returnIterator() {
                array.append(DetailCellType.selection(detail: carrier.description()))
            }
            return [("",array)]
        }
        
        static func generateNetworkArray() -> [(String, [DetailCellType])] {
            var array = [DetailCellType]()
            
            for network in Enums.Networks.returnIterator() {
                array.append(DetailCellType.selection(detail: network.description()))
            }
            return [("",array)]
        }
        
    }
    weak var delegate: DetailViewControllerDelegate?
    
    private(set) var detail = Enums.Detail.general {
        didSet {
            setDataSource()
        }
    }
    private var data = DataHandler.shared
    
    private var dataSource: [(String, [DetailCellType])] = Texts.general
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setTitle()
    }
    
    
    
    private func setTitle() {
        self.title = detail.title()
    }
    
    func setUp(detail: Enums.Detail) {
        self.detail = detail
    }
    
    private func setDataSource() {
        switch detail {
        case .general:
            dataSource = Texts.general
        case .wallpaper:
            dataSource = Texts.wallpaper
        case .wifi:
            dataSource = Texts.generateNetworkArray()
        case .bluetooth:
            dataSource = Texts.bluetooth
        case .mobileData:
            dataSource = Texts.mobileData
        case .carrier:
            dataSource = Texts.generateCarrierArray()
        case .notification:
            dataSource = Texts.notification
        case .donotDisturb:
            dataSource = Texts.doNotDisturb
        case .display:
            dataSource = Texts.display
        default:
            break
        }
    }

}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemBackground
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].1.count
    }
    
    private func getCurrentSelectedIndex() -> Int {
        switch detail {
        case .carrier:
            return data.carrier.rawValue
        case .wifi:
            return data.wifi.rawValue
        default:
            return -1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dataSource[indexPath.section].1[indexPath.row] {
        case .navigable(title: let title, detail: let detail):
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailNavigableTableViewCell.cellId) as! DetailNavigableTableViewCell
            cell.setUp(title: title, detail: detail)
            return cell
        case .indicator(title: let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailSwitchTableViewCell.cellId) as! DetailSwitchTableViewCell
            cell.setUp(title: title, on: DataHandler.getOnOrOffState(detail: detail))
            cell.delegate = self
            return cell
        case .selection(detail: let detail):
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailSelectionTableViewCell.cellId) as! DetailSelectionTableViewCell
            cell.setUp(title: detail, ticked: getCurrentSelectedIndex() == indexPath.row ? true : false)
            return cell
        case .text(detail: let detail):
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailTextTableViewCell.cellId) as! DetailTextTableViewCell
            cell.setUp(text: detail)
            return cell
        case .slider:
            return tableView.dequeueReusableCell(withIdentifier: DetailSliderTableViewCell.cellId) as! DetailSliderTableViewCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch detail {
        case .carrier:
            rectifySelection(cell: tableView.cellForRow(at: indexPath) as! DetailSelectionTableViewCell, tableView: tableView)
            data.carrier = Enums.Carrier(rawValue: indexPath.row)
            DataHandler.saveSettings(detail: .carrier)
        case .wifi:
            rectifySelection(cell: tableView.cellForRow(at: indexPath) as! DetailSelectionTableViewCell, tableView: tableView)
            data.wifi = Enums.Networks(rawValue: indexPath.row)
            DataHandler.saveSettings(detail: .wifi)
        default:
            break
        }
    }
    
    private func rectifySelection(cell: DetailSelectionTableViewCell, tableView: UITableView) {
        for i in 0...4 {
            (tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? DetailSelectionTableViewCell)?.removeSelection()
        }
        cell.setSelection()
        delegate?.reload()
    }
    
    
}

extension DetailViewController: DetailViewCellDelegate {
    func setValue(_ val: Bool) {
        switch detail {
        case .notification:
            data.notification = val
            DataHandler.saveSettings(detail: .notification)
        case .mobileData:
            data.mobileData = val
            DataHandler.saveSettings(detail: .mobileData)
        case .bluetooth:
            data.bluetooth = val
            DataHandler.saveSettings(detail: .bluetooth)
        case .donotDisturb:
            data.doNotDisturb = val
            DataHandler.saveSettings(detail: .donotDisturb)
        default:
            break
        }
        delegate?.reload()
    }
}
