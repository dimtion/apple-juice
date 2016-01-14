//
// TodayViewController.swift
// Apple Juice
// https://github.com/raphaelhanneken/apple-juice
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Raphael Hanneken
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding, NCWidgetListViewDelegate,
NCWidgetSearchViewDelegate {

  @IBOutlet var listViewController: NCWidgetListViewController!

  var searchController: NCWidgetSearchViewController?

  // MARK: - NSViewController

  override var nibName: String? {
    return "TodayViewController"
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Set up the widget list view controller.
    // The contents property should contain an object for each row in the list.
    self.listViewController.contents = self.getBatteryInformation()
  }

  override func dismissViewController(viewController: NSViewController) {
    super.dismissViewController(viewController)

    // The search controller has been dismissed and is no longer needed.
    if viewController == self.searchController {
      self.searchController = nil
    }
  }

  // MARK: - NCWidgetProviding

  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
    // Refresh the widget's contents in preparation for a snapshot.
    // Call the completion handler block after the widget's contents have been
    // refreshed. Pass NCUpdateResultNoData to indicate that nothing has changed
    // or NCUpdateResultNewData to indicate that there is new data since the
    // last invocation of this method.

    // Always pass .NewData since at least the current charge will have changed at every call.
    completionHandler(.NewData)
  }

  func widgetMarginInsetsForProposedMarginInsets(var defaultMarginInset: NSEdgeInsets)
    -> NSEdgeInsets {
      // Override the left margin so that the list view is flush with the edge.
      defaultMarginInset.left = 0
      return defaultMarginInset
  }

  var widgetAllowsEditing: Bool {
    // Return true to indicate that the widget supports editing of content and
    // that the list view should be allowed to enter an edit mode.
    return true
  }

  func widgetDidBeginEditing() {
    // The user has clicked the edit button.
    // Put the list view into editing mode.
    self.listViewController.editing = true
  }

  func widgetDidEndEditing() {
    // The user has clicked the Done button, begun editing another widget,
    // or the Notification Center has been closed.
    // Take the list view out of editing mode.
    self.listViewController.editing = false
  }

  // MARK: - NCWidgetListViewDelegate

  func widgetList(list: NCWidgetListViewController!, viewControllerForRow row: Int)
    -> NSViewController! {
      // Return a new view controller subclass for displaying an item of widget
      // content. The NCWidgetListViewController will set the representedObject
      // of this view controller to one of the objects in its contents array.
      return ListRowViewController()
  }

  func widgetListPerformAddAction(list: NCWidgetListViewController!) {
    // The user has clicked the add button in the list view.
    // Display a search controller for adding new content to the widget.
    self.searchController = NCWidgetSearchViewController()
    self.searchController!.delegate = self

    // Present the search view controller with an animation.
    // Implement dismissViewController to observe when the view controller
    // has been dismissed and is no longer needed.
    self.presentViewControllerInWidget(self.searchController)
  }

  func widgetList(list: NCWidgetListViewController!, shouldReorderRow row: Int) -> Bool {
    // Return true to allow the item to be reordered in the list by the user.
    return true
  }

  func widgetList(list: NCWidgetListViewController!, didReorderRow row: Int, toRow newIndex: Int) {
    // The user has reordered an item in the list.
  }

  func widgetList(list: NCWidgetListViewController!, shouldRemoveRow row: Int) -> Bool {
    // Return true to allow the item to be removed from the list by the user.
    return true
  }

  func widgetList(list: NCWidgetListViewController!, didRemoveRow row: Int) {
    // The user has removed an item from the list.
  }

  // MARK: - NCWidgetSearchViewDelegate

  func widgetSearch(searchController: NCWidgetSearchViewController!,
    searchForTerm searchTerm: String!, maxResults max: Int) {
      // The user has entered a search term. Set the controller's
      // searchResults property to the matching items.
      searchController.searchResults = []
  }

  func widgetSearchTermCleared(searchController: NCWidgetSearchViewController!) {
    // The user has cleared the search field. Remove the search results.
    searchController.searchResults = nil
  }

  func widgetSearch(searchController: NCWidgetSearchViewController!,
    resultSelected object: AnyObject!) {
      // The user has selected a search result from the list.
  }

  ///  Creates an array of all the information to display within the today widget.
  ///
  ///  - returns: The array with the necessary RowViewControllerType's.
  func getBatteryInformation() -> [RowViewControllerType] {
    let contents = [
      RowViewControllerType(withType: .TimeRemaining),
      RowViewControllerType(withType: .CurrentCharge),
      RowViewControllerType(withType: .PowerUsage),
      RowViewControllerType(withType: .Capacity),
      RowViewControllerType(withType: .CycleCount),
      RowViewControllerType(withType: .Temperature),
      RowViewControllerType(withType: .Source),
      RowViewControllerType(withType: .DesignCycleCount),
      RowViewControllerType(withType: .DesignCapacity)
    ]
    return contents
  }
}