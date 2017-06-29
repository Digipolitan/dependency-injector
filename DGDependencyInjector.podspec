Pod::Spec.new do |s|
s.name = "DGDependencyInjector"
s.version = "2.0.0"
s.summary = "Dependency injector made in pure swift"
s.homepage = "https://github.com/Digipolitan/dependency-injector-swift"
s.license = { :type => "BSD", :file => "LICENSE" }
s.author = { "Digipolitan" => "contact@digipolitan.com" }
s.source = { :git => "https://github.com/Digipolitan/dependency-injector-swift.git", :tag => "v#{s.version}" }
s.source_files = 'Sources/**/*.{swift,h}'
s.ios.deployment_target = '8.0'
s.osx.deployment_target = '10.10'
s.watchos.deployment_target = '2.0'
s.tvos.deployment_target = '9.0'
s.requires_arc = true
end
