platform :ios, '7.0'

# ignore all warnings from all pods
inhibit_all_warnings!

pod 'Parse'

target :WeeeeeiTests do
  pod 'OCMock'
  pod 'Nocilla'
  pod 'Kiwi/XCTest'
end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Pods-acknowledgements.plist', 'Weeeeei/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
