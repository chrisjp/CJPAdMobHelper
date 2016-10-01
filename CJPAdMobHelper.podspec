Pod::Spec.new do |s|
  s.name = 'CJPAdMobHelper'
  s.version = '1.0'
  s.summary = 'A simple way to add AdMob banner ads to a UINavigationController based app.'
  s.description = <<-DESC
CJPAdMobHelper is a singleton class enabling easy implementation of AdMob banner ads in your UINavigationController based iOS app.

* No need to add any views or constraints to your current storyboards.
* Supports all devices and orientations.
* Automatically hides from view when there are no ads to display.
* Support for removing ads permanently, for example if you have set up an in-app purchase to remove them.
                  DESC
  s.screenshots = ['http://i.imgur.com/daylYpc.png', 'http://i.imgur.com/RwaWJXh.png']
  s.license = 'MIT'
  s.author = { 'Chris Phillips' => 'chrisjp88@gmail.com' }
  s.social_media_url = 'http://twitter.com/ChrisJP88'
  s.platform = :ios, '8.0'
  s.source = {
      :git => 'https://github.com/chrisjp/CJPAdMobHelper.git',
      :tag => s.version.to_s
  }
  s.source_files = 'CJPAdMobHelper/*.{h,m}'
  s.requires_arc = true
  s.dependency 'Google-Mobile-Ads-SDK'
  s.pod_target_xcconfig = {
      'FRAMEWORK_SEARCH_PATHS' => '$(PODS_ROOT)/Google-Mobile-Ads-SDK/**',
      'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES'
  }

end