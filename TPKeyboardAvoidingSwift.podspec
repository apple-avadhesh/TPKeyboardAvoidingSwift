#
# Be sure to run `pod lib lint TPKeyboardAvoidingSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TPKeyboardAvoidingSwift'
  s.version          = '3.0'
  s.summary          = 'TPKeyboardAvoiding in Swift 4.2'
  s.description      = 'Solution for moving text fields out of the way of the keyboard in iOS. - TPKeyboardAvoiding. written in swift. Visit https://github.com/michaeltyson/TPKeyboardAvoiding for Obj-C source'

  s.homepage         = 'https://github.com/Avadhesh/TPKeyboardAvoidingSwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Avadhesh' => 'apple.avadhesh@gmail.com' }
  s.source           = { :git => 'https://github.com/Avadhesh/TPKeyboardAvoidingSwift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'TPKeyboardAvoidingSwift/Classes/**/*'
end
