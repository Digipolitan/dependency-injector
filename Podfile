workspace 'DGDependencyInjector.xcworkspace'

## Frameworks targets
abstract_target 'Frameworks' do
	use_frameworks!
	target 'DGDependencyInjector-iOS' do
		platform :ios, '8.0'
	end

	target 'DGDependencyInjector-watchOS' do
		platform :watchos, '2.0'
	end

	target 'DGDependencyInjector-tvOS' do
		platform :tvos, '9.0'
	end

	target 'DGDependencyInjector-OSX' do
		platform :osx, '10.9'
	end
end

## Tests targets
abstract_target 'Tests' do
	use_frameworks!
	target 'DGDependencyInjectorTests-iOS' do
		platform :ios, '8.0'
	end

	target 'DGDependencyInjectorTests-tvOS' do
		platform :tvos, '9.0'
	end

	target 'DGDependencyInjectorTests-OSX' do
		platform :osx, '10.9'
	end
end

## Samples targets
abstract_target 'Samples' do
	use_frameworks!
	target 'DGDependencyInjectorSample-iOS' do
		project 'Samples/DGDependencyInjectorSample-iOS/DGDependencyInjectorSample-iOS'
		platform :ios, '8.0'
	end

	abstract_target 'watchOS' do
		project 'Samples/DGDependencyInjectorSample-watchOS/DGDependencyInjectorSample-watchOS'
		target 'DGDependencyInjectorSample-watchOS' do
			platform :ios, '8.0'
		end

		target 'DGDependencyInjectorSample-watchOS WatchKit Extension' do
			platform :watchos, '2.0'
		end
	end

	target 'DGDependencyInjectorSample-tvOS' do
		project 'Samples/DGDependencyInjectorSample-tvOS/DGDependencyInjectorSample-tvOS'
		platform :tvos, '9.0'
	end

	target 'DGDependencyInjectorSample-OSX' do
		project 'Samples/DGDependencyInjectorSample-OSX/DGDependencyInjectorSample-OSX'
		platform :osx, '10.9'
	end
end
