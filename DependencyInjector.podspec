Pod::Spec.new do |s|
s.name = "DependencyInjector"
s.version = "2.2.1"
s.summary = "Dependency injector made in pure swift"
s.homepage = "https://github.com/Digipolitan/dependency-injector"
s.license = { :type => "BSD", :file => "LICENSE" }
s.author = { "Digipolitan" => "contact@digipolitan.com" }
s.source = { :git => "https://github.com/Digipolitan/dependency-injector.git", :tag => "v#{s.version}" }
s.source_files = 'Sources/**/*.{swift,h}'
s.ios.deployment_target = '8.0'
s.osx.deployment_target = '10.10'
s.watchos.deployment_target = '2.0'
s.tvos.deployment_target = '9.0'
s.swift_version = '5.0'
end
