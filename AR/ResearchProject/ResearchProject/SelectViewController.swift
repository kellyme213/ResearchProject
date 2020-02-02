//
//  SelectViewController.swift
//  ResearchProject
//
//  Created by Michael Kelly on 1/20/20.
//  Copyright © 2020 Michael Kelly. All rights reserved.
//

import Foundation
import UIKit

class SelectViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var selectView: SelectView!
    @IBOutlet var table: UITableView!
    @IBOutlet var text: UITextField!
    @IBOutlet var sceneLabel: UILabel!
    
    var urlPaths: [URL] = []
    
    var selectedScene: String!
    var selectedProject: String!
    
    override func viewDidLoad() {
        
        urlPaths = getFilesWithFileType(folder: SCENE_FOLDER_NAME, fileType: "usdz")

        text.delegate = self
        table.delegate = self
        table.dataSource = self
        
        if (selectedScene != nil)
        {
            sceneLabel.text! = selectedScene
        }
        
        if (selectedProject != nil)
        {
            text.text! = selectedProject
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        selectedProject = textField.text!
        return text.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        selectedProject = textField.text!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        let cellText = cell.textLabel!.text!
        selectedScene = cellText.split(separator: ".")[0].description
        sceneLabel.text = selectedScene
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlPaths.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = urlPaths[indexPath.row].pathComponents.last!
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toARView")
        {
            let view = segue.destination as! ARViewController
            view.projectName = selectedProject
            view.sceneName = selectedScene
            view.take = generateTakeNumberForScene(sceneName: selectedScene, projectName: selectedProject)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return selectedProject != nil && selectedScene != nil
    }
}
