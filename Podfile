workspace 'DependencyInjector.xcworkspace'

## Frameworks targets
abstract_target 'Frameworks' do
	use_frameworks!
	target 'DependencyInjector-iOS' do
		platform :ios, '8.0'
	end

	target 'DependencyInjector-watchOS' do
		platform :watchos, '2.0'
	end

	target 'DependencyInjector-tvOS' do
		platform :tvos, '9.0'
	end

	target 'DependencyInjector-OSX' do
		platform :osx, '10.10'
	end
end

## Tests targets
abstract_target 'Tests' do
	use_frameworks!
	target 'DependencyInjectorTests-iOS' do
		platform :ios, '8.0'
	end

	target 'DependencyInjectorTests-tvOS' do
		platform :tvos, '9.0'
	end

	target 'DependencyInjectorTests-OSX' do
		platform :osx, '10.10'
	end
end

## Samples targets
abstract_target 'Samples' do
	use_frameworks!
	target 'DependencyInjectorSample-iOS' do
		project 'Samples/DependencyInjectorSample-iOS/DependencyInjectorSample-iOS'
		platform :ios, '8.0'
	end

	abstract_target 'watchOS' do
		project 'Samples/DependencyInjectorSample-watchOS/DependencyInjectorSample-watchOS'
		target 'DependencyInjectorSample-watchOS' do
			platform :ios, '8.0'
		end

		target 'DependencyInjectorSample-watchOS WatchKit Extension' do
			platform :watchos, '2.0'
		end
	end

	target 'DependencyInjectorSample-tvOS' do
		project 'Samples/DependencyInjectorSample-tvOS/DependencyInjectorSample-tvOS'
		platform :tvos, '9.0'
	end

	target 'DependencyInjectorSample-OSX' do
		project 'Samples/DependencyInjectorSample-OSX/DependencyInjectorSample-OSX'
		platform :osx, '10.9'
	end
end
