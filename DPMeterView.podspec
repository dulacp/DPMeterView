Pod::Spec.new do |s|
  s.name     = 'DPMeterView'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'Display gauge-style meter views in an intuitive way with smooth animations.'
  s.homepage = 'https://github.com/dulaccc/DPMeterView'
  s.authors  = { 'Pierre Dulac' => 'pierre@dulaccc.me' }
  s.source   = { :git => 'https://github.com/dulaccc/DPMeterView.git', :tag => '0.0.1' }
  s.source_files = 'DPMeterView'
  s.requires_arc = true

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.frameworks = 'QuartzCore', 'CoreMotion'
end