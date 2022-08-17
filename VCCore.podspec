Pod::Spec.new do |s|
    s.name= 'VCCore'
    s.version= '0.0.1'
    s.license= 'MIT'
    s.summary= 'AlamofireImage is an image component library for Alamofire'
    s.homepage= 'https://github.com/Alamofire/AlamofireImage'
    s.social_media_url= 'http://twitter.com/AlamofireSF'
    s.authors= {
      'Alamofire Software Foundation' => 'info@alamofire.org'
    }
    s.documentation_url= 'https://alamofire.github.io/AlamofireImage/'
    s.source= {
      :git => 'https://github.com/microsoft/VerifiableCredential-SDK-iOS.git',
      :commit => '9309ce8',
      :submodules => true
    }

    s.swift_version = '5.0'

    s.ios.deployment_target  = '13.0'

    s.default_subspecs = 'VCEntities'

    # s.preserve_paths = 'VCCrypto/**/*.swift'
    # s.source_files = 'VCCrypto/VCCrypto/**/*.swift'

    # s.source_files = 'VCToken/VCToken/**/*.swift'

    s.subspec 'VCCrypto' do |cs|
        cs.name = 'VCCrypto'
        cs.preserve_paths = 'VCCrypto/**/*.swift'
        cs.source_files= 'VCCrypto/VCCrypto/**/*.swift'
      #   cs.platform = '13.0'
        # cs.dependency 'VerifiableCredentialSDK/Secp256k1'
    end 

    s.subspec 'VCToken' do |cs|
        cs.name = 'VCToken'
        cs.preserve_paths = 'VCToken/**/*.swift'
        cs.source_files= 'VCToken/VCToken/**/*.swift'
        cs.dependency 'VCCore/VCCrypto'
      #   cs.platform = '13.0'
        # cs.dependency 'VerifiableCredentialSDK/Secp256k1'
    end


    s.subspec 'VCEntities' do |cs|
        cs.name = 'VCEntities'
        cs.preserve_paths = 'VCEntities/**/*.swift'
        cs.source_files= 'VCEntities/VCEntities/**/*.swift'
        cs.dependency 'VCCore/VCToken'
        cs.dependency 'VCCore/VCCrypto'
        cs.dependency 'PromiseKit'
        # cs.ios.deployment_target  = '13.0'
        # cs.dependency 'VerifiableCredentialSDK/Secp256k1'
    end

    s.subspec 'VCNetworking' do |cs|
        cs.name = 'VCNetworking'
        cs.preserve_paths = 'VCNetworking/**/*.swift'
        cs.source_files= 'VCNetworking/VCNetworking/**/*.swift'
        cs.dependency 'VCCore/VCEntities'
        cs.dependency 'PromiseKit'
        # cs.ios.deployment_target  = '13.0'
        # cs.dependency 'VerifiableCredentialSDK/Secp256k1'
    end
end
  