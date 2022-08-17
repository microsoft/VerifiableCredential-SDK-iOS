Pod::Spec.new do |s|
  s.name= 'VerifiableCredentialSDK'
  s.version= '0.0.1'
  s.license= 'MIT'
  s.summary= 'This SDK is used in the Microsoft Authenticator app in order to interact with verifiable credentials and Decentralized Identifiers (DIDs) on the ION network. It can be integrated with any app to provide interactions using verifiable credentials.'
  s.homepage= 'https://github.com/microsoft/VerifiableCredential-SDK-iOS'
  s.authors= {
    'dangodb' => 'dangodb@microsoft.com'
  }
  s.documentation_url= 'https://github.com/microsoft/VerifiableCredential-SDK-iOS'
  

  s.platform = :ios, '11.0'
  s.source= {
    :http => 'https://dangodbbugbash.azurewebsites.net/VerifiableCredentialSDK.zip',
  }

  s.subspec 'VCNetworking' do |cs|
    cs.vendored_frameworks = 'VCNetworking.xcframework'
    cs.platform = :ios, '11.0'
    cs.dependency 'VerifiableCredentialSDK/VCEntities'
    cs.dependency 'VerifiableCredentialSDK/PromiseKit'
  end

  s.subspec 'PromiseKit' do |cs|
    cs.vendored_frameworks = 'PromiseKit.xcframework'
    cs.platform = :ios, '11.0'
  end

  s.subspec 'VCEntities' do |cs|
    cs.vendored_frameworks = 'VCEntities.xcframework'
    cs.platform = :ios, '11.0'
    cs.dependency 'VerifiableCredentialSDK/VCCrypto'
    cs.dependency 'VerifiableCredentialSDK/VCToken'
  end

  s.subspec 'VCServices' do |cs|
    cs.vendored_frameworks = 'VCServices.xcframework'
    cs.platform = :ios, '11.0'
    cs.dependency 'VerifiableCredentialSDK/VCEntities'
    cs.dependency 'VerifiableCredentialSDK/VCNetworking'
    cs.dependency 'VerifiableCredentialSDK/Secp256k1'
    cs.dependency 'VerifiableCredentialSDK/PromiseKit'
  end

  s.subspec 'VCToken' do |cs|
    cs.vendored_frameworks = 'VCToken.xcframework'
    cs.platform = :ios, '11.0'
    cs.dependency 'VerifiableCredentialSDK/VCCrypto'
  end

  s.subspec 'VCCrypto' do |cs|
    #cs.source = { :http => 'http://VCCrypto.framework.zip' }
    cs.platform = :ios, '11.0'
    cs.vendored_frameworks = 'VCCrypto.xcframework'
    cs.dependency 'VerifiableCredentialSDK/Secp256k1'
  end

  s.subspec 'Secp256k1' do |cs|
    #cs.source = { :http => 'http://VCCrypto.framework.zip' }
    cs.platform = :ios, '11.0'
    cs.vendored_frameworks = 'Secp256k1.xcframework'
  end
  
  
  
  #s.dependency 'PromiseKit'
end
