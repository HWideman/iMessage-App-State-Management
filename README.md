# iMessage App State Management
When building an iMessage application for iOS 10, I needed a method of managing the application's state in order to manage transitions between views and to keep the application aware of its state at any given time.

I achieved this by using enum for state identification, and a set of protocols that can be passed to the application's viewcontrollers in order to trigger explicitly defined transitions.

## MessagesViewController.swift
All iMessage apps, or MessagesExtensions, implement a MessagesViewController. This ViewController acts as the root of the application, and provides methods for the developer to manage the presentation style(compact in keyboard space or expanded to full screen), and other iMessage functions like message send and receive status.

### Important bits:
MessagesAppIntegrationProtocol - a series of functions which help manage the app's presentation state for when certain views require an expanded or compact presentation.
EIMStateProtocol - variables and functions which help maintain the application's state and state history.

## MainViewController.swift
The application's main view controller. This ViewController includes delegates for the MessagesAppIntegration and EIMState protocols. It also houses the MainPageViewController, which is used to display the application's Views and responsible for transition animations between views.

### Important bits:
UserInterfaceFlowProtocol - A series of functions for managing views, and explicit functions for transitioning between application views. This protocol is accessed as a delegate by the application's ViewControllers to manage state within the main interfaces.

## MainPageViewController.swift
A UIPageViewController used to provide a navigation structure for the app's views.

## About the App This Was Designed for:
EmojiInkMessenger was an app that allowed you to draw on a canvas using Emoji. Your drawings could then be saved as a sticker within the application and shared with friends via iMessages.
