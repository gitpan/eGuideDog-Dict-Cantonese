use 5.008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'eGuideDog::Dict::Cantonese',
    'VERSION_FROM'	=> 'Cantonese.pm', # finds $VERSION
    'PREREQ_PM'		=> {}, # e.g., Module::Name => 1.1
    'PM'                => {'Cantonese.pm' => '$(INST_LIBDIR)/Cantonese.pm',
                            'zhy_list' => '$(INST_LIBDIR)/Cantonese/zhy_list'},
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'Cantonese.pm', # retrieve abstract from module
       AUTHOR     => 'Cameron Wong <hgn823-perl@yahoo.com.cn>') : ()),
);
