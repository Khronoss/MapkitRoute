//
//  RoadsListViewController.swift
//  MapKitRoute
//
//  Created by Anthony Merle on 29/10/2017.
//  Copyright © 2017 Anthony Merle. All rights reserved.
//

import UIKit

class RoadsListViewController: UITableViewController {
	private var roads: [Road] = []
	
	private let showRoadSegue = "show_road"
	private var presentingRoad: Road?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		title = "Roadz !!"
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		loadRoads()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == showRoadSegue,
			let destination = segue.destination as? RoadDetailsViewController,
			let presentingRoad = self.presentingRoad {
			destination.road = presentingRoad
		}
	}
	
	private func presentRoad(_ road: Road) {
		presentingRoad = road
		performSegue(withIdentifier: showRoadSegue, sender: self)
	}
	
	private func loadRoads() {
//		roads = FakeRoadsCreator.fakeRoads()

		let savedRoadsService = SavedRoadsService()
		roads = savedRoadsService.savedRoads()
		
        tableView.reloadData()
	}
}

extension RoadsListViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return roads.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "roadCell", for: indexPath)
		let road = roads[indexPath.row]
		
		cell.textLabel?.text = road.name
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let road = roads[indexPath.row]
		
		presentRoad(road)
	}
}
