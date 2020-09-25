Pod::Spec.new do |spec|

  spec.name         = "VCEntities"
  spec.version      = "0.0.1-beta.0"
  spec.summary      = "An SDK to define Verifiable Credential Entities."
  spec.description  = <<-DESC "An SDK to define Verifiable Credential Entities."
                   DESC
  spec.homepage     = "https://github.com/microsoft/VerifiableCredential-SDK-iOS"
  spec.license      = "MIT"
  spec.author             = { "sydneymorton" => "symorton@microsoft.com", "dangodb" => "dangodb@microsoft.com" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/microsoft/VerifiableCredential-SDK-iOS" }
  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"
  spec.framework  = "Foundation"

end
