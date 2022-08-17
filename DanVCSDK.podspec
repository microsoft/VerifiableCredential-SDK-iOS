Pod::Spec.new do |s|
    s.name= 'VerifiableCredentialSDK'
    s.version= '3.5.1'
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
      :commit => 'a66f103',
      :submodules => true
    }
  
    # s.subspec 'VCCrypto' do |cs|
    #   cs.source_files= 'VCCrypto/VCCrypto/**/*.swift'
    #   cs.platform = :ios, '11.0'
    #   cs.dependency 'VerifiableCredentialSDK/Secp256k1'
    # end
    
    s.subspec 'Secp256k1' do |cs|
        cs.header_mappings_dir = 'Submodules/Secp256k1/bitcoin-core/secp256k1'
      cs.public_header_files = 'Submodules/Secp256k1/bitcoin-core/secp256k1/include/secp256k1.h'
      cs.source_files =
      #'Submodules/Secp256k1/Secp256k1/*.h',
      #'Submodules/Secp256k1/bitcoin-core/secp256k1/contrib/lax_der_parsing.h',
      #'Submodules/Secp256k1/bitcoin-core/secp256k1/contrib/lax_der_privatekey_parsing.c',
      #'Submodules/Secp256k1/bitcoin-core/secp256k1/contrib/lax_der_parsing.c',
      #'Submodules/Secp256k1/bitcoin-core/secp256k1/contrib/lax_der_privatekey_parsing.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/include/secp256k1_ecdh.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/include/secp256k1_schnorrsig.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/include/secp256k1_recovery.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/include/secp256k1_extrakeys.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/include/secp256k1_preallocated.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/include/secp256k1.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/scalar_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/field_10x26_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/scratch.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/ecmult_gen_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/field_10x26.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/scalar_8x32_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/field_5x52.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/num_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/field.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/field_5x52_asm_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/field_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/scalar_4x64.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/basic-config.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/num.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/field_5x52_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/ecmult_const_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/secp256k1.c',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/ecdsa.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/scalar.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/ecdsa_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/ecmult_gen.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/scalar_low_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/hash_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/ecmult.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/scratch_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/ecmult_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/group.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/util.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/assumptions.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/field_5x52_int128_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/scalar_4x64_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/group_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/ecmult_const.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/modules',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/num_gmp.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/hash.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/eckey_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/num_gmp_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/scalar_8x32.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/scalar_low.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/eckey.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/modules/recovery/main_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/modules/ecdh/main_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/modules/extrakeys/main_impl.h',
      'Submodules/Secp256k1/bitcoin-core/secp256k1/src/modules/schnorrsig/main_impl.h',
      cs.library = 'c++'
      cs.prefix_header_contents =
          '#define LIBSECP256K1_CONFIG_H',
          '#define ECMULT_GEN_PREC_BITS 4',
          '#define ECMULT_WINDOW_SIZE 15',
          '#define HAVE_DLFCN_H 1',
          '#define HAVE_INTTYPES_H 1',
          '#define HAVE_MEMORY_H 1',
          '#define HAVE_STDINT_H 1',
          '#define HAVE_STDLIB_H 1',
          '#define HAVE_STRINGS_H 1',
          '#define HAVE_STRING_H 1',
          '#define HAVE_SYS_STAT_H 1',
          '#define HAVE_SYS_TYPES_H 1',
          '#define HAVE_UNISTD_H 1',
          '#define LT_OBJDIR ".libs/"',
          '#define PACKAGE "libsecp256k1"',
          '#define PACKAGE_BUGREPORT ""',
          '#define PACKAGE_NAME "libsecp256k1"',
          '#define PACKAGE_STRING "libsecp256k1 0.1"',
          '#define PACKAGE_TARNAME "libsecp256k1"',
          '#define PACKAGE_URL ""',
          '#define PACKAGE_VERSION "0.1"',
          '#define STDC_HEADERS 1',
          '#define USE_FIELD_INV_BUILTIN 1',
          '#define USE_NUM_NONE 1',
          '#define USE_SCALAR_INV_BUILTIN 1',
          '#define VERSION "0.1"'
        cs.pod_target_xcconfig = {
            'USE_HEADERMAP' => 'NO',
            'HEADER_SEARCH_PATHS' => 'Submodules/Secp256k1/bitcoin-core/secp256k1'
          }
          cs.private_header_files = 'Submodules/Secp256k1/bitcoin-core/secp256k1/include/secp256k1.h'
    end
    
    #s.dependency 'PromiseKit'
  end
  