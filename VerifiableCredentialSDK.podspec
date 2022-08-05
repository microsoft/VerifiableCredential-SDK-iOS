Pod::Spec.new do |s|
    s.name= 'VerifiableCredentialSDK'
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
      :commit => 'b638010',
      :submodules => true
    }
    # s.prepare_command = "sed -i '' -e 's:include/::g' ./**/**/**/*.c\nsed -i '' -e 's:include/::g' ./**/**/**/**/**/*.h"
    
  
    # s.subspec 'VCCrypto' do |cs|
    #   cs.source_files= 'VCCrypto/VCCrypto/**/*.swift'
    #   cs.platform = '13.0'
    #   cs.dependency 'VerifiableCredentialSDK/Secp256k1'
    # end
    
    s.subspec 'Secp256k1' do |cs|
      cs.library = 'c++'
    #   cs.header_mappings_dir = '.'
      cs.public_header_files = 'Submodules/Secp256k1/bitcoin-core/secp256k1/include/secp256k1.h'
      cs.compiler_flags =
      "-Wno-shorten-64-to-32",
      "-Wno-conditional-uninitialized",
      "-Wno-long-long",
      "-Wno-overlength-strings",
      "-Wno-unused-function"
      cs.source_files = ['Submodules/Secp256k1/bitcoin-core/secp256k1/**/*.{c,h}']
      cs.exclude_files = [  
        "Submodules/Secp256k1/bitcoin-core/secp256k1/src/bench_ecdh.c",
        "Submodules/Secp256k1/bitcoin-core/secp256k1/src/bench_ecmult.c",
        "Submodules/Secp256k1/bitcoin-core/secp256k1/src/bench_internal.c",
        "Submodules/Secp256k1/bitcoin-core/secp256k1/src/bench_recover.c",
        "Submodules/Secp256k1/bitcoin-core/secp256k1/src/bench_schnorrsig.c",
        "Submodules/Secp256k1/bitcoin-core/secp256k1/src/bench_sign.c",
        "Submodules/Secp256k1/bitcoin-core/secp256k1/src/bench_verify.c",
        "Submodules/Secp256k1/bitcoin-core/secp256k1/src/tests.c",
        "Submodules/Secp256k1/bitcoin-core/secp256k1/src/selftest.h",
        "Submodules/Secp256k1/bitcoin-core/secp256k1/src/testrand_impl.h",
        "Submodules/Secp256k1/bitcoin-core/secp256k1/src/testrand.h",
        "Submodules/Secp256k1/bitcoin-core/secp256k1/src/*test*.h",
        "Submodules/Secp256k1/bitcoin-core/secp256k1/src/valgrind_ctime_test.c",
        "Submodules/Secp256k1/bitcoin-core/secp256k1/src/gen_context.c",
        "Submodules/Secp256k1/bitcoin-core/secp256k1/src/tests_exhaustive.c",
        "Submodules/Secp256k1/bitcoin-core/secp256k1/contrib/*.{c, h}"
     ]
      cs.preserve_paths = 'Submodules/Secp256k1/bitcoin-core/secp256k1/**/*.{h,c}'
      cs.prefix_header_contents = '#define USE_NUM_NONE 1 
#define ECMULT_WINDOW_SIZE 15 
#define LIBSECP256K1_CONFIG_H'
        #   '#define USE_NUM_GMP 0',
        # '#define ECMULT_WINDOW_SIZE 15',
        # '#define USE_NUM_NONE 1',
        # '#define LIBSECP256K1_CONFIG_H',
        # '#define ECMULT_GEN_PREC_BITS 4',
        # '#define USE_FIELD_INV_BUILTIN 1',
        # '#define USE_SCALAR_INV_BUILTIN 1',
        #   '#define HAVE_DLFCN_H 1',
        #   '#define HAVE_INTTYPES_H 1',
        #   '#define HAVE_MEMORY_H 1',
        #   '#define HAVE_STDINT_H 1',
        #   '#define HAVE_STDLIB_H 1',
        #   '#define HAVE_STRINGS_H 1',
        #   '#define HAVE_STRING_H 1',
        #   '#define HAVE_SYS_STAT_H 1',
        #   '#define HAVE_SYS_TYPES_H 1',
        #   '#define HAVE_UNISTD_H 1',
        #   '#define LT_OBJDIR ".libs/"',
        #   '#define PACKAGE "libsecp256k1"',
        #   '#define PACKAGE_BUGREPORT ""',
        #   '#define PACKAGE_NAME "libsecp256k1"',
        #   '#define PACKAGE_STRING "libsecp256k1 0.1"',
        #   '#define PACKAGE_TARNAME "libsecp256k1"',
        #   '#define PACKAGE_URL ""',
        #   '#define PACKAGE_VERSION "0.1"',
        #   '#define STDC_HEADERS 1',
        #   '#define VERSION "0.1"'
        cs.xcconfig = {
            'USE_HEADERMAP' => 'NO',
            'HEADER_SEARCH_PATHS' => '${PODS_ROOT}/Secp256k1',
            'USER_HEADER_SEARCH_PATHS' => '${PODS_ROOT}/Secp256k1/include'
          }
    end
    
    #s.dependency 'PromiseKit'
  end
  