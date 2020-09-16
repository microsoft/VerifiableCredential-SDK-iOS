Pod::Spec.new do |spec|

  spec.name         = "VCUseCase"
  spec.version      = "0.0.1-beta.0"
  spec.summary      = "An SDK to manage your Verifiable Credential use cases."
  spec.description  = <<-DESC "An SDK to manage your Verifiable Credential Use Cases."
                   DESC
  spec.homepage     = "https://github.com/microsoft/VerifiableCredential-SDK-iOS"
  spec.license      = "MIT"
  spec.author             = { "sydneymorton" => "symorton@microsoft.com", "dangodb" => "dangodb@microsoft.com" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/microsoft/VerifiableCredential-SDK-iOS" }
  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"
  spec.framework  = "Foundation"
  spec.dependency "PromiseKit", "6.8"

end
